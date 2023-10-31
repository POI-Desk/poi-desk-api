package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.InteriorRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.InteriorInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Interior;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.stereotype.Service;

@Service
public class InteriorService {
    @Autowired
    InteriorRepo interiorRepo;

    public Interior addInterior(InteriorInput input){
        Interior interior = new Interior(input.type(), input.x(), input.y(), input.rotation(), input.width(), input.height());
        interiorRepo.save(interior);
        return interior;
    }
}
