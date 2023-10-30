package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.sql.Date;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="users")
public class User {

    @Id
    @Column(name="pk_userid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_userid;

    @Column(name="username")
    private String username;

    @Column(name="createdon")
    @CreationTimestamp
    private LocalDateTime createdon;

    @Column(name="updatedon")
    @UpdateTimestamp
    private LocalDateTime updatedon;

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

    @OneToMany(mappedBy = "user", fetch = FetchType.LAZY)
    private List<UserAnalytic> userAnalytics;
}
