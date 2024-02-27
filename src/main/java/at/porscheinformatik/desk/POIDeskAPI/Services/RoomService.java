package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MapRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.RoomRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateRoomInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Models.Room;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CompletableFuture;

@Service
public class RoomService {
    @Autowired
    RoomRepo roomRepo;
    @Autowired
    MapRepo mapRepo;

    /**
     * Updates given rooms on map.
     *
     * @param mapId The mapId the rooms belong to.
     * @param roomInputs The new/updated room inputs.
     * @return The new/updated rooms.
     *
     * @throws IllegalArgumentException if map with given map ID does not exist
     * @throws Exception if any given room ID does not exist
     */
    @Async
    public CompletableFuture<List<Room>> updateRooms(UUID mapId, List<UpdateRoomInput> roomInputs) throws Exception {

        Optional<Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            throw new Exception("No map found with given ID");
        Map map = o_map.get();
        return updateRooms(map, roomInputs);
    }

    /**
     * Deletes the rooms with given IDs.
     *
     * @return List of deleted rooms.
     */
    @Async
    public CompletableFuture<List<Room>> deleteRooms(List<UUID> roomIds){
        Iterable<Room> i_rooms = roomRepo.findAllById(roomIds);
        List<Room> delRooms = new ArrayList<>();
        for (Room room:
             i_rooms) {
            delRooms.add(room);
        }

        roomRepo.deleteAll(delRooms);
        return CompletableFuture.completedFuture(delRooms);
    }

    /**
     * <b>No side effects</b>
     * <br />
     * Calculates List of Rooms with given input
     *
     * @param map The map the rooms belong to.
     * @param roomInputs The new/updated room inputs.
     * @return The new/updated rooms.
     *
     * @throws Exception if any given room ID does not exist
     */
    @Async
    public CompletableFuture<List<Room>> updateRooms(Map map, List<UpdateRoomInput> roomInputs) throws Exception {
        if (map.isPublished()) return null;

        List<Room> rooms = roomRepo.findAllByMap(map);
        List<Room> finalRooms = new ArrayList<>();
        for (UpdateRoomInput roomInput : roomInputs) {
            if (roomInput.pk_roomId() == null) {
                finalRooms.add(new Room(roomInput.x(), roomInput.y(), roomInput.width(), roomInput.height(), map));
                continue;
            }
            Optional<Room> o_room = rooms.stream().filter(room -> Objects.equals(room.getPk_roomId().toString(), roomInput.pk_roomId().toString())).findFirst();
            if (o_room.isEmpty()) {
                throw new Exception("Any given room ID does not exist");
            }
            Room c_room = o_room.get();
            c_room.updateProps(roomInput.x(), roomInput.y(), roomInput.width(), roomInput.height());
            finalRooms.add(c_room);
        }

        roomRepo.saveAll(finalRooms);
        return CompletableFuture.completedFuture(finalRooms);
    }

    @Async
    public CompletableFuture<List<Room>> deleteRooms(Map map) {
        List<UUID> roomIds = roomRepo.findAllByMap(map).stream().map(Room::getPk_roomId).toList();
        return  deleteRooms(roomIds);
    }

    @Async
    public CompletableFuture<List<Room>> copyRoomsToMap(List<Room> rooms, Map map) {
        List<Room> newRooms = rooms.stream().map(r -> new Room(r.getX(), r.getY(), r.getWidth(), r.getHeight(), map)).toList();
        roomRepo.saveAll(newRooms);
        return CompletableFuture.completedFuture(newRooms);
    }
}
