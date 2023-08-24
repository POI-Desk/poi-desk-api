package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BookingLogRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.BookingLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

@Service
public class BookingService {

    @Autowired
    private BookingRepo bookingRepo;

    @Autowired
    private BookingLogRepo bookingLogRepo;

    public boolean deleteBooking(UUID bookingId){
        Optional<Booking> booking = bookingRepo.findById(bookingId);
        if (booking.isEmpty())
            return false;

        bookingLogRepo.save(BookingLog.toBookingLog(booking.get(), true));
        bookingRepo.delete(booking.get());
        return true;
    }

}
