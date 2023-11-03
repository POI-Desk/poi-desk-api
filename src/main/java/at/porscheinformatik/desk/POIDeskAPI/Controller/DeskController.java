package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DeskRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MapRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import at.porscheinformatik.desk.POIDeskAPI.Models.Desk;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.DeskInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
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

@Controller
public class DeskController {

    @Autowired
    private DeskRepo deskRepo;

    @Autowired
    private FloorRepo floorRepo;

    @Autowired
    private BookingRepo bookingRepo;
    @Autowired
    private MapRepo mapRepo;

    @QueryMapping
    public List<Desk> getAllDesks() {
        return (List<Desk>) deskRepo.findAll();
    }

    @QueryMapping
    public Desk getDeskById(@Argument UUID deskid){
        return deskRepo.findById(deskid).get();
    }

    /**
     * Finds all Seats on a specified floor
     *
     * @param floorid
     * @return List<Seat>
     */
    @QueryMapping
    public List<Desk> getDesksOnFloor(@Argument UUID floorid) {
        List<Desk> seats = new ArrayList<>();

        deskRepo.findAll().forEach(seat -> {
            if (seat.getFloor().getPk_floorid().equals(floorid)) {
                seats.add(seat);
            }
        });

        return seats;
    }

    @MutationMapping
    public List<Desk> addDesksToFloor(@Argument UUID floorId, @Argument UUID mapId, @Argument List<DeskInput> desks) throws InvalidRelationIdException {
        List<Desk> newSeats = new ArrayList<>();
        Optional<Floor> o_floor = floorRepo.findById(floorId);
        if (o_floor.isEmpty())
            throw new InvalidRelationIdException("floor id does not exist");

        Optional<Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            throw new InvalidRelationIdException("map id does not exist");

        desks.forEach(s -> {
            newSeats.add(new Desk(s.desknum(), s.x(), s.y(), o_floor.get(), o_map.get()));
        });
        deskRepo.saveAll(newSeats);

        return newSeats;
    }

    @SchemaMapping
    public List<Booking> bookings(Desk desk) {return desk.getBookings();}

}
