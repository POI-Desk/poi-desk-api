package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="monthlybookings")
public class MonthlyBooking {
    @Id
    @Column(name = "pk_monthlybookingid", nullable = false)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_monthlyBookingId;

    @Column(name = "month")
    private String month;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_location", nullable = false)
    private Location fk_Location;

    @Column(name = "totalbookings")
    private Integer totalBooking;

    @Column(name = "amountofdesks")
    private Integer amountOfDesks;

    @Column(name = "highestbookings")
    private Integer highestBookings;

    @Column(name = "averagebookings")
    private Integer averageBookings;

    @Column(name = "lowestbookings")
    private Integer lowestBookings;


    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_quarterlybookingid", nullable = false)
    private QuarterlyBooking fk_quarterlyBookingId;

    @OneToMany(mappedBy = "fk_monthlyBookingId", fetch = FetchType.LAZY)
    private List<DailyBooking> dailyBookings;
}
