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
@Table(name="locations")
public class Location {

    @Id
    @Column(name="pk_locationid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_locationid;

    @Column(name="locationname", nullable = false)
    private String locationname;

    @Column(name="createdon", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdon;

    @Column(name="updatedon", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedon;

    @OneToMany(mappedBy = "location", fetch = FetchType.EAGER)
    private List<User> users;

    @OneToMany(mappedBy = "location", fetch = FetchType.EAGER)
    private List<Building> buildings;

    @OneToMany(mappedBy = "pk_fk_Location", fetch = FetchType.EAGER)
    private List<DailyBooking> dailyBookings;

    @OneToMany(mappedBy = "fk_Location", fetch = FetchType.EAGER)
    private List<MonthlyBooking> monthlyBookings;

    @OneToMany(mappedBy = "fk_Location", fetch = FetchType.EAGER)
    private List<QuarterlyBooking> quarterlyBookings;

    @OneToMany(mappedBy = "fk_Location", fetch = FetchType.EAGER)
    private List<YearlyBooking> yearlyBookings;
}
