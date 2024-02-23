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
@Table(name="dailybookings")
public class DailyBooking {
    @Id
    @Column(name = "pk_dailybookingid")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID pk_dailyBookingId;

    @Column(name = "day", nullable = false)
    private String day;

    @Column(name = "morning", nullable = false)
    private Integer morning;

    @Column(name = "afternoon", nullable = false)
    private Integer afternoon;

    @Column(name = "total", nullable = false)
    private Integer total;

    @Column(name = "createdon", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdOn;

    @Column(name = "updatedon", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedOn;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_location", nullable = false)
    private Location fk_location;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_building")
    private Building fk_building;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_floor")
    private Floor fk_floor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_monthlybookingid", nullable = false)
    private MonthlyBooking fk_monthlyBookingId;

    @OneToMany(mappedBy = "morning_highestBooking", fetch = FetchType.LAZY)
    private List<MonthlyBooking> month_morning_highestBooking;

    @OneToMany(mappedBy = "morning_highestBooking", fetch = FetchType.LAZY)
    private List<QuarterlyBooking> quarter_morning_highestBooking;

    @OneToMany(mappedBy = "morning_highestBooking", fetch = FetchType.LAZY)
    private List<YearlyBooking> year_morning_highestBooking;

    @OneToMany(mappedBy = "morning_lowestBooking", fetch = FetchType.LAZY)
    private List<MonthlyBooking> month_morning_lowestBooking;

    @OneToMany(mappedBy = "morning_lowestBooking", fetch = FetchType.LAZY)
    private List<QuarterlyBooking> quarter_morning_lowestBooking;

    @OneToMany(mappedBy = "morning_lowestBooking", fetch = FetchType.LAZY)
    private List<YearlyBooking> year_morning_lowestBooking;

    @OneToMany(mappedBy = "afternoon_highestBooking", fetch = FetchType.LAZY)
    private List<MonthlyBooking> month_afternoon_highestBooking;

    @OneToMany(mappedBy = "afternoon_highestBooking", fetch = FetchType.LAZY)
    private List<QuarterlyBooking> quarter_afternoon_highestBooking;

    @OneToMany(mappedBy = "afternoon_highestBooking", fetch = FetchType.LAZY)
    private List<YearlyBooking> year_afternoon_highestBooking;

    @OneToMany(mappedBy = "afternoon_lowestBooking", fetch = FetchType.LAZY)
    private List<MonthlyBooking> month_afternoon_lowestBooking;

    @OneToMany(mappedBy = "afternoon_lowestBooking", fetch = FetchType.LAZY)
    private List<QuarterlyBooking> quarter_afternoon_lowestBooking;

    @OneToMany(mappedBy = "afternoon_lowestBooking", fetch = FetchType.LAZY)
    private List<YearlyBooking> year_afternoon_lowestBooking;
}
