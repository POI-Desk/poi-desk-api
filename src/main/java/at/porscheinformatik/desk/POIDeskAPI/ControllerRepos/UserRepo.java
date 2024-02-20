package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;

import java.util.List;
import java.util.UUID;

public interface UserRepo extends CrudRepository<User, UUID>, PagingAndSortingRepository <User, UUID>{
    List<User> findByUsername(String name);

    Page<User> findAll(Pageable pageable);

    // Page<User> findByUsernameStartsWith(String input, Pageable pageable);

    Page<User> findByUsernameStartsWithIgnoreCase(String prefix, Pageable pageable);

    Page<User> getUsersByDesk(String desk);
}
