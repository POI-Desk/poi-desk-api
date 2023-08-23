package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Date;
import java.sql.Timestamp;
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
    private Timestamp createdon;

    @Column(name="updatedon")
    private Timestamp updatedon;

    @Column(name="attributename")
    private String attributename;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "seats_attributes",
            joinColumns = @JoinColumn(name = "pk_fk_attributeid"),
            inverseJoinColumns = @JoinColumn(name = "pk_fk_seatid")
    )
    private List<Seat> seats;
}
