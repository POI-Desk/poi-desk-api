package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.LocationRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Location;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
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
    public Location addLocation(@Argument String name) {
        if (locationRepo.existsLocationByLocationname(name)) return null;
        Location location = new Location();
        location.setLocationname(name);
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

    @MutationMapping
    public Location changeNameOfLocation(@Argument UUID id, @Argument String newName) {
        Location location = locationRepo.findById(id).get();
        location.setLocationname(newName);
        locationRepo.save(location);
        return location;
    }

    @QueryMapping
    public List<User> getAdminsOfLocation(@Argument UUID locationid) {
        Location location = locationRepo.findById(locationid).get();
        System.out.println(location.getLocationname());
        List<User> admins = location.getAdmins();
        admins.forEach(System.out::println);
        return admins;
    }

}
