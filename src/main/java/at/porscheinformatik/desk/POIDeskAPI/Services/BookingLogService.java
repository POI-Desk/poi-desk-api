package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BookingLogRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.BookingLog;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class BookingLogService {

    @Autowired
    private BookingLogRepo bookingLogRepo;

    public List<BookingLog> getAllBookingLogs() { return (List<BookingLog>) bookingLogRepo.findAll(); }
}
