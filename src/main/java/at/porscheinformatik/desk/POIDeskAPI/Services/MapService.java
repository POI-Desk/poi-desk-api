package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DeskRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MapRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.*;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.apache.qpid.proton.reactor.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.management.relation.InvalidRelationIdException;
import java.lang.reflect.Array;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.stream.StreamSupport;

@Service
public class MapService {
    @Autowired
    private MapRepo mapRepo;
    @Autowired
    private FloorRepo floorRepo;


    public Map createMap (UUID floorId, MapInput mapInput) throws Exception {
        Optional<Floor> o_floor = floorRepo.findById(floorId);
        if (o_floor.isEmpty())
            throw new IllegalArgumentException("floor id does not exist");
        if (mapRepo.existsByFloor(o_floor.get()))
            throw new Exception("Floor already has a map");

        Map map = new Map(mapInput.width(), mapInput.height(), o_floor.get());
        mapRepo.save(map);
        return map;
    }

    /**
     * @param mapId The mapId the map to find.
     * @return The map.
     *
     * @throws IllegalArgumentException if map with given map ID does not exist
     */
    @Async
    public CompletableFuture<Map> getMapById(UUID mapId){
        Optional<Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            throw new IllegalArgumentException("no map with given ID: " + mapId);
        return CompletableFuture.completedFuture(o_map.get());
    }

    @Async
    public CompletableFuture<Map> updateMap(UUID mapId, MapInput mapInput){
        Optional<Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            throw new IllegalArgumentException("No map with given ID: " + mapId);
        Map map = o_map.get();
        map.updateProps(mapInput.width(), mapInput.height(), map.getFloor());
        mapRepo.save(map);
        return CompletableFuture.completedFuture(map);
    }
}