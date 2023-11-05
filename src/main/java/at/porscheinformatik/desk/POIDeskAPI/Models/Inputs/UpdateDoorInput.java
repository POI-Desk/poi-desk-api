package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.util.UUID;

public record UpdateDoorInput(UUID pk_doorId, int x, int y, int rotation, int width) {
}
