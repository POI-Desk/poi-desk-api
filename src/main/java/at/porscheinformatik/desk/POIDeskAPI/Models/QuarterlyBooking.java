package at.porscheinformatik.desk.POIDeskAPI.Models;

import at.porscheinformatik.desk.POIDeskAPI.Models.Types.TimeType;
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
@Table(name="quarterlybookings")
public class QuarterlyBooking {
    @Id
    @Column(name = "pk_quarterlybookingid")
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID pk_quarterlyBookingId;


    @Column(name = "year", nullable = false)
    private String year;

    @Column(name = "quarter", nullable = false)
    private String quarter;

    @Column(name = "totalbookings", nullable = false)
    private Integer totalBookings;

    @Column(name = "days", nullable = false)
    private Integer days;

    @Column(name = "amountofdesks", nullable = false)
    private Integer amountOfDesks;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "morning_highestbooking")
    private DailyBooking morning_highestBooking;

    @Column(name = "morning_averagebooking", nullable = false)
    private Double morningAverageBooking;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "morning_lowestbooking")
    private DailyBooking morning_lowestBooking;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "afternoon_highestbooking")
    private DailyBooking afternoon_highestBooking;

    @Column(name = "afternoon_averagebooking", nullable = false)
    private Double afternoonAverageBooking;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "afternoon_lowestbooking")
    private DailyBooking afternoon_lowestBooking;

    @Column(name = "createdon", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdOn;

    @Column(name = "updatedon", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedOn;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_location", nullable = false)
    private Location fk_Location;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_building")
    private Building fk_building;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_floor")
    private Floor fk_floor;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_yearlybookingid", nullable = false)
    private YearlyBooking fk_yearlyBookingId;

    @OneToMany(mappedBy = "fk_quarterlyBookingId", fetch = FetchType.LAZY)
    private List<MonthlyBooking> monthlyBookings;
}
