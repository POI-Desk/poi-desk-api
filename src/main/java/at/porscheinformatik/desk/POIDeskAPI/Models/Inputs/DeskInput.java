package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.util.Optional;
import java.util.UUID;

public record DeskInput(String desknum, int x, int y, Optional<UUID> userId) {
}
