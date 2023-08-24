package at.porscheinformatik.desk.POIDeskAPI.ModelRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Building;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface BuildingRepo extends CrudRepository<Building, UUID> {
}
