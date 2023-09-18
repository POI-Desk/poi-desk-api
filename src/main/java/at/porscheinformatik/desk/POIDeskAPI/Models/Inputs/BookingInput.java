package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.time.LocalDate;
import java.util.UUID;

public record BookingInput (LocalDate date, boolean ismorning, boolean isafternoon, UUID userid, UUID deskid) {
}