package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.Models.MonthlyBooking;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.MonthlyBookingPrediction;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Types.IdentifierType;
import at.porscheinformatik.desk.POIDeskAPI.Services.MonthlyBookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.UUID;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.ExecutionException;

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
}