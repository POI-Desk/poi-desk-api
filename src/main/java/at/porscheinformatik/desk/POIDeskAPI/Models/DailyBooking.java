package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name="dailybookings")
public class DailyBooking {
    @Id
    @Column(name = "pk_day", nullable = false)
    @GeneratedValue(strategy = GenerationType.UUID)
    private String pk_day;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "pk_fk_location", nullable = false)
    private Location pk_fk_Location;

    @Column(name = "totalbookings")
    private Integer totalBooking;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_monthlybookingid", nullable = false)
    private MonthlyBooking fk_monthlyBookingId;

}
