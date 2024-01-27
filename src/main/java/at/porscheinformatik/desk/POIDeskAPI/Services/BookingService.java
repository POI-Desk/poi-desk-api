package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.BookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Booking;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.*;
import java.util.concurrent.CompletableFuture;

@Service
public class BookingService {

    @Autowired
    private BookingRepo bookingRepo;

    public UUID deleteBooking(UUID bookingId){
        Optional<Booking> booking = bookingRepo.findById(bookingId);
        if (booking.isEmpty())
            return null;

        bookingRepo.delete(booking.get());
        return bookingId;
    }

    public List<Booking> deleteBookings(List<UUID> bookingIds){
        Iterable<Booking> i_booking = bookingRepo.findAllById(bookingIds);
        bookingRepo.deleteAll(i_booking);

        return (List<Booking>)i_booking;
    }

    @Async
    public CompletableFuture<List<Booking>> getBookingsOnDate(LocalDate date){
        Iterable<Booking> i_bookings = bookingRepo.findBookingsByDate(date);
        List<Booking> bookings = new ArrayList<>();
        for (Booking booking:
             i_bookings) {
            bookings.add(booking);
        }
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


}