package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.YearlyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.*;

@Controller
public class YearlyBookingController {
    @Autowired
    private YearlyBookingRepo yearlyBookingRepo;

    @QueryMapping
    public YearlyBooking getYearlyBooking(@Argument String year, @Argument UUID location)
    {
        List<YearlyBooking> yearlyBookings = (List<YearlyBooking>) yearlyBookingRepo.findAll();
        Optional<YearlyBooking> yearlyBooking = yearlyBookings.stream()
                .filter(booking -> Objects.equals(booking.getFk_Location().getPklocationid(), location))
                .filter(booking -> Objects.equals(booking.getYear(), year))
                .findFirst();
        return yearlyBooking.orElse(null);
    }

    @QueryMapping
    public List<String> getAlLYears(){
        List<YearlyBooking> yearlyBookings = (List<YearlyBooking>)yearlyBookingRepo.findAll();
        List<String> uniqueYears = new ArrayList<>();
        for (YearlyBooking yearlyBooking : yearlyBookings) {
            if (!uniqueYears.contains(yearlyBooking.getYear())) {
                uniqueYears.add(yearlyBooking.getYear());
            }
        }
        if(uniqueYears.isEmpty())
            return null;
       return uniqueYears;
    }
}
