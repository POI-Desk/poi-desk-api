package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.DailyBooking;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface DailyBookingRepo extends CrudRepository<DailyBooking, UUID> {


}
