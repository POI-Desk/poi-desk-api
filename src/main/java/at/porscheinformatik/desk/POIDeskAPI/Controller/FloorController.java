package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BuildingRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Services.FloorService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;
import java.util.UUID;

@Controller
public class FloorController {

    /**
     * The floor repository
     */
    @Autowired
    private FloorRepo floorRepo;

    /**
     * The building repository
     */
    @Autowired
    private FloorService floorService;
    @Autowired
    private BuildingRepo buildingRepo;

    /**
     * Finds all desks in database
     * @return List of floors
     */
    @QueryMapping
    public List<Floor> getAllFloors() {
        return (List<Floor>) floorRepo.findAll();
    }

    /**
     * Finds all floors in building with the specified id
     * returns empty list if the there isn't any building associated with the id
     * @param buildingid UUID, search for floors here
     * @return List of floors
     */
    @QueryMapping
    public List<Floor> getFloorsInBuilding(@Argument UUID buildingid) {
        return buildingRepo.findById(buildingid).isPresent() ?
                floorRepo.findByBuilding(buildingRepo.findById(buildingid).get()) :
                List.of();
    }
}
