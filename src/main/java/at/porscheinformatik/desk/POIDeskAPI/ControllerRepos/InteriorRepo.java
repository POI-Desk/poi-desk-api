package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Interior;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface InteriorRepo extends CrudRepository<Interior, UUID> {
}
