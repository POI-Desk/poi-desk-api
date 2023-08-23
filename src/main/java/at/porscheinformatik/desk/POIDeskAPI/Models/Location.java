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
@Table(name="locations")
public class Location {
    @Id
    @Column(name="pk_locationid", nullable = false, unique = true)
    private UUID pk_locationid;

    @Column(name="locationname")
    private String locationname;

    @Column(name="createdon")
    private Date createdon;

    @Column(name="updatedon")
    private Date updatedon;

    @OneToMany(mappedBy = "location", fetch = FetchType.LAZY)
    private List<User> users;

    @OneToMany(mappedBy = "location", fetch = FetchType.LAZY)
    private List<Building> buildings;
}
