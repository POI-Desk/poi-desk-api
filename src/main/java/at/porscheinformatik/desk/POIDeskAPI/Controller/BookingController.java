package at.porscheinformatik.desk.POIDeskAPI.Controller;


import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class BookingController {

    @Autowired
    private BookingRepo bookingRepo;

    @QueryMapping
    public List<Booking> allBookings() { return (List<Booking>)bookingRepo.findAll(); }

    @SchemaMapping
    public User user(Booking booking) { return bookingRepo.findById(booking.getPk_bookingid()).get().getUser(); }
}
