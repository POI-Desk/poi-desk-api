package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.QuarterlyBooking;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface QuarterlyBookingRepo extends CrudRepository<QuarterlyBooking, UUID> {
}
