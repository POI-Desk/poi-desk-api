package at.porscheinformatik.desk.POIDeskAPI.ModelsClasses;

import lombok.Getter;
import lombok.Setter;
@Getter
@Setter
public class MonthlyBookingPrediction {
    private String month;
    private Integer total;
    private Double morning_highestBooking;
    private Double morningAverageBooking;
    private Double morning_lowestBooking;
    private Double afternoon_highestBooking;
    private Double afternoonAverageBooking;
    private Double afternoon_lowestBooking;
}
