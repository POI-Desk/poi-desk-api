package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.util.UUID;

public record UpdateWallInput(UUID id, int x, int y, int rotation, int width) {
}
