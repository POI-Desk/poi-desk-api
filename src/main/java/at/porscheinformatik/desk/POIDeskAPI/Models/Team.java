package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="teams")
public class Team {
    @Id
    @Column(name="pk_teamid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_teamid;

    @Column(name="teamname", nullable = false)
    private String teamname;

    @Column(name="createdon", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdon;

    @Column(name="updatedon", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedon;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "users_teams",
            joinColumns = @JoinColumn(name = "pk_fk_teamid"),
            inverseJoinColumns = @JoinColumn(name = "pk_fk_userid")
    )
    private List<User> teammembers;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_teamleaderid")
    private User teamleader;
}
