package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.Seat;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.UUID;

public interface SeatRepo extends CrudRepository<Seat, UUID> {
    List<Seat> findByBookings(Booking booking);
}
