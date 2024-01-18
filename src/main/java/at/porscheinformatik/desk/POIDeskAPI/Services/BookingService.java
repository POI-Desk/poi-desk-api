package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class BookingService {

    @Autowired
    private BookingRepo bookingRepo;

    @Autowired
    private FloorService floorService;

    public UUID deleteBooking(UUID bookingId){
        Optional<Booking> booking = bookingRepo.findById(bookingId);
        if (booking.isEmpty())
            return null;

        bookingRepo.delete(booking.get());
        return bookingId;
    }

    public boolean deleteBookings(List<UUID> bookingIds){
        Iterable<Booking> i_booking = bookingRepo.findAllById(bookingIds);
        bookingRepo.deleteAll(i_booking);

        return true;
    }

    @Async
    public CompletableFuture<List<Booking>> getBookingsByDateOnFloor(LocalDate date, UUID floorId) throws ExecutionException, InterruptedException {
        Floor floor = floorService.getFloorById(floorId).get();
        Iterable<Booking> i_bookings = bookingRepo.findBookingsByDateAndDeskFloor(date, floor);
        List<Booking> bookings = new ArrayList<>();
        for (Booking booking:
             i_bookings) {
            bookings.add(booking);
        }
        return CompletableFuture.completedFuture(bookings);
    }

}