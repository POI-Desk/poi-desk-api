package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.InteriorRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.InteriorInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Interior;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Models.Room;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class InteriorService {
    @Autowired
    InteriorRepo interiorRepo;
    @Lazy
    @Autowired
    MapService mapService;

    public Interior addInterior(Optional<UUID> mapId, InteriorInput input) throws ExecutionException, InterruptedException {
        if (mapId.isEmpty()) return null;

        Map map = mapService.getMapById(mapId.get()).get();
        if (map == null) return null;


        Interior interior = new Interior(input.type(), input.x(), input.y(), input.rotation(), input.width(), input.height(), map);
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

    @Async
    public CompletableFuture<List<Interior>> copyInteriorsToMap(List<Interior> interiors, Map map) {
        List<Interior> newInteriors = interiors.stream().map(i -> new Interior(i.getType(), i.getX(), i.getY(), i.getRotation(), i.getWidth(), i.getHeight(), map)).toList();
        interiorRepo.saveAll(newInteriors);
        return CompletableFuture.completedFuture(newInteriors);
    }
}
