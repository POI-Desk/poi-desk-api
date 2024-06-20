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

import static at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Prediction.*;

@Service
public class QuarterlyBookingService {
    @Autowired
    private QuarterlyBookingRepo quarterlyBookingRepo;

    @Async
    public CompletableFuture<QuarterlyBooking> getQuarterlyBooking(String year, Integer quarter, UUID IdentifierId, IdentifierType identifier){
        List<QuarterlyBooking> quarterlyBookings = filterQuarterlyBookings(IdentifierId, identifier);
        if(quarterlyBookings == null || quarterlyBookings.isEmpty()){
            System.err.println("quarterlyBookings is null or empty. Unable to proceed.");
            return CompletableFuture.completedFuture(null);
        }
        Optional<QuarterlyBooking> quarterlyBookingByTime = quarterlyBookings.stream()
                .filter(booking -> Objects.equals(booking.getYear(), year) &&
                        Objects.equals(booking.getQuarter(), quarter))
                .findAny();
        if(quarterlyBookingByTime.isEmpty())
            return null;
        QuarterlyBooking selectedBooking = quarterlyBookingByTime.get();
        selectedBooking.setMonthlyBookings(selectedBooking.getSortedMonthlyBookings());
        return CompletableFuture.completedFuture(selectedBooking);
    };
    @Async
    public CompletableFuture<QuarterlyBookingPrediction[]> getQuarterlyBookingPrediction(UUID IdentifierId, IdentifierType identifier){
        List<QuarterlyBooking> quarterlyBookings = filterQuarterlyBookings(IdentifierId, identifier);
        if(quarterlyBookings == null || quarterlyBookings.isEmpty()){
            System.err.println("quarterlyBookings is null or empty. Unable to proceed.");
            return CompletableFuture.completedFuture(null);
        }
        try{
            quarterlyBookings =  quarterlyBookings.stream().sorted(Comparator.comparing(QuarterlyBooking::getYear).thenComparing(QuarterlyBooking::getQuarter)).toList();

        }
        catch(Error er){
            System.out.println(er);
        }
        if(quarterlyBookings.get(0).getDays() == 0)
        {
            return CompletableFuture.completedFuture(null);
        }
        int bookingSize = quarterlyBookings.size();
        QuarterlyBookingPrediction[] convertedBookings = new QuarterlyBookingPrediction[bookingSize];
        for (int i = 0; i < bookingSize-1; i++) {
            QuarterlyBooking sourceBooking = quarterlyBookings.get(i);
            QuarterlyBookingPrediction convertedBooking = new QuarterlyBookingPrediction();
            convertedBooking.setYear(sourceBooking.getYear());
            convertedBooking.setQuarter(sourceBooking.getQuarter());
            convertedBooking.setTotal(sourceBooking.getTotal());
            convertedBooking.setMorning_highestBooking((double) sourceBooking.getMorning_highestBooking().getMorning());
            convertedBooking.setMorningAverageBooking(sourceBooking.getMorningAverageBooking());
            convertedBooking.setMorning_lowestBooking((double) sourceBooking.getMorning_lowestBooking().getMorning());
            convertedBooking.setAfternoon_highestBooking((double) sourceBooking.getAfternoon_highestBooking().getAfternoon());
            convertedBooking.setAfternoonAverageBooking(sourceBooking.getAfternoonAverageBooking());
            convertedBooking.setAfternoon_lowestBooking((double) sourceBooking.getAfternoon_lowestBooking().getAfternoon());
            convertedBookings[i] = convertedBooking;
        }
        convertedBookings[bookingSize-1] = new QuarterlyBookingPrediction();

        if(bookingSize <= 1){
            return null;
        }
        else if(bookingSize == 2)
        {
            convertedBookings[1] = new QuarterlyBookingPrediction(convertedBookings[0]);
            if(convertedBookings[0].getQuarter() == 4){
                convertedBookings[1].setQuarter(1);
                convertedBookings[1].setYear( Integer.toString(Integer.parseInt(convertedBookings[0].getYear()) + 1 ));
            }
            else{
                convertedBookings[1].setQuarter( convertedBookings[1].getQuarter() + 1);
            }
            return CompletableFuture.completedFuture(convertedBookings);
        } else if (bookingSize <= 8) {
            convertedBookings[bookingSize-1] = perdictionResultUnder9(convertedBookings);
            return  CompletableFuture.completedFuture((QuarterlyBookingPrediction[]) Arrays.stream(convertedBookings).toArray());
        } else {
            int newSize = 9;
            QuarterlyBookingPrediction[] last9Entries = Arrays.copyOfRange(convertedBookings, bookingSize - newSize, bookingSize-1);
            convertedBookings[bookingSize-1] = perdictionResultOver9(last9Entries);
            return  CompletableFuture.completedFuture((QuarterlyBookingPrediction[]) Arrays.stream(convertedBookings).toArray());
        }
    }

    ;
    private QuarterlyBookingPrediction perdictionResultUnder9(QuarterlyBookingPrediction[] quarterlyBookingPredictions){
        QuarterlyBookingPrediction prediction = new QuarterlyBookingPrediction();
        prediction.setQuarter((quarterlyBookingPredictions[quarterlyBookingPredictions.length - 1].getQuarter() % 4) + 1);
        prediction.setYear(prediction.getQuarter() == 1 ? Integer.toString(Integer.parseInt(quarterlyBookingPredictions[quarterlyBookingPredictions.length -1].getYear())+1) : quarterlyBookingPredictions[quarterlyBookingPredictions.length - 1].getYear());
        prediction.setTotal(predictNextValue((List<Double>) Arrays.stream(quarterlyBookingPredictions).mapToDouble(QuarterlyBookingPrediction::getTotal)).intValue());
        prediction.setMorning_highestBooking(predictNextValue(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getMorning_highestBooking).toList()));
        prediction.setMorningAverageBooking(predictNextValue(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getMorningAverageBooking).toList()));
        prediction.setMorning_lowestBooking(predictNextValue(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getMorning_lowestBooking).toList()));
        prediction.setAfternoon_highestBooking(predictNextValue(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getAfternoon_highestBooking).toList()));
        prediction.setAfternoonAverageBooking(predictNextValue(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getAfternoonAverageBooking).toList()));
        prediction.setAfternoon_lowestBooking(predictNextValue(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getAfternoon_lowestBooking).toList()));
        return prediction;
    }

    private QuarterlyBookingPrediction perdictionResultOver9(QuarterlyBookingPrediction[] quarterlyBookingPredictions){
        QuarterlyBookingPrediction prediction = new QuarterlyBookingPrediction();
        prediction.setQuarter((quarterlyBookingPredictions[quarterlyBookingPredictions.length - 1].getQuarter() % 4) + 1);
        prediction.setYear(prediction.getQuarter() == 1 ? Integer.toString(Integer.parseInt(quarterlyBookingPredictions[quarterlyBookingPredictions.length - 1].getYear())+1) : quarterlyBookingPredictions[quarterlyBookingPredictions.length - 1].getYear());
        prediction.setTotal(calculateDifference((List<Double>) Arrays.stream(quarterlyBookingPredictions).mapToDouble(QuarterlyBookingPrediction::getTotal), 4).intValue());
        prediction.setMorning_highestBooking(calculateDifference(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getMorning_highestBooking).toList(), 4));
        prediction.setMorningAverageBooking(calculateDifference(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getMorningAverageBooking).toList(), 4));
        prediction.setMorning_lowestBooking(calculateDifference(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getMorning_lowestBooking).toList(), 4));
        prediction.setAfternoon_highestBooking(calculateDifference(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getAfternoon_highestBooking).toList(), 4));
        prediction.setAfternoonAverageBooking(calculateDifference(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getAfternoonAverageBooking).toList(), 4));
        prediction.setAfternoon_lowestBooking(calculateDifference(Arrays.stream(quarterlyBookingPredictions).map(QuarterlyBookingPrediction::getAfternoon_lowestBooking).toList(), 4));
        return prediction;
    }

    private List<QuarterlyBooking> filterQuarterlyBookings(UUID IdentifierId, IdentifierType identifier){
        List<QuarterlyBooking> quarterlyBookings = (List<QuarterlyBooking>)quarterlyBookingRepo.findAll();
        if(quarterlyBookings.isEmpty())
            return null;
        quarterlyBookings.sort(Comparator.comparing(QuarterlyBooking::getYear).thenComparing(QuarterlyBooking::getQuarter));
        switch (identifier){
            case Location -> {
                return quarterlyBookings.stream()
                        .filter(booking -> booking.getFk_location() != null &&
                                Objects.equals(booking.getFk_location().getPk_locationid(), IdentifierId))
                        .toList();
            }
            case Building -> {
                return quarterlyBookings.stream()
                        .filter(booking -> booking.getFk_building() != null &&
                                Objects.equals(booking.getFk_building().getPk_buildingid(), IdentifierId))
                        .toList();
            }
            case Floor -> {
                return quarterlyBookings.stream()
                        .filter(booking -> booking.getFk_floor() != null &&
                                Objects.equals(booking.getFk_floor().getPk_floorid(), IdentifierId))
                        .toList();
            }
            default -> throw new IllegalArgumentException("False identifiers");
        }
    }
}