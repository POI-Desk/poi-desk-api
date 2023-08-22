package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Controller
public class UserController
{
    @Autowired
    private UserRepo userRepo;

    @QueryMapping
    public List<User> getAllUsers() { return (List<User>)userRepo.findAll(); }

    @MutationMapping
    public User changeUsername(@Argument UUID id, @Argument String name)
    {
        System.out.println(id);
        if (userRepo.findById(id).isEmpty())
            return null;
        User user = userRepo.findById(id).get();
        user.setUsername(name);
        userRepo.save(user);
        return user;
    }
}
