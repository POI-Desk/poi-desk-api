package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="users")
public class User {

    @Id
    @Column(name="pk_userid", nullable = false, unique = true)
    private UUID pk_userid;

    @Column(name="username")
    private String username;

}
