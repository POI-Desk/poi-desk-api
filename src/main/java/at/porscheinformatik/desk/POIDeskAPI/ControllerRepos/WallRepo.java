package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Models.Wall;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.UUID;

public interface WallRepo extends CrudRepository<Wall, UUID> {
    List<Wall> findAllByMap(Map map);
}
