package at.porscheinformatik.desk.POIDeskAPI.ModelRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface BookingRepo extends CrudRepository<Booking, UUID> {
}
