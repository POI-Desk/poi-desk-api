package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.LocationRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Location;
import at.porscheinformatik.desk.POIDeskAPI.Services.LocationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.concurrent.ExecutionException;

@Controller
public class LocationController {
    /**
     * The location repository
     */
    @Autowired
    private LocationRepo locationRepo;

    @Autowired
    private LocationService locationService;

    /**
     * Finds all locations in the database
     * @return List of all locations
     */
    @QueryMapping
    public List<Location> getAllLocations() { return (List<Location>)locationRepo.findAll(); }

    @QueryMapping
    public Location getLocationByName(@Argument String name) throws ExecutionException, InterruptedException {
        return locationService.getLocationByName(name).get();
    }
}
