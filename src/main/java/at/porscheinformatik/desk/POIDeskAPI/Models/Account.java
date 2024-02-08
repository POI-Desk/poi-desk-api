package at.porscheinformatik.desk.POIDeskAPI.Models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.util.List;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name = "accounts")
public class Account {

    public Account() {

    }
    @Id
    @Column(name = "pk_accountid", nullable = false)
    private UUID pk_accountid;

    @Column(name = "provider", nullable = false)
    private String provider;

    @OneToMany(mappedBy = "account", fetch = FetchType.LAZY)
    private List<User> users;
}