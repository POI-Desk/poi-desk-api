package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.BookingLog;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface BookingLogRepo extends CrudRepository<BookingLog, UUID> {
}