package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.YearlyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.MonthlyBookingPrediction;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Types.IdentifierType;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.YearlyBookingPrediction;
import at.porscheinformatik.desk.POIDeskAPI.Services.YearlyBookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import java.util.*;
import java.util.concurrent.ExecutionException;

@Controller
public class YearlyBookingController {
    @Autowired
    private YearlyBookingService yearlyBookingService;
    @QueryMapping
    public List<String> getAllYears() throws ExecutionException, InterruptedException {
        return yearlyBookingService.getAllYears().get();
    }
    @QueryMapping
    public YearlyBooking getYearlyBookingByLocation(@Argument String year, @Argument UUID location) throws ExecutionException, InterruptedException {
        return yearlyBookingService.getYearlyBooking(year, location, IdentifierType.Location).get();
    }
    @QueryMapping
    public YearlyBooking getYearlyBookingByBuilding(@Argument String year, @Argument UUID building ) throws ExecutionException, InterruptedException {
        return yearlyBookingService.getYearlyBooking(year, building, IdentifierType.Building).get();
    }
    @QueryMapping
    public YearlyBooking getYearlyBookingByFloor(@Argument String year, @Argument UUID floor) throws ExecutionException, InterruptedException {
        return yearlyBookingService.getYearlyBooking(year, floor, IdentifierType.Floor).get();
    }
    @QueryMapping
    public YearlyBookingPrediction[] getYearlyBookingPrediction(@Argument UUID identifier, @Argument IdentifierType identifierType) throws ExecutionException, InterruptedException {
        return yearlyBookingService.getYearlyBookingPrediction(identifier, identifierType).get();
    }
}
