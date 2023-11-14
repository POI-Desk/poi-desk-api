package at.porscheinformatik.desk.POIDeskAPI.Controller;


import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DeskRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.UserRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.BookingInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.EditBookingInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import at.porscheinformatik.desk.POIDeskAPI.Services.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

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
    public List<Booking> getBookingsByDate(@Argument LocalDate date) throws ExecutionException, InterruptedException {
        return bookingService.getBookingsOnDate(date).get();
    }


    @QueryMapping
    public Booking getBookingById(@Argument UUID id){
        return bookingRepo.findById(id).get();
    }

    @QueryMapping
        public List<Booking> getBookingsByUserid(@Argument UUID userid) { return bookingRepo.findBookingsByUser(userRepo.findById(userid).get()); }

    @MutationMapping
    public Booking bookDesk(@Argument BookingInput booking) {
        Booking newBooking = new Booking(booking);

        newBooking.setBookingnumber("12345"); // TODO change
        newBooking.setUser(userRepo.findById(booking.userid()).get());
        newBooking.setDesk(deskRepo.findById(booking.deskid()).get());
        bookingRepo.save(newBooking);

        return newBooking;
    }

    @MutationMapping
    public UUID deleteBooking(@Argument UUID bookingId) { return bookingService.deleteBooking(bookingId); }

    @MutationMapping
    public Booking editBooking(@Argument EditBookingInput bookingInput){
        boolean morningTaken = false;
        boolean afternoonTaken = false;
        Booking currentBooking = getBookingById(bookingInput.pk_bookingid());
        List<Booking> bookingsWithDateAndSeat = bookingRepo.findByDateAndDesk(bookingInput.date(), deskRepo.findById(bookingInput.deskid()).get());
        // set trivial properties
        currentBooking.setDate(bookingInput.date());
        currentBooking.setDesk(deskRepo.findById(bookingInput.deskid()).get());

        //check for morning/afternoon
        for (Booking book : bookingsWithDateAndSeat){
            if (!morningTaken && book.isIsmorning()){
                morningTaken = true;
            }
            if(!afternoonTaken && book.isIsafternoon()){
                afternoonTaken = true;
            }
        }
        // checks if both isMorning/isAfternoon is null. Should technically not be possible in the frontend
        if (!bookingInput.ismorning() && !bookingInput.isafternoon())
            return null;
        // return null and cancels the booking when either morning or afternoon is not available
        if (morningTaken && bookingInput.ismorning())
            return null;
        if (afternoonTaken && bookingInput.isafternoon())
            return null;

        //set morning/afternoon properties
        currentBooking.setIsmorning(bookingInput.ismorning());
        currentBooking.setIsafternoon(bookingInput.isafternoon());
        bookingRepo.save(currentBooking);
        return currentBooking;
    }

    @SchemaMapping
    public User user(Booking booking) {
        return booking.getUser();
    }

}
