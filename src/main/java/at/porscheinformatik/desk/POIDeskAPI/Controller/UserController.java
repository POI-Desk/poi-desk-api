package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.LocationRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.RoleRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.UserRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.Role;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import at.porscheinformatik.desk.POIDeskAPI.Services.UserPageResponseService;
import at.porscheinformatik.desk.POIDeskAPI.Services.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.security.crypto.argon2.Argon2PasswordEncoder;
import org.springframework.stereotype.Controller;

import java.util.*;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

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
     * The currently logged-in user
     */
    private User loggedInUser;

    private Argon2PasswordEncoder arg2SpringSecurity = Argon2PasswordEncoder.defaultsForSpringSecurity_v5_8();

    @Autowired
    private UserService userService;

    /**
     * Getter for the currently logged-in user
     * @return User, currently logged-in user
     */
    @QueryMapping
    public User getLoggedInUser() { return loggedInUser; }

    @QueryMapping
    public UserPageResponseService<User> getAllUsers(@Argument String input, @Argument int pageNumber, @Argument int pageSize) {
        Page<User> userPage = userRepo.findByUsernameStartsWithIgnoreCase(
                input,
                PageRequest.of(pageNumber, pageSize, Sort.by("username"))
        );
        return new UserPageResponseService<>(userPage.getContent(), userPage.hasNext());
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

    /**
     * get all users with role Extended
     * @return list of extended users
     */
    @QueryMapping
    public List<User> getExtendedUsers() {
        return userRepo.findByRolesContaining(roleRepo.findByRolename("Extended").stream().findFirst().get());
    }

    @QueryMapping
    public List<User> getAdminUsers() {
        return userRepo.findByRolesContaining(roleRepo.findByRolename("Admin").stream().findFirst().get());
    }

    @QueryMapping
    public List<User> getUsersWithADeskOnMap(@Argument UUID mapId) throws ExecutionException, InterruptedException {
        return userService.getUsersWithADeskOnMap(mapId).get();
    }

    @QueryMapping
    public List<User> getUsersWithNoDeskOnMap(@Argument UUID mapId) throws ExecutionException, InterruptedException {
        return userService.getUsersWithNoDeskOnMap(mapId).get();
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
     * Log in as user
     * @param username
     * @return User
     */
    @MutationMapping
    public User createOrLoginAsUser(@Argument String username, @Argument String password) {
        Optional<User> loggingInUser = userRepo.findByUsername(username).stream().findFirst();
        if (arg2SpringSecurity.matches(password, userRepo.findByUsername(username).stream().findFirst().get().getPassword())) {
            this.loggedInUser = loggingInUser.get();
            return loggedInUser;
        }
        //if (loggingInUser.isEmpty()) loggingInUser = Optional.of(createUser(username));
        return null;
    }

    /**
     * Creates a new user with specified username and permissions
     * @param username
     * @param isExtended
     * @param isAdmin
     * @param isSuperAdmin
     * @return
     */
    @MutationMapping
    public User addUser(@Argument String username, @Argument Boolean isExtended, @Argument Boolean isAdmin, @Argument Boolean isSuperAdmin, @Argument String password) {


        password = arg2SpringSecurity.encode(password);

        List<Role> roles = new ArrayList<>();

        roles.add(roleRepo.findByRolename("Standard").stream().findFirst().get());

        if (isExtended) {
            Role extended = roleRepo.findByRolename("Extended").stream().findFirst().get();
            roles.add(extended);
        }
        if (isAdmin) {
            Role admin = roleRepo.findByRolename("Admin").stream().findFirst().get();
            roles.add(admin);
        }
        if (isSuperAdmin) {
            Role superAdmin = roleRepo.findByRolename("Super Admin").stream().findFirst().get();
            roles.add(superAdmin);
        }

        User user = new User();
        user.setUsername(username);
        user.setRoles(roles);
        user.setPassword(password);
        userRepo.save(user);
        return user;
    }

    @MutationMapping
    public Location setAdminLocation(@Argument UUID userid, @Argument UUID locationid) {
        Location location = locationRepo.findById(locationid).get();
        List<User> emptyList = new ArrayList<>();
        location.setAdmins(emptyList);
        User user = userRepo.findById(userid).get();
        user.setAdminLocation(location);
        userRepo.save(user);
        return location;
    }

    @MutationMapping
    public User removeAdminLocation(@Argument UUID userid) {
        User user = userRepo.findById(userid).get();
        user.setAdminLocation(null);
        userRepo.save(user);
        return user;
    }

    @MutationMapping
    public User changePassword(@Argument UUID userid, @Argument String oldPassword, @Argument String newPassword) {
        newPassword = arg2SpringSecurity.encode(newPassword);
        User user = userRepo.findById(userid).get();
        if (arg2SpringSecurity.matches(oldPassword, user.getPassword()) && !oldPassword.equals(newPassword) && !newPassword.isEmpty()) {
            user.setPassword(newPassword);
            userRepo.save(user);
            return user;
        }
        return null;
    }

    @MutationMapping
    public User resetPassword(@Argument UUID userid, @Argument String newPassword) {
        User user = userRepo.findById(userid).get();
        user.setPassword(arg2SpringSecurity.encode(newPassword));
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
