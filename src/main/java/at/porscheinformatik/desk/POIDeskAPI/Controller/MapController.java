package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.*;
import at.porscheinformatik.desk.POIDeskAPI.Services.MapService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Controller;

import javax.management.relation.InvalidRelationIdException;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Controller
public class MapController {
    @Autowired
    private MapService mapService;

    @QueryMapping
    public Map getMapById(@Argument UUID mapId){
        return mapService.getMapById(mapId);
    }

    @MutationMapping
    public Map createMap(@Argument UUID floorId, @Argument MapInput mapInput) throws Exception {
        return mapService.createMap(floorId, mapInput);
    }

    @SchemaMapping
    public List<Desk> desks(Map map) { return map.getDesks(); }

    @SchemaMapping
    public List<Label> labels(Map map) { return map.getLabels(); }

    @SchemaMapping
    public List<Room> rooms(Map map) { return map.getRooms(); }

    @SchemaMapping
    public List<Interior> interiors(Map map) { return map.getInteriors(); }

    @SchemaMapping
    public List<Door> doors(Map map) { return map.getDoors(); }

    @SchemaMapping
    public List<Wall> walls(Map map) { return map.getWalls(); }

    @SchemaMapping
    public Floor floor(Map map) { return map.getFloor(); }

}
