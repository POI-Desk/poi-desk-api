package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateRoomInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Models.Room;
import at.porscheinformatik.desk.POIDeskAPI.Services.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

@Controller
public class RoomController {

    @Autowired
    private RoomService roomService;

    @MutationMapping
    public List<Room> updateRoomsOnMap(@Argument UUID mapId, @Argument List<UpdateRoomInput> roomInputs) throws Exception {
        return roomService.updateRooms(mapId, roomInputs).get();
    }

    @MutationMapping
    public List<Room> deleteRooms(@Argument List<UUID> roomIds) throws ExecutionException, InterruptedException {
        return roomService.deleteRooms(roomIds).get();
    }

    @SchemaMapping
    public Map map(Room room) { return room.getMap(); }
}
