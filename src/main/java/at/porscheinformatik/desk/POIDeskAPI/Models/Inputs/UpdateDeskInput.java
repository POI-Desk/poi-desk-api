package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.util.UUID;

public record UpdateDeskInput(UUID id, String desknum, int x, int y) {
}
