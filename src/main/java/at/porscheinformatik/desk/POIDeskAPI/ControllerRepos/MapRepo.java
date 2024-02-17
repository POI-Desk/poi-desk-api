package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface MapRepo extends CrudRepository<Map, UUID> {
    Map findMapByFloor(Floor floor);

    Map findMapByFloorAndPublishedTrue(Floor floor);

    boolean existsByFloorAndPublishedTrue(Floor floor);
}
