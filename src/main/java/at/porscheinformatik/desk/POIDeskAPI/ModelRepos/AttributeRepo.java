package at.porscheinformatik.desk.POIDeskAPI.ModelRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Attribute;
import org.springframework.data.repository.CrudRepository;

import java.util.UUID;

public interface AttributeRepo extends CrudRepository<Attribute, UUID> {

}
