package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.Models.DailyBooking;
import at.porscheinformatik.desk.POIDeskAPI.Services.DailyBookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.*;
import java.util.concurrent.ExecutionException;

@Controller
public class DailyBookingController {
    @Autowired
    private DailyBookingService dailyBookingService;
    @QueryMapping
    public List<DailyBooking> Last30DaysByLocation(@Argument UUID locationId) throws ExecutionException, InterruptedException {
        return dailyBookingService.getLast30DaysByLocation(locationId).get();
    }
}
