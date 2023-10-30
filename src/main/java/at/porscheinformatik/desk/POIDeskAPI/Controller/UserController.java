package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.LocationRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.RoleRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.UserRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.Role;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.StreamSupport;

@Controller
public class UserController
{
    @Autowired
    private UserRepo userRepo;

    @Autowired
    private LocationRepo locationRepo;

    @Autowired
    private RoleRepo roleRepo;

    private User loggedInUser;

    @QueryMapping
    public User getLoggedInUser() { return loggedInUser; }

    @QueryMapping
    public List<User> getAllUsers() { return (List<User>)userRepo.findAll(); }

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
