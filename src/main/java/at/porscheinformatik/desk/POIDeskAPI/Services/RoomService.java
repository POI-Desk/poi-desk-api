package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MapRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.RoomRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Desk;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateDeskInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateRoomInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Models.Room;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.jpa.repository.support.SimpleJpaRepository;
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

    @Async
    public CompletableFuture<List<Room>> updateRooms(UUID mapId, List<UpdateRoomInput> roomInputs) throws Exception {

        Optional<Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            throw new Exception("No map found with given id");
        Map map = o_map.get();
        return updateRooms(map, roomInputs);
    }

    @Async
    public CompletableFuture<List<Room>> updateRooms(Map map, List<UpdateRoomInput> roomInputs){
        List<Room> rooms = roomRepo.findAllByMap(map);
        List<Room> finalRooms = new ArrayList<>();
        for (UpdateRoomInput roomInput : roomInputs) {
            if (roomInput.pk_roomId() == null) {
                finalRooms.add(new Room(roomInput.x(), roomInput.y(), roomInput.width(), roomInput.height(), map));
                continue;
            }
            Optional<Room> o_room = rooms.stream().filter(room -> Objects.equals(room.getPk_roomId().toString(), roomInput.pk_roomId().toString())).findFirst();
            if (o_room.isEmpty()) {
                continue;
            }
            Room c_room = o_room.get();
            c_room.updateProps(roomInput.x(), roomInput.y(), roomInput.width(), roomInput.height());
            finalRooms.add(c_room);
        }

        roomRepo.saveAll(finalRooms);
        return CompletableFuture.completedFuture(finalRooms);
    }
}
