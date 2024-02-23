package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.QuarterlyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.MonthlyBooking;
import at.porscheinformatik.desk.POIDeskAPI.Models.QuarterlyBooking;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.MonthlyBookingPrediction;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.QuarterlyBookingPrediction;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Types.IdentifierType;
import at.porscheinformatik.desk.POIDeskAPI.Services.MonthlyBookingService;
import at.porscheinformatik.desk.POIDeskAPI.Services.QuarterlyBookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

@Controller
public class QuarterlyBookingController {
    @Autowired
    private QuarterlyBookingService quarterlyBookingService;
    @QueryMapping
    public QuarterlyBooking getQuarterlyBookingByLocation(@Argument String year, @Argument String quarter, @Argument UUID location) throws ExecutionException, InterruptedException {
        return quarterlyBookingService.getQuarterlyBooking(year, Integer.parseInt(quarter), location, IdentifierType.Location).get();
    }
    @QueryMapping
    public QuarterlyBooking getQuarterlyBookingByBuilding(@Argument String year, @Argument String quarter, @Argument UUID building) throws ExecutionException, InterruptedException {
        return quarterlyBookingService.getQuarterlyBooking(year, Integer.parseInt(quarter), building, IdentifierType.Building).get();
    }
    @QueryMapping
    public QuarterlyBooking getQuarterlyBookingByFloor(@Argument String year, @Argument String quarter, @Argument UUID floor) throws ExecutionException, InterruptedException {
        return quarterlyBookingService.getQuarterlyBooking(year, Integer.parseInt(quarter), floor, IdentifierType.Floor).get();
    }
    @QueryMapping
    public QuarterlyBookingPrediction[] getQuarterlyBookingPrediction(@Argument UUID identifier, @Argument IdentifierType identifierType) throws ExecutionException, InterruptedException {
        return quarterlyBookingService.getQuarterlyBookingPrediction(identifier, identifierType).get();
    }
}