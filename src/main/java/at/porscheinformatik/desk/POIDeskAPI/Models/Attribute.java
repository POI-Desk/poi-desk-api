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
@Table(name="attributes")
public class Attribute {
    @Id
    @Column(name="pk_attributeid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_attributeid;

    @Column(name="createdon", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdon;

    @Column(name="updatedon", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedon;

    @Column(name="attributename", nullable = false)
    private String attributename;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "desks_attributes",
            joinColumns = @JoinColumn(name = "pk_fk_attributeid"),
            inverseJoinColumns = @JoinColumn(name = "pk_fk_deskid")
    )
    private List<Desk> desks;
}
