package at.porscheinformatik.desk.POIDeskAPI.ModelsClasses;

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

    public QuarterlyBookingPrediction() {
        year = "";
        quarter = 0;
        total = 0;
        morning_highestBooking = 0.00;
        morningAverageBooking= 0.00;
        morning_lowestBooking= 0.00;
        afternoon_highestBooking= 0.00;
        afternoonAverageBooking= 0.00;
        afternoon_lowestBooking= 0.00;

    }
    public QuarterlyBookingPrediction(QuarterlyBookingPrediction booking) {
        year = booking.getYear();
        quarter = booking.getQuarter();
        total = booking.getTotal();
        morning_highestBooking = booking.getMorning_highestBooking();
        morningAverageBooking = booking.getMorningAverageBooking();
        morning_lowestBooking = booking.getMorning_lowestBooking();
        afternoon_highestBooking = booking.getAfternoon_highestBooking();
        afternoonAverageBooking = booking.getAfternoonAverageBooking();
        afternoon_lowestBooking = booking.getAfternoon_lowestBooking();

    }
}
