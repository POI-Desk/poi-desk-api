package at.porscheinformatik.desk.POIDeskAPI.Models;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.DeskRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.UserRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.Inputs.BookingInput;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

import java.time.LocalDate;
import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.beans.factory.annotation.Autowired;

import java.util.UUID;

@Getter
@Setter
@Entity
@ToString
@Table(name="bookings")
@NoArgsConstructor
public class Booking implements Comparable<Booking>{
    public Booking(BookingInput booking) {
        this.setDate(booking.date());
        this.setIsmorning(booking.ismorning());
        this.setIsafternoon(booking.isafternoon());
        this.setUser(new User());
        this.setDesk(new Desk());
    }

    @Id
    @Column(name="pk_bookingid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_bookingid;

    @Column(name="bookingnumber", nullable = false)
    private String bookingnumber;

    @Column(name = "date", nullable = false)
    private LocalDate date;

    @Column(name="createdon", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdon;

    @Column(name="updatedon", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedon;

    @Column(name="ismorning", nullable = false)
    private boolean ismorning;

    @Column(name="isafternoon", nullable = false)
    private boolean isafternoon;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_userid")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_deskid")
    private Desk desk;

    @Override
    public int compareTo(Booking o) {
        return this.getDate().compareTo(o.getDate());
    }
}
