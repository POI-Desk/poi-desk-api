package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.InteriorRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.InteriorInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Interior;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Models.Room;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
public class InteriorService {
    @Autowired
    InteriorRepo interiorRepo;

    public Interior addInterior(InteriorInput input){
        Interior interior = new Interior(input.type(), input.x(), input.y(), input.rotation(), input.width(), input.height());
        interiorRepo.save(interior);
        return interior;
    }

    @Async
    public CompletableFuture<List<Interior>> deleteInteriors(List<UUID> interiorId){
        Iterable<Interior> i_interiors = interiorRepo.findAllById(interiorId);
        List<Interior> delInteriors = new ArrayList<>();
        for (Interior interior:
                i_interiors) {
            delInteriors.add(interior);
        }

        interiorRepo.deleteAll(delInteriors);
        return CompletableFuture.completedFuture(delInteriors);
    }

    @Async
    public CompletableFuture<List<Interior>> deleteInteriors(Map map){
        List<UUID> interiorIds = interiorRepo.findAllByMap(map).stream().map(Interior::getPk_interiorId).toList();
        return deleteInteriors(interiorIds);
    }

}
