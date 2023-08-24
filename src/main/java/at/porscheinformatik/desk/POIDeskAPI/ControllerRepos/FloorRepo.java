package at.porscheinformatik.desk.POIDeskAPI.ModelRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface FloorRepo extends CrudRepository<Floor, UUID> {
}
