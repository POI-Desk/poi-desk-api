package at.porscheinformatik.desk.POIDeskAPI.Controller;


import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DeskRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.UserRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.Desk;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.BookingInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.EditBookingInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import at.porscheinformatik.desk.POIDeskAPI.Services.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cglib.core.Local;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.util.*;

@Controller
public class BookingController {

    /**
     * The bookingService class, needed for helper methods
     */
    @Autowired
    private BookingService bookingService;

    /**
     * The booking repository
     */
    @Autowired
    private BookingRepo bookingRepo;

    /**
     * The desk repository
     */
    @Autowired
    private DeskRepo deskRepo;

    /**
     * The user repository
     */
    @Autowired
    private UserRepo userRepo;

    /**
     * Return all bookings in the database
     * @return List of bookings
     */
    @QueryMapping
    public List<Booking> allBookings() {
        return (List<Booking>) bookingRepo.findAll();
    }

    @QueryMapping
    public List<Booking> getBookingsByDateOnFloor(@Argument LocalDate date, @Argument UUID floorId) throws ExecutionException, InterruptedException {
        return bookingService.getBookingsByDateOnFloor(date, floorId).get();
    }

    @QueryMapping
    public Booking getBookingById(@Argument UUID id){
        return bookingRepo.findById(id).get();
    }

    @QueryMapping
        public List<Booking> getBookingsByUserid(@Argument UUID userid) {
            List<Booking> bookings = bookingRepo.findBookingsByUser(userRepo.findById(userid).get());
            Collections.sort(bookings);
            return bookings;
        }

    /**
     * Creates a new booking and saves it in the database
     * <p>
     * Generates a booking number like this
     * <ul>
     *     <li>booking date: YYYYMMDD</li>
     *     <li>interval abbreviation: M(orning) or A(fternoon)</li>
     *     <li>desk number: number of the desk in database</li>
     * </ul>
     * @param booking BookingInput
     * @return Booking
     */
    @MutationMapping
    public Booking bookDesk(@Argument BookingInput booking) {
        Booking newBooking = new Booking(booking);

        Desk desk = deskRepo.findById(booking.deskid()).get();

        // Check if the desk is permanently used
        if (desk.getUser() != null)
            return null;

        User user = userRepo.findById(booking.userid()).get();

        if (booking.date().isBefore(LocalDate.now()) || booking.date().isAfter(LocalDate.now().plusWeeks(2))){
            return null;
        }

        String basicDate = booking.date().format(DateTimeFormatter.BASIC_ISO_DATE);
        String interval = (booking.ismorning() ? "M" : "") + (booking.isafternoon() ? "A" : "");
        String deskNum = deskRepo.findById(booking.deskid()).get().getDesknum();
        String bookingNumber = basicDate + interval + deskNum;

        newBooking.setBookingnumber(bookingNumber);
        newBooking.setUser(user);
        newBooking.setDesk(desk);
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

    /**
     * unused i think...
     * <p>
     * todo remove
     * @param booking
     * @return
     */
    @SchemaMapping
    public User user(Booking booking) {
        return booking.getUser();
    }

}
