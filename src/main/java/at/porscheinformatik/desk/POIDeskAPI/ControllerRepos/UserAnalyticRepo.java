package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.UserAnalytic;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface UserAnalyticRepo extends CrudRepository<UserAnalytic, UUID> {
}
