package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import at.porscheinformatik.desk.POIDeskAPI.Models.Types.InteriorType;

public record InteriorInput(InteriorType type, int x, int y, int rotation, int width, int height) {
}
