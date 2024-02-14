package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.UserRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
public class UserService {
    @Autowired
    UserRepo userRepo;

    @Async
    public CompletableFuture<User> getUserById(UUID userId){
        return CompletableFuture.completedFuture(userRepo.findById(userId).orElse(null));
    }

    /**
     * <b>No side effects</b>
     * <br />
     * gets every user that has a desk assigned to it
     */
    @Async
    public CompletableFuture<List<User>> getUsersWithADesk(){
        return CompletableFuture.completedFuture(userRepo.getUsersByDeskNotNull());
    }

    @Async
    public CompletableFuture<List<User>> getUsersWithNoDesk(){
        return CompletableFuture.completedFuture(userRepo.getUsersByDeskNull());
    }
}
