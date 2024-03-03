package at.porscheinformatik.desk.POIDeskAPI.ModelsClasses;

import jakarta.persistence.Column;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class QuarterlyBookingPrediction {
    private String year;
    private Integer quarter;
    private Integer total;
    private Double morning_highestBooking;
    private Double morningAverageBooking;
    private Double morning_lowestBooking;
    private Double afternoon_highestBooking;
    private Double afternoonAverageBooking;
    private Double afternoon_lowestBooking;
}
