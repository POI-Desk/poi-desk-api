package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.UUID;

public interface DeskRepo extends CrudRepository<Desk, UUID> {
    /**
     * Find all desks on floor
     * @param floor Floor, search for desks here
     * @return List of Desks on floor
     */
    List<Desk> findByFloor(Floor floor);
}
