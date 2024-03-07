package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Room;
import at.porscheinformatik.desk.POIDeskAPI.Models.Team;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import org.springframework.data.repository.CrudRepository;

import java.util.Collection;
import java.util.List;
import java.util.UUID;

public interface TeamRepo extends CrudRepository<Team, UUID> {
    public List<Team> findByTeamleaderIn(Collection<User> teamleader);
}
