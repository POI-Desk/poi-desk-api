package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
public class FloorService {
    @Autowired
    private FloorRepo floorRepo;

    /**
     * gets the map on the given floor by id
     * @param floorId id of the floor the map is on
     * @return the map or null if the floor/map does not exist
     */
    public Map getMapByFloor(UUID floorId){
        var o_floor = floorRepo.findById(floorId);
        return o_floor.map(Floor::getMap).orElse(null);

    }

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
