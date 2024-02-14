package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.util.Optional;
import java.util.UUID;

public record UpdateDeskInput(UUID pk_deskid, String desknum, int x, int y, Optional<UUID> userId) {
}
