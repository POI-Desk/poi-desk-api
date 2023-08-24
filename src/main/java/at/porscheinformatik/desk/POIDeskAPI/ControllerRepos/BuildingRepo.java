package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Building;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface BuildingRepo extends CrudRepository<Building, UUID> {
}
