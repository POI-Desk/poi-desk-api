package at.porscheinformatik.desk.POIDeskAPI.ModelsClasses;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class YearlyBookingPrediction {
    private String year;
    private Integer totalBookings;
    private Double morning_highestBooking;
    private Double morningAverageBooking;
    private Double morning_lowestBooking;
    private Double afternoon_highestBooking;
    private Double afternoonAverageBooking;
    private Double afternoon_lowestBooking;
}
