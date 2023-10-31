package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;

@Service
public class BookingService {

    @Autowired
    private BookingRepo bookingRepo;

    public UUID deleteBooking(UUID bookingId){
        Optional<Booking> booking = bookingRepo.findById(bookingId);
        if (booking.isEmpty())
            return null;

        bookingRepo.delete(booking.get());
        return bookingId;
    }

}