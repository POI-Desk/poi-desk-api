package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.time.LocalDate;
import java.util.UUID;

/**
 * Input for Bookings
 * @param date Date, date of the booking
 * @param ismorning Boolean, is the booking in the morning
 * @param isafternoon Boolean, is the booking in the afternoon
 * @param userid UUID, id of the user who booked the desk
 * @param deskid UUID, id of the desk being booked
 */
public record BookingInput (LocalDate date, boolean ismorning, boolean isafternoon, UUID userid, UUID deskid) {
}
