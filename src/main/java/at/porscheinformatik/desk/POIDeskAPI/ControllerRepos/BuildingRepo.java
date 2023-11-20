package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Building;
import at.porscheinformatik.desk.POIDeskAPI.Models.Location;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.UUID;

public interface BuildingRepo extends CrudRepository<Building, UUID> {
    /**
     * Finds all buildings in a Location
     * @param location Location, search for buildings here
     * @return List of Buildings in location
     */
    List<Building> findByLocation(Location location);
}
