package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.GenericGenerator;
import org.hibernate.annotations.UpdateTimestamp;

import java.sql.Date;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="bookingslog")
public class BookingLog {

    public BookingLog(){}

    public BookingLog(String bookingnumber, LocalDateTime date, boolean isafternoon, boolean ismorning, User user, Seat seat){
        this.bookingnumber = bookingnumber;
        this.date = date;
        this.isafternoon = isafternoon;
        this.ismorning = ismorning;
        this.user = user;
        this.seat = seat;
    }

    @Id
    @Column(name="pk_bookinglogid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_bookinglogid;

    @Column(name="bookingnumber")
    private String bookingnumber;

    @Column(name = "date")
    private LocalDateTime date;

    @Column(name="createdon")
    @CreationTimestamp
    private LocalDateTime createdon;

    @Column(name="updatedon")
    @UpdateTimestamp
    private LocalDateTime updatedon;

    @Column(name="ismorning")
    private boolean ismorning;

    @Column(name="isafternoon")
    private boolean isafternoon;

//    @Column(name="wasdeleted")
//    private boolean wasdeleted;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_userid")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_seatid")
    private Seat seat;

    public static BookingLog toBookingLog(Booking booking){
        return new BookingLog(booking.getBookingnumber(), booking.getDate(), booking.isIsafternoon(), booking.isIsmorning(), booking.getUser(), booking.getSeat());
    }

}
