package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MonthlyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.MonthlyBooking;
import at.porscheinformatik.desk.POIDeskAPI.Models.YearlyBooking;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;
import org.springframework.web.client.HttpClientErrorException;

import java.io.Console;
import java.text.MessageFormat;
import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

@Controller
public class MonthlyBookingController {
    @Autowired
    private MonthlyBookingRepo monthlyBookingRepo;

    @QueryMapping
    public MonthlyBooking getMonthlyBooking(@Argument String year, @Argument String month, @Argument UUID location)
    {

        List<MonthlyBooking> monthlyBookings = (List<MonthlyBooking>)monthlyBookingRepo.findAll();
        Optional<MonthlyBooking> monthlyBooking = monthlyBookings.stream()
                .filter(booking -> Objects.equals(booking.getFk_Location().getPk_locationid(), location))
                .filter(booking -> Objects.equals(booking.getMonth(), year + "-" + month))
                .findFirst();
        return monthlyBooking.orElse(null);
    }
}
