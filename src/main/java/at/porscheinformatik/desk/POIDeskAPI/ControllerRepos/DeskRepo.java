package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Desk;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.UUID;

public interface DeskRepo extends CrudRepository<Desk, UUID> {
    List<Seat> findByBookings(Booking booking);
}
