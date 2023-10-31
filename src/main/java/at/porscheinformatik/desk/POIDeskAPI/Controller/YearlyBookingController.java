package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.YearlyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.Iterator;
import java.util.List;
@Controller
public class YearlyBookingController {
    @Autowired
    private YearlyBookingRepo yearlyBookingRepo;

    @QueryMapping
    public Iterable<YearlyBooking> getYearlyBookings()
    {
        Iterable<YearlyBooking> yearlyBookings = yearlyBookingRepo.findAll();
        return yearlyBookings;
    }
}
