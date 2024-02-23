package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MonthlyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.MonthlyBooking;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

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
    /*
    @QueryMapping
    public MonthlyBooking getMonthlyBookingByBuilding(@Argument String year, @Argument String month, @Argument UUID location, @Argument String buildingname)
    {
        List<MonthlyBooking> monthlyBookings = (List<MonthlyBooking>)monthlyBookingRepo.findAll();
        List<MonthlyBooking> monthlyBooking = monthlyBookings.stream()
                .filter(booking -> Objects.equals(booking.getFk_Location().getPk_locationid(), location))
                .filter(booking -> Objects.equals(booking.getMonth(), year + "-" + month))
                .filter(booking -> Objects.equals(booking.getFk_building().getBuildingname() , buildingname)).toList();
        Optional<MonthlyBooking> m = monthlyBookings.stream().findFirst();
        if(m.isEmpty()){
            return null;
        }
        MonthlyBooking returnbooking = m.get();
        returnbooking.setTotalBookings(monthlyBookings.stream()
            .mapToInt(MonthlyBooking::getTotalBookings)
            .sum());
        returnbooking.setAfternoonAverageBooking(monthlyBookings.stream().mapToDouble(MonthlyBooking::getAfternoonAverageBooking).average().getAsDouble());
        returnbooking.setMorningAverageBooking(monthlyBookings.stream().mapToDouble(MonthlyBooking::getMorningAverageBooking).average().getAsDouble());

        return monthlyBooking.orElse(null);
    }
    @QueryMapping
    public MonthlyBooking getMonthlyBookingByFloor(@Argument String year, @Argument String month, @Argument UUID location, @Argument String buildingname, @Argument String floorname)
    {
        List<MonthlyBooking> monthlyBookings = (List<MonthlyBooking>)monthlyBookingRepo.findAll();
        Optional<MonthlyBooking> monthlyBooking = monthlyBookings.stream()
                .filter(booking -> Objects.equals(booking.getFk_Location().getPk_locationid(), location))
                .filter(booking -> Objects.equals(booking.getMonth(), year + "-" + month))
                .filter(booking -> Objects.equals(booking.getFk_building().getBuildingname() , buildingname))
                .filter(booking -> Objects.equals(booking.getFk_floor().getFloorname() , floorname))
                .findFirst();
        return monthlyBooking.orElse(null);
    }*/
}
