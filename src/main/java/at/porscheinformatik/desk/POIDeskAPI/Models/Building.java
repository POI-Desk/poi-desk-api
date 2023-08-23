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
@Table(name="buildings")
public class Building {
    @Id
    @Column(name="pk_buildingid", nullable = false, unique = true)
    private UUID pk_buildingid;

    @Column(name="buildingname")
    private String buildingname;

    @Column(name="createdon")
    private Timestamp createdon;

    @Column(name="updatedon")
    private Timestamp updatedon;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_locationid")
    private Location location;

    @OneToMany(mappedBy = "building", fetch = FetchType.LAZY)
    private List<Floor> floors;

}
