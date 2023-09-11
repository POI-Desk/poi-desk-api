package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.SeatRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import at.porscheinformatik.desk.POIDeskAPI.Models.Seat;
import at.porscheinformatik.desk.POIDeskAPI.Models.SeatInput;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.MutationMapping;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.graphql.data.method.annotation.SchemaMapping;
import org.springframework.stereotype.Controller;

import javax.management.relation.InvalidRelationIdException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicBoolean;

@Controller
public class SeatController {

    @Autowired
    private SeatRepo seatRepo;

    @Autowired
    private FloorRepo floorRepo;

    @QueryMapping
    public List<Seat> getAllSeats() {
        return (List<Seat>) seatRepo.findAll();
    }

    /**
     * Finds all Seats on a specified floor
     *
     * @param floorid
     * @return List<Seat>
     */
    @QueryMapping
    public List<Seat> getSeatsOnFloor(@Argument UUID floorid) {
        List<Seat> seats = new ArrayList<>();

        seatRepo.findAll().forEach(seat -> {
            if (seat.getFloor().getPk_floorid().equals(floorid)) {
                seats.add(seat);
            }
        });

        return seats;
    }

    @MutationMapping
    public  List<Seat> addSeatsToFloor(@Argument UUID floorid, @Argument List<SeatInput> seats) throws InvalidRelationIdException {
        List<Seat> newSeats = new ArrayList<>();
        Optional<Floor> o_floor = floorRepo.findById(floorid);
        if (o_floor.isEmpty())
            throw new InvalidRelationIdException("floor id does not exist");

        seats.forEach(s -> {
            newSeats.add(new Seat(s.desknum(), s.x(), s.y(), o_floor.get()));
        });
        seatRepo.saveAll(newSeats);

        return newSeats;
    }

    @SchemaMapping
    public List<Booking> bookings(Seat seat) {return seat.getBookings();}

}
