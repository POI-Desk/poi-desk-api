package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.util.UUID;

public record UpdateWallInput(UUID pk_wallId, int x, int y, int rotation, int width, String localId) {
}
