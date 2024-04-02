package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.util.UUID;

public record UpdateLabelInput (UUID pk_labelId, String text, int x, int y, int width, int height, int rotation, String localId){
}
