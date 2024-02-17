package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.*;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.*;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class MapService {
    @Autowired
    private MapRepo mapRepo;
    @Autowired
    private FloorService floorService;
    @Autowired
    private DoorService doorService;
    @Autowired
    private RoomService roomService;
    @Autowired
    private InteriorService interiorService;
    @Autowired
    private WallService wallService;
    @Autowired
    private LabelService labelService;
    @Autowired
    private DeskService deskService;

    public Map createMap (UUID floorId, MapInput mapInput) throws Exception {
        Floor floor = floorService.getFloorById(floorId).get();
        if (floor == null)
            throw new IllegalArgumentException("floor id does not exist");

        if (mapInput.published() && mapRepo.existsByFloorAndPublishedTrue(floor)){
            throw new Exception("Floor already has a main map");
        }

        Map map = new Map(mapInput.width(), mapInput.height(), mapInput.published(), floor);
        mapRepo.save(map);
        return map;
    }

    /**
     * the map with the give od
     * @param mapId id of the map
     * @return the map or null if it does not exist
     */
    @Async
    public CompletableFuture<Map> getMapById(UUID mapId){
        Optional<Map> o_map = mapRepo.findById(mapId);
        return CompletableFuture.completedFuture(o_map.orElse(null));
    }

    @Async
    public CompletableFuture<Map> getPublishedMapOnFloor(UUID floorId) throws ExecutionException, InterruptedException {
        Floor floor = floorService.getFloorById(floorId).get();
        if (floor == null) {
            return null;
        }
        return CompletableFuture.completedFuture(mapRepo.findMapByFloorAndPublishedTrue(floor));

    }

    @Async
    public CompletableFuture<Map> updateMap(UUID mapId, MapInput mapInput) throws ExecutionException, InterruptedException {
        Map map = getMapById(mapId).get();
        if (map == null)
            return null;

        if (mapRepo.existsByFloorAndPublishedTrue(map.getFloor()) && mapInput.published())
            return null;

        map.updateProps(mapInput.width(), mapInput.height(), mapInput.published(), map.getFloor());
        mapRepo.save(map);
        return CompletableFuture.completedFuture(map);
    }

    @Async
    public CompletableFuture<Boolean> deleteMap(UUID mapId) throws ExecutionException, InterruptedException {

        Optional<Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            return CompletableFuture.completedFuture(false);

        Map map = o_map.get();

        if (map.isPublished())
            return CompletableFuture.completedFuture(false);

        CompletableFuture<List<Door>> doorFuture = doorService.deleteDoors(map);
        CompletableFuture<List<Room>> roomFuture = roomService.deleteRooms(map);
        CompletableFuture<List<Interior>> interiorFuture = interiorService.deleteInteriors(map);
        CompletableFuture<List<Wall>> wallFuture = wallService.deleteWalls(map);
        CompletableFuture<List<Label>> labelFuture = labelService.deleteLabels(map);
        CompletableFuture<List<Desk>> deskFuture = deskService.deleteDesks(map);

        CompletableFuture.allOf(doorFuture, roomFuture, interiorFuture, wallFuture, labelFuture, deskFuture).get();

        mapRepo.delete(map);

        return CompletableFuture.completedFuture(true);
    }
}