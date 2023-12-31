package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Label;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.UUID;

public interface LabelRepo extends CrudRepository<Label, UUID> {
    List<Label> findAllByMap(Map map);
}
