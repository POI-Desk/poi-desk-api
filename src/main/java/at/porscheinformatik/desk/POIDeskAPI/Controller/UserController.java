package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ModelRepos.LocationRepo;
import at.porscheinformatik.desk.POIDeskAPI.ModelRepos.UserRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Controller
public class UserController
{
    @Autowired
    private UserRepo userRepo;

    @Autowired
    private LocationRepo locationRepo;

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
    public User setdefaultLocation(@Argument UUID userid, @Argument UUID locationid)
    {
        Optional<User> user = userRepo.findById(userid);
        Optional<Location> location = locationRepo.findById(locationid);
        if (user.isEmpty() || location.isEmpty())
            return null;
        user.get().setLocation(location.get());
        User updateduser = user.get();
        userRepo.save(updateduser);
        return updateduser;
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

    @SchemaMapping
    public List<Role> roles(User user) {
        return userRepo.findById(user.getPk_userid()).get().getRoles();
    }

    @SchemaMapping
    public List<Booking> bookings(User user) { return userRepo.findById((user.getPk_userid())).get().getBookings(); }

    @SchemaMapping
    public List<BookingLog> bookinglogs(User user) { return userRepo.findById((user.getPk_userid())).get().getBookinglogs(); }

}
