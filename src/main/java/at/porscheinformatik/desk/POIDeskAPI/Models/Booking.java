package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
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

import java.util.UUID;

@Getter
@Setter
@Entity
@ToString
@Table(name="bookings")
public class Booking {

    @Id
    @Column(name="pk_bookingid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_bookingid;

    @Column(name="bookingnumber")
    private String bookingnumber;

    @Column(name = "date")
    private LocalDate date;

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
  
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_userid")
    private User user;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_deskid")
    private Desk desk;
}
