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
@Table(name="floors")
public class Floor {
    @Id
    @Column(name="pk_floorid", nullable = false, unique = true)
    private UUID pk_floorid;

    @Column(name="floorname")
    private String floorname;

    @Column(name="createdon")
    private Timestamp createdon;

    @Column(name="updatedon")
    private Timestamp updatedon;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_buildingid")
    private Building building;

    @OneToMany(mappedBy = "floor", fetch = FetchType.LAZY)
    private List<Seat> seats;
}
