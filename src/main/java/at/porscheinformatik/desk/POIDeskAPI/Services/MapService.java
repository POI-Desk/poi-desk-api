package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.*;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.*;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class MapService {
    @Autowired
    private MapRepo mapRepo;
    @Lazy
    @Autowired
    private FloorService floorService;
    @Lazy
    @Autowired
    private DeskService deskService;
    @Lazy
    @Autowired
    private WallService wallService;
    @Lazy
    @Autowired
    private RoomService roomService;
    @Lazy
    @Autowired
    private DoorService doorService;
    @Lazy
    @Autowired
    private LabelService labelService;
    @Lazy
    @Autowired
    private InteriorService interiorService;

    public Map createMap (UUID floorId, MapInput mapInput) throws Exception {
        Floor floor = floorService.getFloorById(floorId).get();
        if (floor == null)
            throw new IllegalArgumentException("floor id does not exist");

        Map map = new Map(mapInput.width(), mapInput.height(), mapInput.name(), floor);
        mapRepo.save(map);
        return map;
    }

    @Async
    public CompletableFuture<Map> createMapSnapshotOfFloor(Optional<UUID> floorId, String name, MapInput fallback) throws Exception {
        if (floorId.isEmpty()) return null;
        UUID fid = floorId.get();

        Floor floor = floorService.getFloorById(fid).get();
        if (floor == null){
            return null;
        }

        Map publishedMap = mapRepo.findMapByFloorAndPublishedTrue(floor);
        if (publishedMap == null && fallback == null){
            return null;
        }
        else if (publishedMap == null){
            return CompletableFuture.completedFuture(createMap(fid, fallback));
        }

        Map newMap = new Map(publishedMap.getWidth(), publishedMap.getHeight(), name, floor);

        mapRepo.save(newMap);

        CompletableFuture<List<Desk>> desksFuture = deskService.copyDesksToMap(publishedMap.getDesks(), newMap);
        CompletableFuture<List<Room>> roomsFuture = roomService.copyRoomsToMap(publishedMap.getRooms(), newMap);
        CompletableFuture<List<Wall>> wallsFuture = wallService.copyWallsToMap(publishedMap.getWalls(), newMap);
        CompletableFuture<List<Door>> doorsFuture = doorService.copyDoorsToMap(publishedMap.getDoors(), newMap);
        CompletableFuture<List<Label>> labelsFuture = labelService.copyLabelsToMap(publishedMap.getLabels(), newMap);
        CompletableFuture<List<Interior>> interiorsFuture = interiorService.copyInteriorsToMap(publishedMap.getInteriors(), newMap);

        CompletableFuture.allOf(desksFuture, roomsFuture, wallsFuture, doorsFuture, labelsFuture, interiorsFuture).get();

        return CompletableFuture.completedFuture(newMap);
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
    public CompletableFuture<List<Map>> getMapSnapshotsOfFloor(UUID floorId) throws ExecutionException, InterruptedException {
        Floor floor = floorService.getFloorById(floorId).get();
        if (floor == null)
            return null;

        return CompletableFuture.completedFuture(mapRepo.findMapsByFloorAndPublishedFalse(floor));
    }

    /**
     * gets the map by id only if it is not published
     * @param mapId id of the map
     * @return the map or null if its does not exist / is published
     */
    @Async
    public CompletableFuture<Map> getMapSnapshotById(UUID mapId){
        Optional<Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            return null;

        Map map = o_map.get();

        if (map.isPublished())
            return null;

        return CompletableFuture.completedFuture(map);
    }

    @Async
    public CompletableFuture<Map> updateMap(UUID mapId, MapInput mapInput) throws ExecutionException, InterruptedException {
        Map map = getMapById(mapId).get();
        if (map == null)
            return null;

        map.updateProps(mapInput.width(), mapInput.height(), false, mapInput.name(), map.getFloor());
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



        mapRepo.delete(map);

        return CompletableFuture.completedFuture(true);
    }

    @Async
    public CompletableFuture<Boolean> publishMap(Optional<UUID> mapId, boolean force) throws ExecutionException, InterruptedException {
        if (mapId.isEmpty()) return CompletableFuture.completedFuture(false);

        Map map = getMapById(mapId.get()).get();
        if (map == null)
            return CompletableFuture.completedFuture(false);

        Map publishedMap = mapRepo.findMapByFloorAndPublishedTrue(map.getFloor());
        if (publishedMap == null){
            map.setPublished(true);
            mapRepo.save(map);
            return CompletableFuture.completedFuture(true);
        }

        if (!force){
            return CompletableFuture.completedFuture(false);
        }

        publishedMap.setPublished(false);
        map.setPublished(true);

        List<Map> maps = new ArrayList<>();
        maps.add(map);
        maps.add(publishedMap);

        mapRepo.saveAll(maps);

        return CompletableFuture.completedFuture(true);
    }
}