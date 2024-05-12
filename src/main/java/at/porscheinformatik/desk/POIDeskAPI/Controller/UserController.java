package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.LocationRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.RoleRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.UserRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.AccountRepo;
import at.porscheinformatik.desk.POIDeskAPI.Helper.AuthHelper;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.Role;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import at.porscheinformatik.desk.POIDeskAPI.Services.MapService;
import at.porscheinformatik.desk.POIDeskAPI.Services.UserPageResponseService;
import com.auth0.jwt.JWT;
import com.auth0.jwt.JWTVerifier;
import com.auth0.jwt.algorithms.Algorithm;
import com.auth0.jwt.exceptions.JWTCreationException;
import com.auth0.jwt.interfaces.DecodedJWT;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import graphql.schema.DataFetchingEnvironment;
import jakarta.servlet.http.HttpServletRequest;
import at.porscheinformatik.desk.POIDeskAPI.Services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.graphql.data.method.annotation.*;
import org.springframework.session.SessionRepository;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.CrossOrigin;
import java.io.IOException;
import java.util.*;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

@Controller
@CrossOrigin(origins = "*")
public class UserController {
    @Autowired
    private UserRepo userRepo;
    @Autowired
    private LocationRepo locationRepo;
    @Autowired
    private RoleRepo roleRepo;
    @Autowired
    private AccountRepo accountRepo;
    @Autowired
    private SessionRepository sessionRepository;
    @Autowired
    private HttpServletRequest request;
    private User loggedInUser;
    @Autowired
    private UserService userService;
    @Autowired
    private MapService mapService;

    /**
     * Getter for the currently logged-in user
     * @return User, currently logged-in user
     */
    @QueryMapping
    public User getLoggedInUser() { return loggedInUser; }

    @QueryMapping
    public UserPageResponseService<User> getAllUsers(@Argument String input, @Argument int pageNumber, @Argument int pageSize) {

        // List<User> userAtBeginning = userRepo.findByUsernameContainsIgnoreCase(input, PageRequest.of(pageNumber, pageSize, Sort.by("username"))).getContent();

        Page<User> userPage = userRepo.findByUsernameStartsWithIgnoreCase(
                input,
                PageRequest.of(pageNumber, pageSize, Sort.by("username"))
        );

        // userAtBeginning.addAll(userPage.getContent());
        // System.out.println(userAtBeginning);

        return new UserPageResponseService<>(userPage.getContent(), userPage.hasNext());

        // return new UserPageResponse<>(userRepo.findByUsernameStartsWithIgnoreCaseOrUsernameContainsIgnoreCase(input, input, PageRequest.of(pageNumber, pageSize, Sort.by("username"))).getContent(), userRepo.findByUsernameStartsWithIgnoreCaseOrUsernameContainsIgnoreCase(input, input, PageRequest.of(pageNumber, pageSize, Sort.by("username"))).hasNext());
    }

    @QueryMapping
    public User getUserById(@Argument UUID id)
    {
        Optional<User> u = userRepo.findById(id);
        return u.orElse(null);
    }

    @QueryMapping
    public List<Role> getRolesOfUser(@Argument UUID id) {
        Optional<User> u = userRepo.findById(id);
        if (u.isEmpty())
            return null;
        User user = u.get();
        return user.getRoles();
    }

    @QueryMapping
    public boolean hasDefaultLocation(@Argument UUID id) {
        Optional<User> u = userRepo.findById(id);
        if (u.isEmpty())
            return false;
        else return u.get().getLocation() != null;
    }

    @QueryMapping
    public List<User> getUsersInTeam() {
        // TODO implement team functionality
        return (List<User>) userRepo.findAll();
    }

    @QueryMapping
    public String authorizeUser(){
        try {
            return AuthHelper.authenticate(request, accountRepo);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @QueryMapping
    public String getUserDataFromGoogle(@Argument String jwt) throws IOException {
        return "";
    }
    public List<User> getUsersWithADeskOnMap(@Argument UUID mapId) throws ExecutionException, InterruptedException {
        return userService.getUsersWithADeskOnMap(mapId).get();
    }

    @QueryMapping
    public List<User> getUsersWithNoDeskOnMap(@Argument UUID mapId) throws ExecutionException, InterruptedException {
        return userService.getUsersWithNoDeskOnMap(mapId).get();
    }

    @QueryMapping
    public User getUserInformation(@Argument String jwt){
        try {
            var check = AuthHelper.authWithJWT(jwt);
            if (check == null)
                return null;
            String useridString = AuthHelper.getUsernameFromJWT(check);
            Optional<User> user = userRepo.findByUsername(useridString).stream().findFirst();
            if (user.isEmpty())
                return null;
            return user.get();

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    @MutationMapping
    //public boolean setdefaultLocation(@Argument UUID userid, @Argument UUID locationid)
    public boolean setdefaultLocation(@Argument UUID locationid)
    {
        try {
            var check = AuthHelper.authenticate(request, accountRepo);
            if (check == null)
                return false;
            String useridString = AuthHelper.getUsernameFromJWT(check);
            Optional<User> user = userRepo.findByUsername(useridString).stream().findFirst();
            Optional<Location> location = locationRepo.findById(locationid);
            if (user.isEmpty() || location.isEmpty())
                return false;
            user.get().setLocation(location.get());
            User updatedUser = user.get();
            userRepo.save(updatedUser);
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @MutationMapping
    public User changeUsername(@Argument UUID id, @Argument String name)
    {
        if (userRepo.findById(id).isEmpty())
            return null;
        User user = userRepo.findById(id).get();
        user.setUsername(name);
        userRepo.save(user);
        return user;
    }

    /**
     * Log in as user, if user with entered username does not exist yet, it will be created and logged in
     * @param username
     * @return User
     */
    @MutationMapping
    public User createOrLoginAsUser(@Argument String username) {
        Optional<User> loggingInUser = userRepo.findByUsername(username).stream().findFirst();

        if (loggingInUser.isEmpty()) loggingInUser = Optional.of(createUser(username));


        this.loggedInUser = loggingInUser.get();
        return loggedInUser;
    }

    @MutationMapping
    public String loginWizzGoogol(@Argument String authToken, DataFetchingEnvironment env) throws IOException {
        // the google auth token workflow
        List<String> scopes = new ArrayList<String>(Arrays.asList("https://www.googleapis.com/auth/userinfo.profile", "https://www.googleapis.com/auth/userinfo.email"));
        Map<String, String> environment_var = System.getenv();
        GoogleAuthorizationCodeFlow a = new GoogleAuthorizationCodeFlow(new NetHttpTransport(),
                new GsonFactory(),
                environment_var.get("GOOGLE_CLIENT_ID"),
                environment_var.get("GOOGLE_CLIENT_SECRET"), scopes);
        var tokenResponse = a.newTokenRequest(authToken).setRedirectUri(environment_var.get("REDIRECT_URI")).execute();

        //get the id token
        String idToken = tokenResponse.getIdToken();

        //split and decode the id token to get the user credentials
        String[] split_string = idToken.split("\\.");
        String user_data_JWT = split_string[1];
        System.out.println(user_data_JWT);
        String body = new String(Base64.getDecoder().decode(user_data_JWT));
        System.out.println("\nDecoded body: " + body);

        // read the json object with this really cool library I found online.
        // hopefully it doesn't have any security vulnerabilities or loses support in the future hehe 🔥🔥🔥
        try{
            ObjectMapper objectMapper = new ObjectMapper();

            JsonNode jsonNode = objectMapper.readTree(body);

            String userEmail = jsonNode.get("email").asText();

            String userIdentifier = jsonNode.get("sub").asText();

            String name = jsonNode.get("name").asText();

            String picture = jsonNode.get("picture").asText();


            // after the successful token request, we create a new account if it doesn't exist yet
            Account account = new Account(userIdentifier,"google", tokenResponse.getAccessToken(), tokenResponse.getRefreshToken());


            // the username should ideally be set by the user themselves, so we temp. set it to the email
            User user = new User(userEmail.split("@")[0], locationRepo.findByLocationname("Wien"), roleRepo.findByRolename("Standard"), account);


            if (!accountRepo.existsById(userIdentifier)){
                accountRepo.save(account);
                userRepo.save(user);
            }

            try{
                Algorithm algorithm = Algorithm.HMAC256("lol"); // TODO: change!!!!!!!
                String token = JWT.create()
                        .withClaim("email", userEmail)
                        .withClaim("name", name)
                        .withClaim("username", userEmail.split("@")[0])
                        .withClaim("location", locationRepo.findByLocationname("Wien").getLocationname())
                        .withClaim("picture", picture)
                        .withClaim("sub", userIdentifier)
                        .withClaim("iss", "POIDesk")
                        .withClaim("aud", "POIDesk")
                        .withClaim("iat", new Date())
                        .withClaim("exp", new Date(System.currentTimeMillis() + 7 * 24 * 60 * 60 * 1000))
                        .sign(algorithm);
                return token;
            }
            catch (JWTCreationException e) {
                e.printStackTrace();
                return null;
            }

        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
     }


    public User createUser(String username) {
        User user = new User();
        user.setUsername(username);
        user.setRoles(roleRepo.findByRolename("Standard"));
        userRepo.save(user);
        return user;
    }

    @SchemaMapping
    public List<Role> roles(User user) {
        return user.getRoles();
    }

    @SchemaMapping
    public List<Booking> bookings(User user) { return user.getBookings(); }

    @SchemaMapping
    public Location location(User user) { return user.getLocation(); }

    @SchemaMapping
    public List<Desk> desks(User user) { return user.getDesks(); }
}
