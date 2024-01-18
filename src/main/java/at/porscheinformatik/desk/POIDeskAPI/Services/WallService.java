package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MapRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.WallRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.UpdateWallInput;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Models.Wall;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CompletableFuture;

@Service
public class WallService {
    @Autowired
    private WallRepo wallRepo;
    @Autowired
    MapRepo mapRepo;


    /**
     * Updates given walls on map.
     *
     * @param mapId The mapId the walls belong to.
     * @param wallInputs The new/updated wall inputs.
     * @return The new/updated walls.
     *
     * @throws IllegalArgumentException if map with given map ID does not exist
     * @throws Exception if any given wall ID does not exist
     */
    @Async
    public CompletableFuture<List<Wall>> updateWalls(UUID mapId, List<UpdateWallInput> wallInputs) throws Exception {

        Optional<Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            throw new IllegalArgumentException("No map found with given id");
        Map map = o_map.get();
        return updateWalls(map, wallInputs);
    }

    /**
     * Deletes the walls with given IDs.
     *
     * @return List of deleted walls.
     */
     @Async
     public CompletableFuture<List<Wall>> deleteWalls(List<UUID> wallIds){
         Iterable<Wall> i_walls = wallRepo.findAllById(wallIds);
         List<Wall> delWalls = new ArrayList<>();
         for (Wall wall :
                 i_walls) {
             delWalls.add(wall);
         }

         wallRepo.deleteAll(delWalls);
         return CompletableFuture.completedFuture(delWalls);
     }

    /**
     * <b>No side effects</b>
     * <br />
     * Calculates List of Walls with given input
     * @param map The map the walls belong to.
     * @param wallInputs The new/updated wall inputs.
     * @return The new/updated walls.
     *
     * @throws Exception if any given wall ID does not exist
     */
    @Async
    public CompletableFuture<List<Wall>> updateWalls(Map map, List<UpdateWallInput> wallInputs) throws Exception {
        List<Wall> walls = wallRepo.findAllByMap(map);
        List<Wall> finalWalls = new ArrayList<>();
        for (UpdateWallInput wallInput : wallInputs) {
            if (wallInput.pk_wallId() == null) {
                finalWalls.add(new Wall(wallInput.x(), wallInput.y(), wallInput.rotation(), wallInput.width(), map));
                continue;
            }
            Optional<Wall> o_wall = walls.stream().filter(wall -> Objects.equals(wall.getPk_wallId().toString(), wallInput.pk_wallId().toString())).findFirst();
            if (o_wall.isEmpty()) {
                throw new Exception("any given wall ID does not exist");
            }
            Wall c_wall = o_wall.get();
            c_wall.updateProps(wallInput.x(), wallInput.y(), wallInput.rotation(), wallInput.width());
            finalWalls.add(c_wall);
        }

        wallRepo.saveAll(finalWalls);
        return CompletableFuture.completedFuture(finalWalls);
    }

    @Async
    public CompletableFuture<List<Wall>> deleteWalls(Map map) {
        List<UUID> wallIds = wallRepo.findAllByMap(map).stream().map(Wall::getPk_wallId).toList();
        return deleteWalls(wallIds);
    }
}
