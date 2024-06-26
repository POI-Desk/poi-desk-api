package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MonthlyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.DailyBooking;
import at.porscheinformatik.desk.POIDeskAPI.Models.MonthlyBooking;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.MonthlyBookingPrediction;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Types.IdentifierType;
import at.porscheinformatik.desk.POIDeskAPI.Services.FloorService;
import at.porscheinformatik.desk.POIDeskAPI.Services.MonthlyBookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.ExecutionException;
import java.util.function.Function;
@Controller
public class MonthlyBookingController {
    @Autowired
    private MonthlyBookingService monthlyBookingService;

    @QueryMapping
    public MonthlyBooking getMonthlyBookingByLocation(@Argument String year, @Argument String month, @Argument UUID location) throws ExecutionException, InterruptedException {
        return monthlyBookingService.getMonthlyBooking(year, month, location, IdentifierType.Location).get();
    }

    @QueryMapping
    public MonthlyBooking getMonthlyBookingByBuilding(@Argument String year, @Argument String month, @Argument UUID building) throws ExecutionException, InterruptedException {
        return monthlyBookingService.getMonthlyBooking(year, month, building, IdentifierType.Building).get();
    }
    @QueryMapping
    public MonthlyBooking getMonthlyBookingByFloor(@Argument String year, @Argument String month, @Argument UUID floor) throws ExecutionException, InterruptedException {
        return monthlyBookingService.getMonthlyBooking(year, month, floor, IdentifierType.Floor).get();
    }

    @QueryMapping
    public MonthlyBookingPrediction[] getMonthlyBookingPrediction(@Argument UUID identifier, @Argument IdentifierType identifierType) throws ExecutionException, InterruptedException {
        return monthlyBookingService.getMonthlyBookingPrediction(identifier, identifierType).get();
    }
    /*
    @SchemaMapping
    public List<DailyBooking> dailyBooking(MonthlyBooking monthlyBooking){
        List<DailyBooking> dailyBookingList = monthlyBooking.getDailyBookings();
        Collections.sort(dailyBookingList);
        return dailyBookingList;
    }*/
}