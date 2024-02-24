package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import at.porscheinformatik.desk.POIDeskAPI.Models.Floor;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import jakarta.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.awt.print.Book;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.ExecutionException;

@Service
public class BookingService {

    @Autowired
    private BookingRepo bookingRepo;
    @Lazy
    @Autowired
    private FloorService floorService;
    @Lazy
    @Autowired
    private MapService mapService;

    @Async
    public CompletableFuture<Boolean> deleteBookingById(UUID bookingId){
        Optional<Booking> booking = bookingRepo.findById(bookingId);
        if (booking.isEmpty())
            return CompletableFuture.completedFuture(false);

        bookingRepo.delete(booking.get());
        return CompletableFuture.completedFuture(true);
    }

    @Async
    public CompletableFuture<Boolean> deleteBooking(Booking booking){
        bookingRepo.delete(booking);
        return CompletableFuture.completedFuture(true);
    }

    @Async
    public CompletableFuture<Boolean> deleteBookingsByIds(List<UUID> bookingIds){
        Iterable<Booking> i_booking = bookingRepo.findAllById(bookingIds);
        bookingRepo.deleteAll(i_booking);

        return CompletableFuture.completedFuture(true);
    }

    @Async
    public CompletableFuture<Boolean> deleteBookings(List<Booking> bookings){
        bookingRepo.deleteAll(bookings);
        return CompletableFuture.completedFuture(true);
    }

    @Async
    public CompletableFuture<List<Booking>> getBookingsByDateOnFloor(LocalDate date, UUID floorId) throws ExecutionException, InterruptedException {
        Floor floor = floorService.getFloorById(floorId).get();
        if (floor == null)
            return null;

        List<Booking> bookings = bookingRepo.findBookingsByDateAndDeskMapFloor(date, floor);
        return CompletableFuture.completedFuture(bookings);
    }
    @Async
    public CompletableFuture<List<Booking>> getBookingsBetweenDates(LocalDate startDate, LocalDate endDate) {
        Iterable<Booking> i_bookings = bookingRepo.findBookingsByDateBetween(startDate, endDate);
        List<Booking> bookings = new ArrayList<>();
        for (Booking booking : i_bookings) {
            bookings.add(booking);
        }
        return CompletableFuture.completedFuture(bookings);
    }

    @Async
    public CompletableFuture<Boolean> deleteAllBookingsOnMap(Optional<UUID> mapId) throws ExecutionException, InterruptedException {
        if (mapId.isEmpty()) return CompletableFuture.completedFuture(false);

        Map map = mapService.getMapById(mapId.get()).get();
        if (map == null) return CompletableFuture.completedFuture(false);

        List<Booking> bookings = bookingRepo.findAllByDeskMap(map);
        bookingRepo.deleteAll(bookings);

        return CompletableFuture.completedFuture(true);
    }


}