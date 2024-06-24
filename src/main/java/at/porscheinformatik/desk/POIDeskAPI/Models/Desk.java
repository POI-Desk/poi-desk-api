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
@Table(name="desks")
public class Desk {

    public Desk(){}

    public Desk(String desknum, int x, int y, Map map, String localId, User user){
        this.desknum = desknum;
        this.x = x;
        this.y = y;
        this.map = map;
        this.localId = localId;
        this.user = user;
    }

    @Id
    @Column(name = "pk_deskid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_deskid;

    @Column(name = "desknum", nullable = false)
    private String desknum;

    @Column(name = "x", nullable = false)
    private int x;

    @Column(name = "y", nullable = false)
    private int y;

    @Column(name = "rotation", nullable = false)
    private int rotation;

    @Column(name = "localid", nullable = false)
    private String localId;

    @Column(name = "createdon", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdon;

    @Column(name = "updatedon", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedon;

    @OneToMany(mappedBy = "desk", fetch = FetchType.LAZY)
    private List<Booking> bookings;

    @ManyToMany(mappedBy = "desks", fetch = FetchType.LAZY)
    private List<Attribute> attributes;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_mapid")
    private Map map;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "fk_userid")
    private User user;

    public void updateProps(String deskNum, int x, int y, String localId,  User user){
        this.desknum = deskNum;
        this.x = x;
        this.y = y;
        this.localId = localId;
        this.user = user;
    }
}