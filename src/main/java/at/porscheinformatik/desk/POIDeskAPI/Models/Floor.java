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
@Table(name="floors")
public class Floor {
    @Id
    @Column(name="pk_floorid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_floorid;

    @Column(name="floorname", nullable = false)
    private String floorname;

    @Column(name="createdon", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdon;

    @Column(name="updatedon", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedon;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_buildingid")
    private Building building;

    @OneToMany(mappedBy = "floor", fetch = FetchType.LAZY)
    private List<Desk> desks;

    @OneToMany(mappedBy = "fk_floor", fetch = FetchType.LAZY)
    private List<DailyBooking> dailyBookings;

    @OneToMany(mappedBy = "fk_floor", fetch = FetchType.LAZY)
    private List<MonthlyBooking> monthlyBookings;

    @OneToMany(mappedBy = "fk_floor", fetch = FetchType.LAZY)
    private List<QuarterlyBooking> quarterlyBookings;

    @OneToMany(mappedBy = "fk_floor", fetch = FetchType.LAZY)
    private List<YearlyBooking> yearlyBookings;
}
