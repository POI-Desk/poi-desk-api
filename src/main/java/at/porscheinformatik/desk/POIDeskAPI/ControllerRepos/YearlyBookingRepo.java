package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;
import at.porscheinformatik.desk.POIDeskAPI.Models.YearlyBooking;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface YearlyBookingRepo extends CrudRepository<YearlyBooking, UUID>{
}
