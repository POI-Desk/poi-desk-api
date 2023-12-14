package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BuildingRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.LocationRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Building;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Controller
public class BuildingController {
    /**
     * The building repository
     */
    @Autowired
    private BuildingRepo buildingRepo;

    /**
     * The location repository
     */
    @Autowired
    private LocationRepo locationRepo;


    /**
     * Finds all buildings in a location with the specified id
     * <p>
     * Returns empty ArrayList if location is not present
     * @param locationid UUID, search for buildings here
     * @return List of building
     */
    @QueryMapping
    public List<Building> getBuildingsInLocation(@Argument UUID locationid) {
        if (locationRepo.findById(locationid).isPresent()) return buildingRepo.findByLocation(locationRepo.findById(locationid).get());
        return new ArrayList<>();
    }
}
