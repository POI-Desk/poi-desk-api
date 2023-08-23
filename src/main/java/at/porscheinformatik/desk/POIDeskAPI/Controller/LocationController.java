package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ModelRepos.LocationRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Location;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class LocationController {

    @Autowired
    private LocationRepo locationRepo;

    @QueryMapping
    public List<Location> getAllLocations() { return (List<Location>)locationRepo.findAll(); }
}
