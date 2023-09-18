package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.time.LocalDate;
import java.util.UUID;

public record EditBookingInput (UUID pk_bookingid, UUID deskid, LocalDate date, boolean ismorning, boolean isafternoon) {
}
