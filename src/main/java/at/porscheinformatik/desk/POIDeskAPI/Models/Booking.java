package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import liquibase.license.LicenseService;
import lombok.Getter;
import lombok.Setter;
import java.util.List;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.sql.Date;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="bookings")
public class Booking {

    @Id
    @Column(name="pk_bookingid", nullable = false, unique = true)
    private UUID pk_bookingid;

    @Column(name="bookingnumber")
    private int bookingnumber;

    @Column(name = "date")
    private Date date;
  
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_userid")
    private User user;
}
