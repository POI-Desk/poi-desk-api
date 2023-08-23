package at.porscheinformatik.desk.POIDeskAPI.ModelRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Location;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface LocationRepo extends CrudRepository<Location, UUID> {
}
