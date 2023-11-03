package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MapRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.MapInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.stereotype.Service;

import javax.management.relation.InvalidRelationIdException;
import java.lang.reflect.Array;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.StreamSupport;

@Service
public class MapService {
    @Autowired
    private MapRepo mapRepo;
    @Autowired
    private FloorRepo floorRepo;


    public Map createMap (UUID floorId, MapInput mapInput) throws IllegalArgumentException {
        Optional<Floor> o_floor = floorRepo.findById(floorId);
        if (o_floor.isEmpty())
            throw new IllegalArgumentException("floor id does not exist");

        Map map = new Map(mapInput.width(), mapInput.height(), o_floor.get());
        mapRepo.save(map);
        return map;
    }
}