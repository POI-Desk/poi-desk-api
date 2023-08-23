package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Date;
import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="roles")
public class Role {

    @Id
    @Column(name="pk_roleid", nullable = false, unique = true)
    private UUID pk_roleid;

    @Column(name="rolename")
    private String rolename;

    @Column(name="createdon")
    private Timestamp createdon;

    @Column(name="updatedon")
    private Timestamp updatedon;

    @ManyToMany(mappedBy = "roles", fetch = FetchType.LAZY)
    private List<User> users;

}
