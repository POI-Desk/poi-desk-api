package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import org.springframework.cglib.core.Local;
import org.springframework.data.repository.CrudRepository;

import java.awt.print.Book;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

public interface BookingRepo extends CrudRepository<Booking, UUID> {
    List<Booking> findBookingsByUser(User user);

    List<Booking> findByDateAndDesk(LocalDate date, Desk desk);

    List<Booking> findBookingsByDate(LocalDate date);

    List<Booking> findBookingsByDateAndDeskMapFloor(LocalDate date, Floor floor);
}
