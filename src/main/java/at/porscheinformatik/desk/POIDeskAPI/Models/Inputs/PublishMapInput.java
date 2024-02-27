package at.porscheinformatik.desk.POIDeskAPI.Models.Inputs;

import java.util.Optional;
import java.util.UUID;

public record PublishMapInput(Optional<UUID> mapId, boolean keepOldMap, boolean keepBookings) {
}
