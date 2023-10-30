package at.porscheinformatik.desk.POIDeskAPI.Models;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import net.minidev.json.JSONObject;
import org.hibernate.annotations.UpdateTimestamp;

import java.sql.Date;
import java.time.LocalDateTime;
import java.time.Year;
import java.util.List;
import java.util.Map;
import java.util.UUID;

@Getter
@Setter
@Entity
@Table(name="UserAnalytics")
public class UserAnalytic {
    @Id
    @Column(name="pk_useranalyticid", nullable = false, unique = true)
    @GeneratedValue(strategy = GenerationType.UUID)
    private UUID pk_useranalyticid;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name="user")
    private User user;

    @Column(name="year")
    private Year year;

    @Lob
    @Column(name="result")
    private JSONObject result;

    @Column(name="createdOn")
    @UpdateTimestamp
    private LocalDateTime createdOn;
}
