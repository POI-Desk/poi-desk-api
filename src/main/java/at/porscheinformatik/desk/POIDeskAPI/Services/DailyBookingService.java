package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DailyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.DailyBooking;
import at.porscheinformatik.desk.POIDeskAPI.Models.MonthlyBooking;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Types.IdentifierType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Stream;

@Service
public class DailyBookingService {
    @Autowired
    private DailyBookingRepo dailyBookingRepo;

    @Async
    public CompletableFuture<List<DailyBooking>> Last30DaysByLocation(UUID locationId) {
        List<DailyBooking> dailyBookingsInLocation = filterMonthlyBookings(locationId);
        if (dailyBookingsInLocation.isEmpty())
            return null;

        List<DailyBooking> sortedBookings = dailyBookingsInLocation.stream().sorted((Comparator.comparing(DailyBooking::getDay))).toList();
          //      .sort(Comparator.comparing(DailyBooking::getDay));
        int startIndex = Math.max(0, sortedBookings.size() - 30);
        return CompletableFuture.completedFuture(sortedBookings.subList(startIndex, sortedBookings.size()));


    }

    private List<DailyBooking> filterMonthlyBookings(UUID locationId){
        List<DailyBooking> dailyBookings = (List<DailyBooking>)dailyBookingRepo.findAll();
        return  dailyBookings.stream().filter(booking ->
                booking.getFk_location() != null &&
                        Objects.equals(booking.getFk_location().getPk_locationid(), locationId))
                .toList();
    }
}
