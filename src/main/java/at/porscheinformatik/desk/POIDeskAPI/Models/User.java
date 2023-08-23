package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Date;
import java.sql.Timestamp;
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

    @Column(name="createdon")
    private Timestamp createdon;

    @Column(name="updatedon")
    private Timestamp updatedon;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "roles_users",
            joinColumns = @JoinColumn(name = "pk_fk_userid"),
            inverseJoinColumns = @JoinColumn(name = "pk_fk_roleid")
    )
    private List<Role> roles;

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private List<Booking> bookings;

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private List<BookingLog> bookinglogs;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_locationid")
    private Location location;
}
