package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DeskRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MapRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Attribute;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.Desk;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateDeskInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class DeskService {
    @Autowired
    DeskRepo deskRepo;
    @Autowired
    MapRepo mapRepo;
    @Autowired
    BookingService bookingService;
    @Autowired
    AttributeService attributeService;


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

        Optional<at.porscheinformatik.desk.POIDeskAPI.Models.Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            throw new IllegalArgumentException("No map found with given id");
        Map map = o_map.get();
        return updateDesks(map, deskInputs);
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

        CompletableFuture<List<Booking>> delBookings = bookingService.deleteBookings(bookingIds);
        CompletableFuture<List<Attribute>> delAttributes = attributeService.deleteAttributes(delDesks);

        CompletableFuture.allOf(delBookings, delAttributes);

        deskRepo.deleteAll(delDesks);
        return CompletableFuture.completedFuture(delDesks);
    }

    @Async
    public CompletableFuture<List<Desk>> deleteDesks(Map map) throws ExecutionException, InterruptedException {
        List<UUID> desksIds = deskRepo.findAllByMap(map).stream().map(Desk::getPk_deskid).toList();
        return deleteDesks(desksIds);
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
            if (deskInput.pk_deskid() == null) {
                if (desks.stream().anyMatch(d -> Objects.equals(d.getDesknum(), deskInput.desknum()))) {
                    throw new Exception("DeskNum already exists " + deskInput.desknum());
                }
                finalDesks.add(new Desk(deskInput.desknum(), deskInput.x(), deskInput.y(), map.getFloor(), map));
                continue;
            }
            Optional<Desk> o_desk = desks.stream().filter(desk -> Objects.equals(desk.getPk_deskid().toString(), deskInput.pk_deskid().toString())).findFirst();
            if (o_desk.isEmpty()) {
                throw new Exception("any given desk ID does not exist");
            }
            Desk c_desk = o_desk.get();
            c_desk.updateProps(deskInput.desknum(), deskInput.x(), deskInput.y());
            finalDesks.add(c_desk);
        }

        deskRepo.saveAll(finalDesks);
        return CompletableFuture.completedFuture(finalDesks);
    }
}
