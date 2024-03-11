package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Desk;
import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import at.porscheinformatik.desk.POIDeskAPI.Models.Location;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface MapRepo extends CrudRepository<Map, UUID> {
    Map findMapByFloor(Floor floor);

    Map findMapByFloorAndPublishedTrue(Floor floor);

    List<Map> findMapsByFloorAndPublishedFalse(Floor floor);

    Optional<List<Map>> findMapsByFloorFloornameAndFloorBuildingBuildingnameAndFloorBuildingLocationAndPublishedFalse(String floorName, String BuildingName, Location location);

    boolean existsByFloorAndPublishedTrue(Floor floor);

}
