package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BookingLogRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.BookingLog;
import at.porscheinformatik.desk.POIDeskAPI.Services.BookingLogService;
import at.porscheinformatik.desk.POIDeskAPI.Models.BookingLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class BookingLogController
{
    @Autowired
    private BookingLogRepo bookingLogRepo;

    @Autowired
    private BookingLogService bookingLogService;

    @QueryMapping
    public List<BookingLog> getAllBookingLogs() { return bookingLogService.getAllBookingLogs(); }

    @QueryMapping
    public List<BookingLog> getAllExpiredBookingLogs()
    {
        List<BookingLog> bookings = (List<BookingLog>)bookingLogRepo.findAll();
        return bookings.stream().filter(deletedBookings -> deletedBookings.isWasdeleted() == false).toList();
    }

    @QueryMapping
    public List<BookingLog> getAllDeletedBookingLogs()
    {
        List<BookingLog> bookings = (List<BookingLog>)bookingLogRepo.findAll();
        return bookings.stream().filter(deletedBookings -> deletedBookings.isWasdeleted() == true).toList();
    }
    @QueryMapping
    public List<BookingLog> getMorningBookingLogs()
    {
        List<BookingLog> bookings = (List<BookingLog>)bookingLogRepo.findAll();
        return bookings.stream()
                .filter(deletedBookings -> deletedBookings.isIsmorning() == true
                        && deletedBookings.isIsafternoon() == false)
                .toList();
    }
    @QueryMapping
    public List<BookingLog> getAfternoonBookingLogs()
    {
        List<BookingLog> bookings = (List<BookingLog>)bookingLogRepo.findAll();
        List<BookingLog> b = bookings.stream()
                .filter(deletedBookings -> deletedBookings.isIsmorning() == false
                        && deletedBookings.isIsafternoon() == true)
                .toList();
        return b;
    }
    @QueryMapping
    public List<BookingLog> getFullDayBookingLogs()
    {
        List<BookingLog> bookings = (List<BookingLog>)bookingLogRepo.findAll();
        return bookings.stream()
                .filter(deletedBookings -> deletedBookings.isIsmorning() == true
                        && deletedBookings.isIsafternoon() == true)
                .toList();
    }
}
