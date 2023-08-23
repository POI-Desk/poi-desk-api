package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="users")
public class User {

    @Id
    @Column(name="pk_userid", nullable = false, unique = true)
    private UUID pk_userid;

    @Column(name="username")
    private String username;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "role_user",
            joinColumns = @JoinColumn(name = "pk_fk_userid"),
            inverseJoinColumns = @JoinColumn(name = "pk_fk_roleid")
    )
    private List<Role> roles;

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private List<Booking> bookings;
}
