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
import org.springframework.stereotype.Controller;

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
    public List<User> getUsersWithADesk() throws ExecutionException, InterruptedException {
        return userService.getUsersWithADesk().get();
    }

    @QueryMapping
    public List<User> getUsersWithNoDesk() throws ExecutionException, InterruptedException {
        return userService.getUsersWithNoDesk().get();
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
