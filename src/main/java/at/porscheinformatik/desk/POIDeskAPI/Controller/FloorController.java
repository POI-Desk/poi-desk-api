package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.List;

@Controller
public class FloorController {
    @Autowired
    FloorRepo floorRepo;

    @QueryMapping
    public List<Floor> getAllFloors() {
        return (List<Floor>) floorRepo.findAll();
    }
}
