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
@Table(name = "accounts")
public class Account {

    public Account() {

    }

    public Account(String uniqueIdentifier ,String provider, String access_token, String refresh_token){
        this.pk_accountid = uniqueIdentifier;
        this.provider = provider;
        this.access_token = access_token;
        this.refresh_token = refresh_token;
    }

    @Id
    @Column(name = "pk_accountid", nullable = false, unique = true)
    private String pk_accountid;

    @Column(name = "provider", nullable = false)
    private String provider;

    @Column(name = "access_token", nullable = false)
    private String access_token;

    @Column(name = "refresh_token", nullable = false)
    private String refresh_token;

    @Column(name="createdon", nullable = false)
    @CreationTimestamp
    private LocalDateTime createdon;

    @Column(name="updatedon", nullable = false)
    @UpdateTimestamp
    private LocalDateTime updatedon;

    @OneToMany(mappedBy = "account", fetch = FetchType.LAZY)
    private List<User> users;
}