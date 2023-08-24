package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.sql.Date;
import java.time.LocalDateTime;
import java.sql.Timestamp;
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

    @Column(name="createdon")
    @CreationTimestamp
    private LocalDateTime createdon;

    @Column(name="updatedon")
    @UpdateTimestamp
    private LocalDateTime updatedon;

    @Column(name="attributename")
    private String attributename;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
            name = "seats_attributes",
            joinColumns = @JoinColumn(name = "pk_fk_attributeid"),
            inverseJoinColumns = @JoinColumn(name = "pk_fk_seatid")
    )
    private List<Seat> seats;
}
