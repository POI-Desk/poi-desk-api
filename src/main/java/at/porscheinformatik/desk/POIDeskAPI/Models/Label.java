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
@Table(name="labels")
public class Label {

    public Label(){}

    public Label(String text, int x, int y, int rotation, Map map) {
        this.text = text;
        this.x = x;
        this.y = y;
        this.rotation = rotation;
        this.map = map;
    }

    @Id
    @Column(name="pk_labelid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_labelId;

    @Column(name = "text", nullable = false)
    private String text;

    @Column(name="x", nullable = false)
    private int x;

    @Column(name="y", nullable = false)
    private int y;

    @Column(name = "rotation", nullable = false)
    private int rotation;

    @Column(name = "pt", nullable = false)
    private int pt;

    @Column(name="createdon", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdOn;

    @Column(name="updatedon", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedOn;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_mapid")
    private Map map;

    public void updateProps(String text, int x, int y, int rotation) {
        this.text = text;
        this.x = x;
        this.y = y;
        this.rotation = rotation;
    }
}
