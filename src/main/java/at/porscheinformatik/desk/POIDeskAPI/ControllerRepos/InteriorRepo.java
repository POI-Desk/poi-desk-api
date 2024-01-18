package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Interior;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.UUID;

public interface InteriorRepo extends CrudRepository<Interior, UUID> {
    List<Interior> findAllByMap(Map map);
}
