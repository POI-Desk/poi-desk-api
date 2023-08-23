package at.porscheinformatik.desk.POIDeskAPI.ModelRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Role;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface RoleRepo extends CrudRepository<Role, UUID> {
}
