package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.SeatRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Seat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.graphql.data.method.annotation.QueryMapping;
import org.springframework.stereotype.Controller;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@Controller
public class SeatController {

    @Autowired
    private SeatRepo seatRepo;

    @QueryMapping
    public List<Seat> getAllSeats () {return (List<Seat>)seatRepo.findAll();}

    /**
     * Finds all Seats on a specified floor
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
}
