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
@Table(name="maps")
public class Map {

    @Id
    @Column(name="pk_mapid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_mapId;

    @Column(name="width", nullable = false)
    private int width;

    @Column(name="height", nullable = false)
    private int height;

    @Column(name="createdon", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdOn;

    @Column(name="updatedon", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedOn;

    @OneToMany(mappedBy = "map", fetch = FetchType.LAZY)
    private List<Room> rooms;

    @OneToMany(mappedBy = "map", fetch = FetchType.LAZY)
    private List<Desk> desks;

    @OneToMany(mappedBy = "map", fetch = FetchType.LAZY)
    private List<Label> labels;

    @OneToMany(mappedBy = "map", fetch = FetchType.LAZY)
    private List<Interior> interiors;
}