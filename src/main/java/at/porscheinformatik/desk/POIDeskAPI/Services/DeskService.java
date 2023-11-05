package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DeskRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MapRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Desk;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateDeskInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CompletableFuture;

@Service
public class DeskService {
    @Autowired
    DeskRepo deskRepo;
    @Autowired
    MapRepo mapRepo;


    /**
     * Updates give desks on map.
     *
     * @param mapId The mapId the desks belong to.
     * @param deskInputs The new/updated desk inputs.
     * @return The new/updated desks.
     *
     * @throws IllegalArgumentException if map with given map ID does not exist
     * @throws Exception if any given desk number is already in use
     */
    @Async
    public CompletableFuture<List<Desk>> updateDesks(UUID mapId, List<UpdateDeskInput> deskInputs) throws Exception {

        Optional<at.porscheinformatik.desk.POIDeskAPI.Models.Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            throw new IllegalArgumentException("No map found with given id");
        Map map = o_map.get();
        return updateDesks(map, deskInputs);
    }

    /**
     * Updates give desks on map.
     *
     * @param map The map the desks belong to.
     * @param deskInputs The new/updated desk inputs.
     * @return The new/updated desks.
     *
     * @throws Exception if any given desk number is already in use
     */
    @Async
    public CompletableFuture<List<Desk>> updateDesks(Map map, List<UpdateDeskInput> deskInputs) throws Exception{
        List<Desk> desks = deskRepo.findAllByMap(map);
        List<Desk> finalDesks = new ArrayList<>();
        for (UpdateDeskInput deskInput : deskInputs) {
            if (deskInput.id() == null) {
                if (desks.stream().anyMatch(d -> Objects.equals(d.getDesknum(), deskInput.desknum()))) {
                    throw new Exception("DeskNum already exists " + deskInput.desknum());
                }
                finalDesks.add(new Desk(deskInput.desknum(), deskInput.x(), deskInput.y(), map.getFloor(), map));
                continue;
            }
            Optional<Desk> o_desk = desks.stream().filter(desk -> Objects.equals(desk.getPk_deskid().toString(), deskInput.id().toString())).findFirst();
            if (o_desk.isEmpty()) {
                continue;
            }
            Desk c_desk = o_desk.get();
            c_desk.updateProps(deskInput.desknum(), deskInput.x(), deskInput.y());
            finalDesks.add(c_desk);
        }

        deskRepo.saveAll(finalDesks);
        return CompletableFuture.completedFuture(finalDesks);
    }
}
