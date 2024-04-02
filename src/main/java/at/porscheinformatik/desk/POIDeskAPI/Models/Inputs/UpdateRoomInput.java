package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.util.UUID;

public record UpdateRoomInput(UUID pk_roomId, int x, int y, int width, int height, String localId) {
}
