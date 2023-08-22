package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class UserController
{
    @Autowired
    private UserRepo userRepo;

    @QueryMapping
    public List<User> getAllUsers() { return (List<User>)userRepo.findAll(); }
}
