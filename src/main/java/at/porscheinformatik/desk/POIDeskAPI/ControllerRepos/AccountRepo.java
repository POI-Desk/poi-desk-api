package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Account;
import at.porscheinformatik.desk.POIDeskAPI.Models.Attribute;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface AccountRepo extends CrudRepository<Account, String> {

}
