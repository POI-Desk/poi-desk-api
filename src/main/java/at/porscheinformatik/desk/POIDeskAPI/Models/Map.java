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

    public Map (){}

    public Map (int width, int height, boolean published, Floor floor)
    {
        this.width = width;
        this.height = height;
        this.published = published;
        this.floor = floor;
    }

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

    @Column(name="published", nullable = false)
    private boolean published;

    @OneToMany(cascade = CascadeType.REMOVE, mappedBy = "map", fetch = FetchType.LAZY)
    private List<Room> rooms;

    @OneToMany(cascade = CascadeType.REMOVE, mappedBy = "map", fetch = FetchType.LAZY)
    private List<Desk> desks;

    @OneToMany(cascade = CascadeType.REMOVE, mappedBy = "map", fetch = FetchType.LAZY)
    private List<Label> labels;

    @OneToMany(cascade = CascadeType.REMOVE, mappedBy = "map", fetch = FetchType.LAZY)
    private List<Interior> interiors;

    @OneToMany(cascade = CascadeType.REMOVE, mappedBy = "map", fetch = FetchType.LAZY)
    private List<Door> doors;

    @OneToMany(cascade = CascadeType.REMOVE, mappedBy = "map", fetch = FetchType.LAZY)
    private List<Wall> walls;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_floorid")
    private Floor floor;

    public void updateProps(int width, int height, boolean published, Floor floor){
        this.width = width;
        this.height = height;
        this.published = published;
        this.floor = floor;
    }

}
