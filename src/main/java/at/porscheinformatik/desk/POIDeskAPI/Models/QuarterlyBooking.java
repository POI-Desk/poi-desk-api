package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.Comparator;
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
    private Integer quarter;

    @Column(name = "total", nullable = false)
    private Integer total;

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
    private Location fk_location;

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

    public List<MonthlyBooking> getSortedMonthlyBookings() {
        if (monthlyBookings != null) {
            // Sort the list using a custom comparator
            monthlyBookings.sort(Comparator.comparing(MonthlyBooking::getMonth));
            monthlyBookings.forEach(MonthlyBooking::getSortedDailyBookings);
        }
        return monthlyBookings;
    }
}
