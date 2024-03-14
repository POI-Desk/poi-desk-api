package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.LocationRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Location;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Lazy;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.CompletableFuture;

@Service
public class LocationService {
    @Lazy
    @Autowired
    private LocationRepo locationRepo;

    @Async
    public CompletableFuture<Location> getLocationById(UUID locationId){
        Optional<Location> o_location = locationRepo.findById(locationId);
        return o_location.map(CompletableFuture::completedFuture).orElse(null);

    }

    @Async
    public CompletableFuture<Location> getLocationByName(String name){
        return CompletableFuture.completedFuture(locationRepo.findByLocationname(name));
    }
}
