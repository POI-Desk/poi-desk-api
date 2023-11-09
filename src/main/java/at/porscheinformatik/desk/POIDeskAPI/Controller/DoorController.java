package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.Models.Door;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateDoorInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Services.DoorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

@Controller
public class DoorController {

    @Autowired
    private DoorService doorService;

    @MutationMapping
    public List<Door> updateDoorsOnMap(@Argument UUID mapId, @Argument List<UpdateDoorInput> doorInputs) throws Exception {
        return doorService.updateDoors(mapId, doorInputs).get();
    }

    @MutationMapping
    public List<Door> deleteDoors(@Argument List<UUID> doorIds) throws ExecutionException, InterruptedException {
        return doorService.deleteDoors(doorIds).get();
    }

    @SchemaMapping
    public Map map(Door door) { return door.getMap(); }

}
