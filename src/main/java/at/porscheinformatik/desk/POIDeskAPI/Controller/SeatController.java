package at.porscheinformatik.desk.POIDeskAPI.Controller;

import at.porscheinformatik.desk.POIDeskAPI.ModelRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.ModelRepos.SeatRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Seat;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.QueryMapping;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class SeatController {

    @Autowired
    private SeatRepo seatRepo;

    @QueryMapping
    public List<Seat> getAllSeats () {return (List<Seat>)seatRepo.findAll();}

    /**
     * Finds all Seats on a specified floor
     * @param floorId
     * @return List<Seat>
     */
    @QueryMapping
    public List<Seat> getSeatsOnFloor(UUID floorId) {
        List<Seat> seats = new ArrayList<>();

        // TODO make work
        seatRepo.findAll().forEach(seat -> {
            if (seat.getFloor().getPk_floorid().equals(floorId)) seats.add(seat);
        });

        return seats;
    }
}
