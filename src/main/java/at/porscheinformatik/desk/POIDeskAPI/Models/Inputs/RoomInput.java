package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.util.UUID;

public record RoomInput(int x, int y, int width, int height, UUID mapId) {
}
