package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DoorRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MapRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Door;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateDoorInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CompletableFuture;

@Service
public class DoorService {
    @Autowired
    private DoorRepo doorRepo;
    @Autowired
    private MapRepo mapRepo;


    /**
     * Updates given doors on map.
     *
     * @param mapId The mapId the doors belong to.
     * @param doorInputs The new/updated door inputs.
     * @return The new/updated doors.
     *
     * @throws IllegalArgumentException if map with given map ID does not exist
     * @throws Exception if any given door ID does not exist
     */
    @Async
    public CompletableFuture<List<Door>> updateDoors(UUID mapId, List<UpdateDoorInput> doorInputs) throws Exception {

        Optional<Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            throw new IllegalArgumentException("No map found with given id");
        Map map = o_map.get();
        List<Door> doors = updateDoors(map, doorInputs).get();
        doorRepo.saveAll(doors);
        return CompletableFuture.completedFuture(doors);
    }


    /**
     * Deletes the doors with given IDs.
     *
     * @return List of deleted doors.
     */
    @Async
    public CompletableFuture<List<Door>> deleteDoors(List<UUID> doorIds){
        Iterable<Door> i_doors = doorRepo.findAllById(doorIds);
        List<Door> delDoors = new ArrayList<>();
        for (Door room:
                i_doors) {
            delDoors.add(room);
        }

        doorRepo.deleteAll(delDoors);
        return CompletableFuture.completedFuture(delDoors);
    }

    /**
     * <b>No side effects</b>
     * <br />
     * Calculates List of Doors with given input
     *
     * @param map The map the doors belong to.
     * @param doorInputs The new/updated door inputs.
     * @return The new/updated doors.
     *
     * @throws Exception if any given door ID does not exist
     */
    @Async
    public CompletableFuture<List<Door>> updateDoors(Map map, List<UpdateDoorInput> doorInputs) throws Exception {
        if (map.isPublished()) return null;

        List<Door> doors = doorRepo.findAllByMap(map);
        List<Door> finalDoors = new ArrayList<>();
        for (UpdateDoorInput doorInput : doorInputs) {
            if (doorInput.pk_doorId() == null) {
                finalDoors.add(new Door(doorInput.x(), doorInput.y(), doorInput.rotation(), doorInput.width(), map, doorInput.localId()));
                continue;
            }
            Optional<Door> o_door = doors.stream().filter(door -> Objects.equals(door.getPk_doorId().toString(), doorInput.pk_doorId().toString())).findFirst();
            if (o_door.isEmpty()) {
                throw new Exception("any given door ID does not exist");
            }
            Door c_door = o_door.get();
            c_door.updateProps(doorInput.x(), doorInput.y(), doorInput.rotation(), doorInput.width(), doorInput.localId());
            finalDoors.add(c_door);
        }
        return CompletableFuture.completedFuture(finalDoors);
    }

    @Async
    public CompletableFuture<List<Door>> deleteDoors(Map map) {
        List<UUID> doorIds = doorRepo.findAllByMap(map).stream().map(Door::getPk_doorId).toList();
        return deleteDoors(doorIds);
    }

    @Async
    public CompletableFuture<List<Door>> copyDoorsToMap(List<Door> doors, Map map) {
        List<Door> newDoors = doors.stream().map(d -> new Door(d.getX(), d.getY(), d.getRotation(), d.getWidth(), map, d.getLocalId())).toList();
        doorRepo.saveAll(newDoors);
        return CompletableFuture.completedFuture(newDoors);
    }
}
