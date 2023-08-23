package at.porscheinformatik.desk.POIDeskAPI.Controller;


import at.porscheinformatik.desk.POIDeskAPI.ModelRepos.BookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.ModelRepos.SeatRepo;
import at.porscheinformatik.desk.POIDeskAPI.ModelRepos.UserRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Controller
public class BookingController {
    @Autowired
    private BookingRepo bookingRepo;
    @Autowired
    private SeatRepo seatRepo;
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
                System.out.println(booking.getDate().toString().split(" ")[0]);
                if (booking.getDate().toString().split(" ")[0].equals(date.toString())) bookings.add(booking);

            }
        });
        return bookings;
    }

    /**
     * Creates a new booking for a seat on a specified time for a user
     * @param date
     * @param isMorning
     * @param isAfternoon
     * @param userId
     * @param seatId
     * @return new booking
     */
    @MutationMapping
    public Booking bookSeat(@Argument Date date, @Argument boolean isMorning, @Argument boolean isAfternoon,
                            @Argument UUID userId, @Argument UUID seatId) {
        Booking booking = new Booking();

        if (seatRepo.findById(seatId).isEmpty() || userRepo.findById(userId).isEmpty()) {
            return null;
        }
        Timestamp curTime = new Timestamp(System.currentTimeMillis());

        booking.setPk_bookingid(UUID.randomUUID());
        booking.setBookingnumber(12345); // TODO change
        booking.setDate(date);
        booking.setIsmorning(isMorning);
        booking.setIsafternoon(isAfternoon);
        booking.setUser(userRepo.findById(userId).get());
        booking.setSeat(seatRepo.findById(seatId).get());
        booking.setCreatedon(curTime);
        booking.setUpdatedon(curTime);

        bookingRepo.save(booking);

        return booking;
    }


    @SchemaMapping
    public User user(Booking booking) {
        return bookingRepo.findById(booking.getPk_bookingid()).get().getUser();
    }

}
