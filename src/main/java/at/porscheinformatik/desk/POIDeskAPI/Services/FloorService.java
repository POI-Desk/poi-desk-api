package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MapRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class FloorService {
    @Autowired
    private FloorRepo floorRepo;
    @Autowired
    private MapRepo mapRepo;

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

    public Map getMapByFloor(UUID floorId) throws ExecutionException, InterruptedException {
        return mapRepo.findMapByFloor(getFloorById(floorId).get());
    }
}
