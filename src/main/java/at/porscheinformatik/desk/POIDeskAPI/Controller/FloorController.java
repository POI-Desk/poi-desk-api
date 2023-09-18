package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BuildingRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;

@Controller
public class FloorController {
    @Autowired
    FloorRepo floorRepo;
    @Autowired
    private BuildingRepo buildingRepo;

    @QueryMapping
    public List<Floor> getAllFloors() {
        return (List<Floor>) floorRepo.findAll();
    }

    @QueryMapping
    public List<Floor> getFloorsInBuilding(@Argument UUID buildingid) {
//        if (buildingid == null) buildingRepo.fin

        return buildingRepo.findById(buildingid).isPresent() ?
                floorRepo.findByBuilding(buildingRepo.findById(buildingid).get()) :
                List.of();
    }
}
