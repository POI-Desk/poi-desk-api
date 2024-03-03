package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Room;
import at.porscheinformatik.desk.POIDeskAPI.Models.Team;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface TeamRepo extends CrudRepository<Team, UUID> {
}
