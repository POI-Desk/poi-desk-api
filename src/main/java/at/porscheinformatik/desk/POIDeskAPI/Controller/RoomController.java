package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.RoomRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.RoomInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Interior;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Models.Room;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

@Controller
public class RoomController {

    @Autowired
    private RoomRepo roomRepo;

    @MutationMapping
    public Room addRoom(@Argument RoomInput roomInput) { return new Room(); }

    @SchemaMapping
    public Map map(Room room) { return room.getMap(); }
}
