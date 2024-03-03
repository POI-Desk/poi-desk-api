package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DailyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.DailyBooking;
import at.porscheinformatik.desk.POIDeskAPI.Models.MonthlyBooking;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Types.IdentifierType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Objects;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
public class DailyBookingService {
    @Autowired
    private DailyBookingRepo dailyBookingRepo;

    @Async
    public CompletableFuture<List<DailyBooking>> getLast30DaysByLocation(UUID locationId) {
        List<DailyBooking> dailyBookings = (List<DailyBooking>)dailyBookingRepo.findAll();
        return CompletableFuture.completedFuture(dailyBookings);/*
        List<DailyBooking> dailyBookingsInLocation = (dailyBookings.stream().filter(booking ->
                Objects.equals(booking.getFk_location().getPk_locationid(), locationId)
        ).toList());
        if (dailyBookingsInLocation.isEmpty())
            return null;
        return CompletableFuture.completedFuture(dailyBookingsInLocation);
        /*dailyBookingsInLocation.sort(Comparator.comparing(DailyBooking::getDay));
        int startIndex = Math.max(0, dailyBookingsInLocation.size() - 30);
        return CompletableFuture.completedFuture(dailyBookingsInLocation.subList(startIndex, dailyBookingsInLocation.size()));
    */}
}
