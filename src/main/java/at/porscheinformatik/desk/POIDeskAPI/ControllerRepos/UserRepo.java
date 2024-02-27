package at.porscheinformatik.desk.POIDeskAPI.ControllerRepos;

import at.porscheinformatik.desk.POIDeskAPI.Models.Desk;
import at.porscheinformatik.desk.POIDeskAPI.Models.Map;
import at.porscheinformatik.desk.POIDeskAPI.Models.User;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.PagingAndSortingRepository;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.UUID;

public interface UserRepo extends CrudRepository<User, UUID>, PagingAndSortingRepository <User, UUID>{
    List<User> findByUsername(String name);

    User findByUsernameContaining(String Name);

    Page<User> findAll(Pageable pageable);

    // Page<User> findByUsernameStartsWith(String input, Pageable pageable);

    Page<User> findByUsernameStartsWithIgnoreCase(String prefix, Pageable pageable);

    List<User> getUsersByDesksMap(Map map);

    // 🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮🤮
    @Query("SELECT u FROM User u WHERE NOT EXISTS (SELECT d FROM Desk d WHERE d.user = u AND d IN :desks)")
    List<User> getUsersWithoutDeskInDesks(@Param("desks") List<Desk> desks);

    @Query("SELECT u FROM User u WHERE EXISTS (SELECT d FROM Desk d WHERE d.map.published = true AND d.user = u AND d.map != :map AND d.user IN :users)")
    List<User> getUsersOnPublishedMapInUsersExcludeMap(@Param("users") List<User> users, @Param("map") Map map);
}
