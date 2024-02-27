package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.UserRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Desk;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class UserService {
    @Autowired
    UserRepo userRepo;
    @Lazy
    @Autowired
    MapService mapService;

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
    public CompletableFuture<List<User>> getUsersWithADeskOnMap(UUID mapId) throws ExecutionException, InterruptedException {
        Map map = mapService.getMapById(mapId).get();
        if (map == null)
            return CompletableFuture.completedFuture(new ArrayList<>());

        return CompletableFuture.completedFuture(userRepo.getUsersByDesksMap(map));
    }

    @Async
    public CompletableFuture<List<User>> getUsersWithNoDeskOnMap(UUID mapId) throws ExecutionException, InterruptedException {
        Map map = mapService.getMapById(mapId).get();
        if (map == null)
            return CompletableFuture.completedFuture(new ArrayList<>());

        return CompletableFuture.completedFuture(userRepo.getUsersWithoutDeskInDesks(map.getDesks()));
    }

    @Async
    public  CompletableFuture<List<User>> getUsersOnPublishedMapInUsersExcludeMap(List<User> users, Map map){
        return CompletableFuture.completedFuture(userRepo.getUsersOnPublishedMapInUsersExcludeMap(users, map));
    }
}
