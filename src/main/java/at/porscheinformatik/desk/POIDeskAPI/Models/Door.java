package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="doors")
public class Door {

    public Door(){}

    public Door(int x, int y, int rotation, int width, Map map){
        this.x = x;
        this.y = y;
        this.rotation = rotation;
        this.width = width;
        this.map = map;
    }

    @Id
    @Column(name = "pk_doorid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_doorId;

    @Column(name = "x", nullable = false)
    private int x;

    @Column(name = "y", nullable = false)
    private int y;

    @Column(name = "rotation", nullable = false)
    private int rotation;

    @Column(name = "width", nullable = false)
    private int width;

    @Column(name = "createdon", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdOn;

    @Column(name = "updatedon", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedOn;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_mapid")
    private Map map;

    public void updateProps(int x, int y, int rotation, int width){
        this.x = x;
        this.y = y;
        this.rotation = rotation;
        this.width = width;
    }

}
