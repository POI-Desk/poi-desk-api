package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;


import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="desks")
public class Desk {

    public Desk(){}

    public Desk(String desknum, float x, float y, Floor floor){
        this.desknum = desknum;
        this.x = x;
        this.y = y;
        this.floor = floor;
    }

    @Id
    @Column(name = "pk_deskid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_deskid;

    @Column(name = "desknum")
    private String desknum;

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

    @OneToMany(mappedBy = "desk", fetch = FetchType.LAZY)
    private List<Booking> bookings;

    @ManyToMany(mappedBy = "desks", fetch = FetchType.LAZY)
    private List<Attribute> attributes;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_floorid")
    private Floor floor;
}