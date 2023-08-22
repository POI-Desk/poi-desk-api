package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

@Controller
public class BookingController {
    @Autowired
    private BookingRepo bookingRepo;

    @QueryMapping
    public List<Booking> getBookingsByDate(@Argument Date date) {
        List<Booking> bookings = new ArrayList<>();
        bookingRepo.findAll().forEach(booking -> {
            if (booking.getDate() != null) {
                System.out.println(booking.getDate().toString().split(" ")[0]);
                if (booking.getDate().toString().split(" ")[0].equals(date.toString())) bookings.add(booking);

            }
        });
        return bookings;
    }
}
