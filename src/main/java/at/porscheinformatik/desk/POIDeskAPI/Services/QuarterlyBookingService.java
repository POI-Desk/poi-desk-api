package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MonthlyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.QuarterlyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.MonthlyBooking;
import at.porscheinformatik.desk.POIDeskAPI.Models.QuarterlyBooking;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.MonthlyBookingPrediction;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.QuarterlyBookingPrediction;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Types.IdentifierType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.CompletableFuture;

import static at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Prediction.calculateDiffernce;
import static at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Prediction.predictNextValue;

@Service
public class QuarterlyBookingService {
    @Autowired
    private QuarterlyBookingRepo quarterlyBookingRepo;

    @Async
    public CompletableFuture<QuarterlyBooking> getQuarterlyBooking(String year, Integer quarter, UUID IdentifierId, IdentifierType identifier){
        List<QuarterlyBooking> quarterlyBookings = (List<QuarterlyBooking>)quarterlyBookingRepo.findAll();

        List<QuarterlyBooking> quarterlyBookingByTime = quarterlyBookings.stream()
                .filter(booking -> Objects.equals(booking.getYear(), year) &&
                        Objects.equals(booking.getQuarter(), quarter))
                .toList();
        Optional<QuarterlyBooking> selectedMonthlyBooking;
        switch (identifier){
            case Location -> {
                selectedMonthlyBooking = quarterlyBookingByTime.stream()
                        .filter(booking -> booking.getFk_location() != null &&
                                Objects.equals(booking.getFk_location().getPk_locationid(), IdentifierId) &&
                                booking.getFk_building() == null &&
                                booking.getFk_floor() == null)
                        .findFirst();
            }
            case Building -> {
                selectedMonthlyBooking = quarterlyBookingByTime.stream()
                        .filter(booking -> booking.getFk_location() == null &&
                                booking.getFk_building() != null &&
                                Objects.equals(booking.getFk_building().getPk_buildingid(), IdentifierId) &&
                                booking.getFk_floor() == null)
                        .findFirst();
            }
            case Floor -> {
                selectedMonthlyBooking = quarterlyBookingByTime.stream()
                        .filter(booking -> booking.getFk_location() == null &&
                                booking.getFk_building() == null &&
                                booking.getFk_floor() != null &&
                                Objects.equals(booking.getFk_floor().getPk_floorid(), IdentifierId))
                        .findFirst();
            }
            default -> throw new IllegalArgumentException("False identifiere");
        }
        return CompletableFuture.completedFuture(selectedMonthlyBooking.orElse(null));
    };
    @Async
    public CompletableFuture<QuarterlyBookingPrediction[]> getQuarterlyBookingPrediction(UUID IdentifierId, IdentifierType identifier){
        List<QuarterlyBooking> quarterlyBookings = (List<QuarterlyBooking>)quarterlyBookingRepo.findAll();
        quarterlyBookings.sort(Comparator.comparing(QuarterlyBooking::getYear).thenComparing(QuarterlyBooking::getQuarter));
        List<QuarterlyBooking> selectedQuarterlyBookings;
        switch (identifier){
            case Location -> {
                selectedQuarterlyBookings = quarterlyBookings.stream()
                        .filter(booking -> booking.getFk_location() != null &&
                                Objects.equals(booking.getFk_location().getPk_locationid(), IdentifierId) &&
                                booking.getFk_building() == null &&
                                booking.getFk_floor() == null)
                        .toList();
            }
            case Building -> {
                selectedQuarterlyBookings = quarterlyBookings.stream()
                        .filter(booking -> booking.getFk_location() == null &&
                                booking.getFk_building() != null &&
                                Objects.equals(booking.getFk_building().getPk_buildingid(), IdentifierId) &&
                                booking.getFk_floor() == null)
                        .toList();
            }
            case Floor -> {
                selectedQuarterlyBookings = quarterlyBookings.stream()
                        .filter(booking -> booking.getFk_location() == null &&
                                booking.getFk_building() == null &&
                                booking.getFk_floor() != null &&
                                Objects.equals(booking.getFk_floor().getPk_floorid(), IdentifierId))
                        .toList();
            }
            default -> throw new IllegalArgumentException("False identifiere");
        }
        int bookingSize = selectedQuarterlyBookings.size();
        QuarterlyBookingPrediction[] convertedBookings = new QuarterlyBookingPrediction[bookingSize+1];
        for (int i = 0; i < selectedQuarterlyBookings.size(); i++) {
            QuarterlyBooking sourceBooking = selectedQuarterlyBookings.get(i);
            QuarterlyBookingPrediction convertedBooking = new QuarterlyBookingPrediction();
            convertedBooking.setYear(sourceBooking.getYear());
            convertedBooking.setQuarter(sourceBooking.getQuarter());
            convertedBooking.setTotalBookings(sourceBooking.getTotal());
            convertedBooking.setMorning_highestBooking((double) sourceBooking.getMorning_highestBooking().getMorning());
            convertedBooking.setMorningAverageBooking(sourceBooking.getMorningAverageBooking());
            convertedBooking.setMorning_lowestBooking((double) sourceBooking.getMorning_lowestBooking().getMorning());
            convertedBooking.setAfternoon_highestBooking((double) sourceBooking.getAfternoon_highestBooking().getAfternoon());
            convertedBooking.setAfternoonAverageBooking(sourceBooking.getAfternoonAverageBooking());
            convertedBooking.setAfternoon_lowestBooking((double) sourceBooking.getAfternoon_lowestBooking().getAfternoon());
            convertedBookings[i] = convertedBooking;
        }
        if(bookingSize < 2)
        {
            return CompletableFuture.completedFuture((QuarterlyBookingPrediction[]) Arrays.stream(convertedBookings).toArray());
        } else if (bookingSize <= 13) {
            convertedBookings[bookingSize+1] = perdictionResultUnder13(convertedBookings);
            return  CompletableFuture.completedFuture((QuarterlyBookingPrediction[]) Arrays.stream(convertedBookings).toArray());
        } else {
            int newSize = Math.min(23, bookingSize);
            QuarterlyBookingPrediction[] last23Entries = Arrays.copyOfRange(convertedBookings, bookingSize - newSize, bookingSize);
            convertedBookings[bookingSize+1] = perdictionResultOver13(last23Entries);
            return  CompletableFuture.completedFuture((QuarterlyBookingPrediction[]) Arrays.stream(convertedBookings).toArray());
        }
    };
    private QuarterlyBookingPrediction perdictionResultUnder13(QuarterlyBookingPrediction[] quarterlyBookingPredictions){
        QuarterlyBookingPrediction prediction = new QuarterlyBookingPrediction();
        prediction.setQuarter((quarterlyBookingPredictions[quarterlyBookingPredictions.length].getQuarter() % 4) + 1);
        prediction.setYear(prediction.getQuarter() == 1 ? Integer.toString(Integer.parseInt(quarterlyBookingPredictions[quarterlyBookingPredictions.length].getYear())+1) : quarterlyBookingPredictions[quarterlyBookingPredictions.length].getYear());
        prediction.setTotalBookings(predictNextValue((List<Double>) Arrays.stream(quarterlyBookingPredictions).mapToDouble(QuarterlyBookingPrediction::getTotalBookings)).intValue());
        prediction.setMorning_highestBooking(predictNextValue(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getMorning_highestBooking).toList()));
        prediction.setMorningAverageBooking(predictNextValue(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getMorningAverageBooking).toList()));
        prediction.setMorning_lowestBooking(predictNextValue(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getMorning_lowestBooking).toList()));
        prediction.setAfternoon_highestBooking(predictNextValue(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getAfternoon_highestBooking).toList()));
        prediction.setAfternoonAverageBooking(predictNextValue(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getAfternoonAverageBooking).toList()));
        prediction.setAfternoon_lowestBooking(predictNextValue(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getAfternoon_lowestBooking).toList()));
        return prediction;
    }

    private QuarterlyBookingPrediction perdictionResultOver13(QuarterlyBookingPrediction[] quarterlyBookingPredictions){
        QuarterlyBookingPrediction prediction = new QuarterlyBookingPrediction();
        prediction.setQuarter((quarterlyBookingPredictions[quarterlyBookingPredictions.length].getQuarter() % 4) + 1);
        prediction.setYear(prediction.getQuarter() == 1 ? Integer.toString(Integer.parseInt(quarterlyBookingPredictions[quarterlyBookingPredictions.length].getYear())+1) : quarterlyBookingPredictions[quarterlyBookingPredictions.length].getYear());
        prediction.setTotalBookings(calculateDiffernce((List<Double>) Arrays.stream(quarterlyBookingPredictions).mapToDouble(QuarterlyBookingPrediction::getTotalBookings)).intValue());
        prediction.setMorning_highestBooking(calculateDiffernce(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getMorning_highestBooking).toList()));
        prediction.setMorningAverageBooking(calculateDiffernce(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getMorningAverageBooking).toList()));
        prediction.setMorning_lowestBooking(calculateDiffernce(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getMorning_lowestBooking).toList()));
        prediction.setAfternoon_highestBooking(calculateDiffernce(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getAfternoon_highestBooking).toList()));
        prediction.setAfternoonAverageBooking(calculateDiffernce(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getAfternoonAverageBooking).toList()));
        prediction.setAfternoon_lowestBooking(calculateDiffernce(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getAfternoon_lowestBooking).toList()));
        return prediction;
    }
}
