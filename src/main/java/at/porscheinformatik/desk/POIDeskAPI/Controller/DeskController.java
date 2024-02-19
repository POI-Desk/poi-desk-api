package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DeskRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MapRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.DeskInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateDeskInput;
import at.porscheinformatik.desk.POIDeskAPI.Services.DeskService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import javax.management.relation.InvalidRelationIdException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ExecutionException;

@Controller
public class DeskController {

    @Autowired
    private DeskRepo deskRepo;

    @Autowired
    private DeskService deskService;

    @Autowired
    private FloorRepo floorRepo;

    @Autowired
    private MapRepo mapRepo;

    /**
     * Returns all desks in database
     * @return List of all Desks
     */
    @QueryMapping
    public List<Desk> getAllDesks() {
        return (List<Desk>) deskRepo.findAll();
    }

    /**
     * Finds all desks on the map with the specified id
     * @param mapId UUID, search for desks here
     * @return List of desks on map
     */
    @QueryMapping
    public List<Desk> getDesksOnMap(@Argument UUID mapId) throws ExecutionException, InterruptedException {
        return deskService.getDesksOnMap(mapId).get();
    }

    @QueryMapping
    public Desk getDeskById(@Argument UUID deskId) throws ExecutionException, InterruptedException {
        return deskService.getDeskById(deskId).get();
    }

    @MutationMapping
    public List<Desk> updateDesksOnMap(@Argument UUID mapId, @Argument List<UpdateDeskInput> deskInputs) throws Exception {
        return deskService.updateDesks(mapId, deskInputs).get();
    }

    @MutationMapping
    public List<Desk> deleteDesks(@Argument List<UUID> deskIds) throws ExecutionException, InterruptedException {
        return deskService.deleteDesks(deskIds).get();
    }

    @MutationMapping
    public Desk assignUserToDesk(@Argument UUID deskId, @Argument UUID userId) throws ExecutionException, InterruptedException {
        return deskService.assignUserToDesk(deskId, userId).get();
    }

    @SchemaMapping
    public List<Booking> bookings(Desk desk) { return desk.getBookings(); }

    @SchemaMapping
    public Map map(Desk desk) { return desk.getMap(); }

    @SchemaMapping
    public User user(Desk desk) {return desk.getUser(); }

}
