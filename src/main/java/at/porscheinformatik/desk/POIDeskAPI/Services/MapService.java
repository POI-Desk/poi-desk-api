package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DeskRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.FloorRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MapRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.*;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.*;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import org.apache.qpid.proton.reactor.Task;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.graphql.data.method.annotation.Argument;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import javax.management.relation.InvalidRelationIdException;
import java.lang.reflect.Array;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.stream.StreamSupport;

@Service
public class MapService {
    @Autowired
    private MapRepo mapRepo;
    @Autowired
    private FloorRepo floorRepo;
    @Autowired
    private DeskService deskService;
    @Autowired
    private RoomService roomService;
    @Autowired
    private WallService wallService;
    @Autowired
    private DoorService doorService;


    public Map createMap (UUID floorId, MapInput mapInput) throws Exception {
        Optional<Floor> o_floor = floorRepo.findById(floorId);
        if (o_floor.isEmpty())
            throw new IllegalArgumentException("floor id does not exist");
        if (mapRepo.existsByFloor(o_floor.get()))
            throw new Exception("Floor already has a map");

        Map map = new Map(mapInput.width(), mapInput.height(), o_floor.get());
        mapRepo.save(map);
        return map;
    }

    //ASYNC OR LAZY fetching!!!!
    //List<UpdateInteriorInput> interiorInputs
    public Map updateMapObjects(UUID mapId, List<UpdateDeskInput> deskInputs, List<UpdateRoomInput> roomInputs, List<UpdateWallInput> wallInputs, List<UpdateDoorInput> doorInputs) throws Exception {
        Optional<at.porscheinformatik.desk.POIDeskAPI.Models.Map> o_map = mapRepo.findById(mapId);
        if (o_map.isEmpty())
            throw new Exception("No map found with given id");
        Map map = o_map.get();

        CompletableFuture<List<Desk>> deskFuture = deskService.updateDesks(map, deskInputs);
        CompletableFuture<List<Room>> roomFuture = roomService.updateRooms(map, roomInputs);
        CompletableFuture<List<Wall>> wallFuture = wallService.updateWalls(map, wallInputs);
        CompletableFuture<List<Door>> doorFuture = doorService.updateDoors(map, doorInputs);

        CompletableFuture.allOf(deskFuture, roomFuture, wallFuture, doorFuture).join();
        return map;
    }
}