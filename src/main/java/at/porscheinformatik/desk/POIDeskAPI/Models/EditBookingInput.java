package at.porscheinformatik.desk.POIDeskAPI.Models;

import java.time.LocalDate;
import java.util.UUID;

public record EditBookingInput(UUID pk_bookingid, UUID seatid ,LocalDate date, boolean isMorning, boolean isAfternoon ) {

}
