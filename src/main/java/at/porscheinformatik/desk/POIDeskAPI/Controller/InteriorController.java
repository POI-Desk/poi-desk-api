package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.InteriorInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Interior;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Services.InteriorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

@Controller
public class InteriorController {
    @Autowired
    InteriorService interiorService;

    @MutationMapping
    public Interior addInterior(@Argument Optional<UUID> mapId, @Argument InteriorInput input) throws ExecutionException, InterruptedException {
        return interiorService.addInterior(mapId, input);
    }

    @SchemaMapping
    public Map map(Interior interior) { return interior.getMap(); }
}
