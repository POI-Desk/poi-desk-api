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

    List<Booking> findBookingsByUserAndDateBefore(User user, LocalDate date)
            ;
    List<Booking> findBookingsByUserAndDateAfter(User user, LocalDate date);

    List<Booking> findByDateAndDesk(LocalDate date, Desk desk);

    List<Booking> findByBookingnumberContains(String string);

    List<Booking> findBookingsByDate(LocalDate date);

    List<Booking> findBookingsByDateBetween(LocalDate startDate, LocalDate endDate);

    List<Booking> findBookingsByDateAndDeskMapFloor(LocalDate date, Floor floor);

    List<Booking> findAllByDeskMap(Map map);

    List<Booking> findBookingByDeskMap(Map map);
}
