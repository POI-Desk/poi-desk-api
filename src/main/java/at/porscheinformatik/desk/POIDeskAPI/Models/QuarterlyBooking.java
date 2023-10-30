package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="quarterlybookings")
public class QuarterlyBooking {
    @Id
    @Column(name = "pk_quarterlybookingid", nullable = false)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_quarterlyBookingId;

    @Column(name = "year")
    private String year;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_location", nullable = false)
    private Location fk_Location;

    @Column(name = "quarter")
    private String quarter;

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
    @JoinColumn(name = "fk_yearlybookingid", nullable = false)
    private YearlyBooking fk_yearlyBookingId;

    @OneToMany(mappedBy = "fk_quarterlyBookingId", fetch = FetchType.LAZY)
    private List<MonthlyBooking> monthlyBookings;
}
