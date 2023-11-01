package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.UUID;

@Service
public class FloorService {
    @Autowired
    private FloorRepo floorRepo;

    public Map getMapByFloor(UUID floorId){
        var floorOp = floorRepo.findById(floorId);
        if (floorOp.isEmpty())
            return null;

        return floorOp.get().getMap();
    }
}
