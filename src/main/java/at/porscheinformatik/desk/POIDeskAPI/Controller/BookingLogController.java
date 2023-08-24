package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.Models.BookingLog;
import at.porscheinformatik.desk.POIDeskAPI.Services.BookingLogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class BookingLogController {

    @Autowired
    private BookingLogService bookingLogService;

    @QueryMapping
    public List<BookingLog> getAllBookingLogs() { return bookingLogService.getAllBookingLogs(); }
}
