package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.util.UUID;

public record UpdateRoomInput(UUID id, int x, int y, int width, int height, UUID mapId) {
}
