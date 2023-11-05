package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Models.Room;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.UUID;

public interface RoomRepo extends CrudRepository<Room, UUID> {
    List<Room> findAllByMap(Map map);
}
