package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DeskRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.DeskInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateDeskInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.management.relation.InvalidRelationIdException;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.Future;

@Service
public class DeskService {
    @Autowired
    DeskRepo deskRepo;
    @Autowired
    @Lazy
    MapService mapService;
    @Autowired
    BookingService bookingService;
    @Autowired
    AttributeService attributeService;
    @Autowired
    UserService userService;
    @Autowired
    FloorService floorService;


    /**
     * Gives the desk with given ID.
     *
     * @param deskId The ID of the requested desk.
     * @return The desks.
     *
     * @throws IllegalArgumentException if desk with given desk ID does not exist
     */
    @Async
    public CompletableFuture<Desk> getDeskById(UUID deskId){
        Optional<Desk> o_desk = deskRepo.findById(deskId);
        if (o_desk.isEmpty())
            throw new IllegalArgumentException("No desk with given ID: " + deskId);

        return CompletableFuture.completedFuture(o_desk.get());
    }

    /**
     * Updates given desks on map.
     *
     * @param mapId The mapId the desks belong to.
     * @param deskInputs The new/updated desk inputs.
     * @return The new/updated desks.
     *
     * @throws IllegalArgumentException if map with given map ID does not exist
     * @throws Exception if any given desk number is already in use / if any given desk ID does not exist
     */
    @Async
    public CompletableFuture<List<Desk>> updateDesks(UUID mapId, List<UpdateDeskInput> deskInputs) throws Exception {

        Map map = mapService.getMapById(mapId).get();
        if (map == null)
            return null;

        return updateDesks(map, deskInputs);
    }

    /**
     * <b>No side effects</b>
     * <br />
     * Calculates List of Desks with given input
     * @param map The map the desks belong to.
     * @param deskInputs The new/updated desk inputs.
     * @return The new/updated desks.
     *
     * @throws Exception if any given desk number is already in use / if any given desk ID does not exist
     */
    @Async
    public CompletableFuture<List<Desk>> updateDesks(Map map, List<UpdateDeskInput> deskInputs) throws Exception{
        List<Desk> desks = deskRepo.findAllByMap(map);
        List<Desk> finalDesks = new ArrayList<>();

        for (UpdateDeskInput deskInput : deskInputs) {
            User user = null;
            if (deskInput.userId().isPresent()){
                user = userService.getUserById(deskInput.userId().get()).get();
            }
            if (deskInput.pk_deskid() == null) {
                if (desks.stream().anyMatch(d -> Objects.equals(d.getDesknum(), deskInput.desknum()))) {
                    continue;
                }

                finalDesks.add(new Desk(deskInput.desknum(), deskInput.x(), deskInput.y(), map.getFloor(), map, user));
                continue;
            }
            Optional<Desk> o_desk = desks.stream().filter(desk -> Objects.equals(desk.getPk_deskid().toString(), deskInput.pk_deskid().toString())).findFirst();
            if (o_desk.isEmpty()) {
                continue;
            }
            Desk c_desk = o_desk.get();
            c_desk.updateProps(deskInput.desknum(), deskInput.x(), deskInput.y(), user);
            finalDesks.add(c_desk);
        }

        deskRepo.saveAll(finalDesks);
        return CompletableFuture.completedFuture(finalDesks);
    }

    @Async
    public CompletableFuture<List<Desk>> addDesksToFloor(UUID floorId, UUID mapId, List<DeskInput> desks) throws InvalidRelationIdException, ExecutionException, InterruptedException {
        List<Desk> newDesks = new ArrayList<>();
        Floor floor = floorService.getFloorById(floorId).get();
        if (floor == null)
            return null;

        Map map = mapService.getMapById(mapId).get();
        if (map == null)
            return null;

        desks.forEach(s -> {
            User user = null;
            if (s.userId().isPresent()){
                try {
                    user = userService.getUserById(s.userId().get()).get();
                } catch (InterruptedException | ExecutionException e) {
                    throw new RuntimeException(e);
                }
            }

            newDesks.add(new Desk(s.desknum(), s.x(), s.y(), floor, map, user));
        });
        deskRepo.saveAll(newDesks);

        return CompletableFuture.completedFuture(newDesks);
    }

    /**
     * Deletes the desks with given IDs.
     *
     * @param deskIds Ids of desks to delete
     * @return List of deleted desks.
     */
    @Async
    public CompletableFuture<List<Desk>> deleteDesks(List<UUID> deskIds) throws ExecutionException, InterruptedException {
        Iterable<Desk> i_desks = deskRepo.findAllById(deskIds);
        List<Desk> delDesks = new ArrayList<>();
        for (Desk desk :
                i_desks) {
            delDesks.add(desk);
        }

        List<UUID> bookingIds = delDesks.stream().map(Desk::getBookings).flatMap(bookings -> bookings.stream().map(Booking::getPk_bookingid)).toList();


        CompletableFuture<Boolean> bookingsFuture = bookingService.deleteBookingsByIds(bookingIds);
        CompletableFuture<List<Attribute>> attributesFuture = attributeService.removeAttributesFromDesk(delDesks);

        CompletableFuture.allOf(bookingsFuture, attributesFuture).get();
        deskRepo.deleteAll(deskRepo.findAllById(deskIds));
        return CompletableFuture.completedFuture(delDesks);
    }

    @Async
    public CompletableFuture<List<Desk>> deleteDesks(Map map) throws ExecutionException, InterruptedException {
        List<UUID> desksIds = deskRepo.findAllByMap(map).stream().map(Desk::getPk_deskid).toList();
        return deleteDesks(desksIds);
    }

    @Async
    public CompletableFuture<Desk> assignUserToDesk(UUID deskId, UUID userId) throws ExecutionException, InterruptedException {
        Optional<Desk> o_desk = deskRepo.findById(deskId);
        if (o_desk.isEmpty())
            return null;

        User user = userService.getUserById(userId).get();
        if (user == null)
            return null;

        Desk desk = o_desk.get();

        // don't know if this works.
        // may be risky
        // <---------------->
        CompletableFuture<Boolean> userFuture = bookingService.deleteBookings(user.getBookings());
        CompletableFuture<Boolean> deskFuture = bookingService.deleteBookings(desk.getBookings());
        // <---------------->

        CompletableFuture.allOf(userFuture, deskFuture).get();

        desk.setUser(user);
        deskRepo.save(desk);
        return CompletableFuture.completedFuture(desk);
    }
}
