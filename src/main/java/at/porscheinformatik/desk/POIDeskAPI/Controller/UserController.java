package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.LocationRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.RoleRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.UserRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.AccountRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.Role;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import at.porscheinformatik.desk.POIDeskAPI.Services.UserPageResponseService;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.api.client.googleapis.auth.oauth2.GoogleAuthorizationCodeFlow;
import com.google.api.client.http.javanet.NetHttpTransport;
import com.google.api.client.json.gson.GsonFactory;
import graphql.schema.DataFetchingEnvironment;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.http.ResponseEntity;
import org.springframework.session.Session;
import org.springframework.session.SessionRepository;
import org.springframework.stereotype.Controller;
import org.springframework.http.HttpHeaders;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.context.request.WebRequest;

import java.io.IOException;
import java.util.*;

@Controller
public class UserController {
    /**
     * The user repository
     */
    @Autowired
    private UserRepo userRepo;

    /**
     * The location repository
     */
    @Autowired
    private LocationRepo locationRepo;

    /**
     * The role repository
     */
    @Autowired
    private RoleRepo roleRepo;
    /**
     * The account repository
     */
    @Autowired
    private AccountRepo accountRepo;

    @Autowired
    private SessionRepository sessionRepository;

    /**
     * The currently logged-in user
     */
    private User loggedInUser;

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
        if (u.isEmpty())
            return null;
        return u.get();
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

    @MutationMapping
    public boolean setdefaultLocation(@Argument UUID userid, @Argument UUID locationid)
    {
        Optional<User> user = userRepo.findById(userid);
        Optional<Location> location = locationRepo.findById(locationid);
        if (user.isEmpty() || location.isEmpty())
            return false;
        user.get().setLocation(location.get());
        User updateduser = user.get();
        userRepo.save(updateduser);
        return true;
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
        GoogleAuthorizationCodeFlow a = new GoogleAuthorizationCodeFlow(new NetHttpTransport(), new GsonFactory(), "30449198569-8ti9l20a7quemfkp1phf27fhf546d469.apps.googleusercontent.com","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", scopes);
        var tokenResponse = a.newTokenRequest(authToken).setRedirectUri("http://localhost:5173/api/auth/callback/google/").execute();


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

            // after the successful token request, we create a new account if it doesn't exist yet
            Account account = new Account(userIdentifier,"google", tokenResponse.getAccessToken(), tokenResponse.getRefreshToken());
            accountRepo.save(account);

            // the username should ideally be set by the user themselves, so we temp. set it to the email
            User user = new User(userEmail.split("@")[0], null, roleRepo.findByRolename("Standard"), account);
            userRepo.save(user);

            // session gets created (ideally with the attributeName being the account id and the attribute being the user_data_JWT)
            Session session = sessionRepository.createSession();
            session.setAttribute(account.getPk_accountid().toString(), user_data_JWT); // Set user-specific information as needed
            sessionRepository.save(session);

            // we want to get the response object to add the session cookie to it
            ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.currentRequestAttributes();
            HttpServletResponse response = attributes.getResponse();

            // if the response is null, something is majorly fucked 💀💀💀💀💀
            if (response != null) {
                // this creates a cookie
                Cookie sessionCookie = new Cookie("SESSION_ID", account.getPk_accountid().toString());
                sessionCookie.setHttpOnly(true);
                sessionCookie.setMaxAge(7 * 24 * 60 * 60); // for example, expire in 7 days
                sessionCookie.setPath("/"); // accessible on all paths

                // adds cookie to the response and for some reason it works ¯\_(ツ)_/¯
                response.addCookie(sessionCookie);
                return "Auth successful";
            }
        }
        catch (Exception e){
            e.printStackTrace();
            return "Auth went wrong";
        }

        return "Auth went wrong";
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
}
