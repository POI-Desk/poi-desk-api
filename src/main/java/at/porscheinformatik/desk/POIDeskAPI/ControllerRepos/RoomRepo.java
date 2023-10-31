package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Room;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface RoomRepo extends CrudRepository<Room, UUID> {
}
