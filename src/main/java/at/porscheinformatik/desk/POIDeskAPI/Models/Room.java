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
@Table(name="rooms")
public class Room {

    public Room(){}

    public Room(int x, int y, int width, int height, Map map, String localId){
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.map = map;
        this.localId = localId;
    }

    @Id
    @Column(name="pk_roomid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_roomId;

    @Column(name="x", nullable = false)
    private int x;

    @Column(name="y", nullable = false)
    private int y;

    @Column(name="width", nullable = false)
    private int width;

    @Column(name="height", nullable = false)
    private int height;

    @Column(name = "localid", nullable = false)
    private String localId;

    @Column(name="createdon", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdOn;

    @Column(name="updatedon", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedOn;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_mapid")
    private Map map;

    public void updateProps(int x, int y, int width, int height, String localId){
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.localId = localId;
    }

}
