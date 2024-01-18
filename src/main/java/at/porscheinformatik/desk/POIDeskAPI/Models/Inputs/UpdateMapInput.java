package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.util.UUID;

public record UpdateMapInput(UUID pk_mapId, int width, int height) {
}
