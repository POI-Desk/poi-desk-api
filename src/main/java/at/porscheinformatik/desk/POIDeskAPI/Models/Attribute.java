package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Date;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="attributes")
public class Attribute {
    @Id
    @Column(name="pk_attributeid", nullable = false, unique = true)
    private UUID pk_attributeid;

    @Column(name="createdon")
    private Date createdon;

    @Column(name="updatedon")
    private Date updatedon;

    @Column(name="attributename")
    private String attributename;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "seat_attribute",
            joinColumns = @JoinColumn(name = "pk_fk_attributeid"),
            inverseJoinColumns = @JoinColumn(name = "pk_fk_seatid")
    )
    private List<Seat> seats;
}
