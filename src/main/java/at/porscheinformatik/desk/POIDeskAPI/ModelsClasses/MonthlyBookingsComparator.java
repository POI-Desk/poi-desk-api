package at.porscheinformatik.desk.POIDeskAPI.ModelsClasses;

import at.porscheinformatik.desk.POIDeskAPI.Models.MonthlyBooking;

import java.util.Comparator;

public class MonthlyBookingsComparator implements Comparator<MonthlyBooking> {
    @Override
    public int compare(MonthlyBooking booking1, MonthlyBooking booking2){
        return booking1.getMonth().compareTo(booking2.getMonth());
    }
}
