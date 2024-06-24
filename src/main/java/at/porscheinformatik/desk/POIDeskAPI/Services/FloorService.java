package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
public class FloorService {
    @Autowired
    private FloorRepo floorRepo;

    /**
     * gets the floor with the give id
     * @param floorId id of the floor
     * @return the floor or null if it does not exist
     */
    @Async
    public CompletableFuture<Floor> getFloorById(UUID floorId){
        var o_floor = floorRepo.findById(floorId);
        return CompletableFuture.completedFuture(o_floor.orElse(null));
    }
}
