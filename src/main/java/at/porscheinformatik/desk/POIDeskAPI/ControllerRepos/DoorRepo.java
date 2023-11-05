package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Door;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.UUID;

public interface DoorRepo extends CrudRepository<Door, UUID> {

    List<Door> findAllByMap(Map map);
}
