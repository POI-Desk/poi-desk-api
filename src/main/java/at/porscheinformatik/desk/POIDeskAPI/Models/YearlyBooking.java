package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="yearlybookings")
public class YearlyBooking {
    @Id
    @Column(name = "pk_yearlybookingid", nullable = false)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_yearlyBookingId;

    @Column(name = "year")
    private String year;

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

    @OneToMany(mappedBy = "fk_yearlyBookingId", fetch = FetchType.LAZY)
    private List<QuarterlyBooking> quarterlyBookings;
}
