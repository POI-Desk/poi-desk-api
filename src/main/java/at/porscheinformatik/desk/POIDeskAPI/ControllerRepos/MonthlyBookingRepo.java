package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;
import at.porscheinformatik.desk.POIDeskAPI.Models.MonthlyBooking;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface MonthlyBookingRepo extends CrudRepository<MonthlyBooking, UUID>{
}
