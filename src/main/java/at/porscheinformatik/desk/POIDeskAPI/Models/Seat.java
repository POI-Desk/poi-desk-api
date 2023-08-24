package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;
import org.springframework.graphql.data.method.annotation.SchemaMapping;


import java.sql.Date;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="seats")
public class Seat {


    @Id
    @Column(name = "pk_seatid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_seatid;

    @Column(name = "seatnum")
    private String seatnum;

    @Column(name = "x")
    private float x;

    @Column(name = "y")
    private float y;

    @Column(name = "createdon")
    @CreationTimestamp
    private LocalDateTime createdon;

    @Column(name = "updatedon")
    @UpdateTimestamp
    private LocalDateTime updatedon;

    @OneToMany(mappedBy = "seat", fetch = FetchType.LAZY)
    private List<Booking> bookings;

    @OneToMany(mappedBy = "seat", fetch = FetchType.LAZY)
    private List<BookingLog> bookinglogs;

    @ManyToMany(mappedBy = "seats", fetch = FetchType.LAZY)
    private List<Attribute> attributes;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_floorid")
    private Floor floor;
}