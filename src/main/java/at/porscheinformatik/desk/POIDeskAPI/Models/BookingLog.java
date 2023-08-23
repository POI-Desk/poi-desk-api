package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Date;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="bookingslog")
public class BookingLog {

    @Id
    @Column(name="pk_bookinglogid", nullable = false, unique = true)
    private UUID pk_bookinglogid;

    @Column(name="bookingnumber")
    private String bookingnumber;

    @Column(name = "date")
    private Date date;

    @Column(name="createdon")
    private Date createdon;

    @Column(name="updatedon")
    private Date updatedon;

    @Column(name="ismorning")
    private boolean ismorning;

    @Column(name="isafternoon")
    private boolean isafternoon;

    @Column(name="wasdeleted")
    private boolean wasdeleted;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_userid")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_seatid")
    private Seat seat;


}
