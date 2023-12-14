package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.LocationRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Location;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class LocationController {
    /**
     * The location repository
     */
    @Autowired
    private LocationRepo locationRepo;

    /**
     * Finds all locations in the database
     * @return List of all locations
     */
    @QueryMapping
    public List<Location> getAllLocations() { return (List<Location>)locationRepo.findAll(); }
}
