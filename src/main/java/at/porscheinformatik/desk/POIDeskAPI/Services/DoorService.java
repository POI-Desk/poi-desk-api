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
     * Updates give doors on map.
     *
     * @param mapId The mapId the doors belong to.
     * @param doorInputs The new/updated door inputs.
     * @return The new/updated doors.
     *
     * @throws IllegalArgumentException if map with given map ID does not exist
     * @throws Exception if any given door number is already in use
     */
    @Async
    public CompletableFuture<List<Door>> updateDoors(UUID mapId, List<UpdateDoorInput> doorInputs) throws Exception {

        Optional<Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            throw new IllegalArgumentException("No map found with given id");
        Map map = o_map.get();
        return updateDoors(map, doorInputs);
    }

    /**
     * Updates give doors on map.
     *
     * @param map The map the doors belong to.
     * @param doorInputs The new/updated door inputs.
     * @return The new/updated doors.
     */
    @Async
    public CompletableFuture<List<Door>> updateDoors(Map map, List<UpdateDoorInput> doorInputs){
        List<Door> doors = doorRepo.findAllByMap(map);
        List<Door> finalDoors = new ArrayList<>();
        for (UpdateDoorInput doorInput : doorInputs) {
            if (doorInput.pk_doorId() == null) {
                finalDoors.add(new Door(doorInput.x(), doorInput.y(), doorInput.rotation(), doorInput.width(), map));
                continue;
            }
            Optional<Door> o_door = doors.stream().filter(door -> Objects.equals(door.getPk_doorId().toString(), doorInput.pk_doorId().toString())).findFirst();
            if (o_door.isEmpty()) {
                continue;
            }
            Door c_door = o_door.get();
            c_door.updateProps(doorInput.x(), doorInput.y(), doorInput.rotation(), doorInput.width());
            finalDoors.add(c_door);
        }

        doorRepo.saveAll(finalDoors);
        return CompletableFuture.completedFuture(finalDoors);
    }
}
