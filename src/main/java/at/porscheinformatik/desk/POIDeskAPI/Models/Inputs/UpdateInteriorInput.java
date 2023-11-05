package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import at.porscheinformatik.desk.POIDeskAPI.Models.Types.InteriorType;

import java.util.UUID;

public record UpdateInteriorInput(UUID pk_interiorId, InteriorType type, int x, int y, int rotation, int width, int height) {
}
