package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.QuarterlyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.QuarterlyBooking;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;

@Controller
public class QuarterlyBookingController {
    @Autowired
    private QuarterlyBookingRepo quarterlyBookingRepo;

    @QueryMapping
    public QuarterlyBooking getQuarterlyBooking(@Argument String year, @Argument String quarter, @Argument UUID location)
    {
        List<QuarterlyBooking> quarterlyBookings = (List<QuarterlyBooking>)quarterlyBookingRepo.findAll();
        Optional<QuarterlyBooking> quarterlyBooking = quarterlyBookings.stream()
                .filter(booking -> Objects.equals(booking.getFk_Location().getPklocationid(), location))
                .filter(booking -> Objects.equals(booking.getQuarter(), quarter))
                .filter(booking -> Objects.equals(booking.getYear(), year))
                .findFirst();
        return quarterlyBooking.orElse(null);
    }
}
