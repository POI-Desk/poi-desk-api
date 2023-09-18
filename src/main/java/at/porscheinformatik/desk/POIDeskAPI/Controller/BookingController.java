package at.porscheinformatik.desk.POIDeskAPI.Controller;


import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DeskRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.UserRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import at.porscheinformatik.desk.POIDeskAPI.Services.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.sql.Date;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Controller
public class BookingController {

    @Autowired
    private BookingService bookingService;

    @Autowired
    private BookingRepo bookingRepo;
    @Autowired
    private DeskRepo deskRepo;
    @Autowired
    private UserRepo userRepo;

    @QueryMapping
    public List<Booking> allBookings() {
        return (List<Booking>) bookingRepo.findAll();
    }

    @QueryMapping
    public List<Booking> getBookingsByDate(@Argument Date date) {
        List<Booking> bookings = new ArrayList<>();
        bookingRepo.findAll().forEach(booking -> {
            if (booking.getDate() != null) {
                // System.out.println(booking.getDate().toString().split(" ")[0]);
                if (booking.getDate().toString().split(" ")[0].equals(date.toString())) bookings.add(booking);
            }
        });
        return bookings;
    }


    @QueryMapping
    public Booking getBookingById(@Argument UUID id){
        return bookingRepo.findById(id).get();
    }

    @QueryMapping
    public List<Booking> getBookingsByUserId(@Argument UUID userid) { return bookingRepo.findBookingsByUser(userRepo.findById(userid).get()); }

    @MutationMapping
    public Booking bookDesk(@Argument LocalDate date, @Argument boolean isMorning, @Argument boolean isAfternoon,
                            @Argument UUID userId, @Argument UUID deskId) {

        if (deskRepo.findById(deskId).isEmpty() || userRepo.findById(userId).isEmpty()) {
            return null;
        }
        Booking booking = new Booking();

        booking.setBookingnumber("12345"); // TODO change
        booking.setDate(date);
        booking.setIsmorning(isMorning);
        booking.setIsafternoon(isAfternoon);
        booking.setUser(userRepo.findById(userId).get());
        booking.setDesk(deskRepo.findById(deskId).get());
        bookingRepo.save(booking);

        return booking;
    }

    @MutationMapping
    public UUID deleteBooking(@Argument UUID bookingId) { return bookingService.deleteBooking(bookingId); }

    @SchemaMapping
    public User user(Booking booking) {
        return booking.getUser();
    }

}
