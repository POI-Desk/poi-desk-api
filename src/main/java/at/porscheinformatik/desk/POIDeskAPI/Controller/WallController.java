package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateWallInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Models.Wall;
import at.porscheinformatik.desk.POIDeskAPI.Services.WallService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

@Controller
public class WallController {

    @Autowired
    private WallService wallService;

    @MutationMapping
    public List<Wall> updateWallsOnMap(@Argument UUID mapId, @Argument List<UpdateWallInput> wallInputs) throws Exception {
        return wallService.updateWalls(mapId, wallInputs).get();
    }

    @MutationMapping
    public List<Wall> deleteWalls(@Argument List<UUID> wallIds) throws ExecutionException, InterruptedException {
        return wallService.deleteWalls(wallIds).get();
    }

    @SchemaMapping
    public Map map(Wall wall) { return wall.getMap(); }

}
