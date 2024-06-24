package at.porscheinformatik.desk.POIDeskAPI.Models;

import at.porscheinformatik.desk.POIDeskAPI.Models.Types.InteriorType;
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
@Table(name="interiors")
public class Interior {

    public Interior(){}

    public Interior(InteriorType type, int x, int y, int rotation, int width, int height, Map map)
    {
        this.type = type;
        this.x = x;
        this.y = y;
        this.rotation = rotation;
        this.width = width;
        this.height = height;
        this.map = map;
    }

    @Id
    @Column(name="pk_interiorid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_interiorId;

    @Enumerated(EnumType.STRING)
    @Column(name = "type", nullable = false)
    private InteriorType type;

    @Column(name="x", nullable = false)
    private int x;

    @Column(name="y", nullable = false)
    private int y;

    @Column(name = "rotation", nullable = false)
    private int rotation;

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

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_mapid")
    private Map map;
}
