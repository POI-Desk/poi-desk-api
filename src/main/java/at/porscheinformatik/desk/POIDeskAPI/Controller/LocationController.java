package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.LocationRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Location;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;

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

    @MutationMapping
    public Location addLocation(@Argument String name, @Argument UUID id) {
        if (locationRepo.existsLocationByLocationname(name)) return null;
        Location location = new Location();
        location.setLocationname(name);
        location.setPk_locationid(id);
        locationRepo.save(location);
        return location;
    }

    @MutationMapping
    public Location deleteLocation(@Argument UUID id) {
        if (!locationRepo.existsById(id)) return null;
        Location location = locationRepo.findById(id).get();
        locationRepo.delete(location);
        return location;
    }
}
