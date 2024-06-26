package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Role;
import org.springframework.data.repository.CrudRepository;

import java.util.List;
import java.util.UUID;

public interface RoleRepo extends CrudRepository<Role, UUID> {
    List<Role> findByRolename(String rolename);
}
