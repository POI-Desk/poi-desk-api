package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BuildingRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.LocationRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Building;
import at.porscheinformatik.desk.POIDeskAPI.Models.Location;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;

@Controller
public class BuildingController {
    @Autowired
    BuildingRepo buildingRepo;
    @Autowired
    private LocationRepo locationRepo;

    @QueryMapping
    public List<Building> getBuildingsInLocation(@Argument UUID locationId) {return buildingRepo.findByLocation(locationRepo.findById(locationId).get());}
}
