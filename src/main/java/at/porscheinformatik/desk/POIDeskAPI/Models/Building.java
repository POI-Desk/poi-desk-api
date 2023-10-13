package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.sql.Date;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="buildings")
public class Building {
    @Id
    @Column(name="pk_buildingid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_buildingid;

    @Column(name="buildingname")
    private String buildingname;

    @Column(name="createdon")
    @CreationTimestamp
    private LocalDateTime createdon;

    @Column(name="updatedon")
    @UpdateTimestamp
    private LocalDateTime updatedon;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_locationid")
    private Location location;

    @OneToMany(mappedBy = "building", fetch = FetchType.LAZY)
    private List<Floor> floors;

}
