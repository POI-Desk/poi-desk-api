package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Desk;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface DeskRepo extends CrudRepository<Desk, UUID> {
}
