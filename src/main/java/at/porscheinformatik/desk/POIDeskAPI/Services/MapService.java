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
    private FloorRepo floorRepo;
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
    @Autowired
    private BookingService bookingService;

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
     * the map with the give od
     * @param mapId id of the map
     * @return the map or null if it does not exist
     */
    @Async
    public CompletableFuture<Map> getMapById(UUID mapId){
        Optional<Map> o_map = mapRepo.findById(mapId);
        return o_map.map(CompletableFuture::completedFuture).orElse(null);
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

    @Async
    public CompletableFuture<Boolean> deleteMap(UUID mapId) throws ExecutionException, InterruptedException {

        Optional<Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            return CompletableFuture.completedFuture(false);

        Map map = o_map.get();

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