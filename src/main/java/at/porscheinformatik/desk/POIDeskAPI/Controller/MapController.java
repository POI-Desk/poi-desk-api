package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import at.porscheinformatik.desk.POIDeskAPI.Services.MapService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;

@Controller
public class MapController {
    @Autowired
    private MapService mapService;

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

}
