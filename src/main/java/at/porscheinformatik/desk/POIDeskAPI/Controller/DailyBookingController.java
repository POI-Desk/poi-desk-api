package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DailyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.DailyBooking;
import at.porscheinformatik.desk.POIDeskAPI.Models.YearlyBooking;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.Collection;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

@Controller
public class DailyBookingController {
    @Autowired
    private DailyBookingRepo dailyBookingRepo;

    @QueryMapping
    public List<DailyBooking> getDailyBookings()
    {
        List<DailyBooking> dailyBookings = (List<DailyBooking>) dailyBookingRepo.findAll();
        for (DailyBooking dailyBooking: dailyBookings) {
            //System.out.println(dailyBooking.getTotalBooking() + dailyBooking.getPk_day());
        }

        return dailyBookings;
    }
}
