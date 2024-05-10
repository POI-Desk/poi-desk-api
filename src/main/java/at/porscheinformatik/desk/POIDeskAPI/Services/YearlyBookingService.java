package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.YearlyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.YearlyBooking;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Types.IdentifierType;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.YearlyBookingPrediction;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.CompletableFuture;

import static at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Prediction.predictNextValue;

@Service
public class YearlyBookingService {
    @Autowired
    private YearlyBookingRepo yearlyBookingRepo;

    @Async
    public CompletableFuture<List<String>> getAllYears(){
        List<YearlyBooking> yearlyBookings = (List<YearlyBooking>)yearlyBookingRepo.findAll();
        List<String> uniqueYears = new ArrayList<>();
        for (YearlyBooking yearlyBooking : yearlyBookings) {
            if (!uniqueYears.contains(yearlyBooking.getYear())) {
                uniqueYears.add(yearlyBooking.getYear());
            }
        }
        if(uniqueYears.isEmpty())
            return null;
        return CompletableFuture.completedFuture(uniqueYears);
    }
    @Async
    public CompletableFuture<YearlyBooking> getYearlyBooking(String year, UUID IdentifierId, IdentifierType identifier){
        List<YearlyBooking> yearlyBookings = (List<YearlyBooking>)yearlyBookingRepo.findAll();
        List<YearlyBooking> yearlyBooking = yearlyBookings.stream()
                .filter(booking -> Objects.equals(booking.getYear(), year)).toList();
        Optional<YearlyBooking> selectedYearlyBooking;
        switch (identifier){
            case Location -> {
                selectedYearlyBooking = yearlyBooking.stream()
                        .filter(booking -> booking.getFk_location() != null &&
                                Objects.equals(booking.getFk_location().getPk_locationid(), IdentifierId) &&
                                booking.getFk_building() == null &&
                                booking.getFk_floor() == null)
                        .findFirst();
            }
            case Building -> {
                selectedYearlyBooking = yearlyBooking.stream()
                        .filter(booking -> booking.getFk_location() == null &&
                                booking.getFk_building() != null &&
                                Objects.equals(booking.getFk_building().getPk_buildingid(), IdentifierId) &&
                                booking.getFk_floor() == null)
                        .findFirst();
            }
            case Floor -> {
                selectedYearlyBooking = yearlyBooking.stream()
                        .filter(booking -> booking.getFk_location() == null &&
                                booking.getFk_building() == null &&
                                booking.getFk_floor() != null &&
                                Objects.equals(booking.getFk_floor().getPk_floorid(), IdentifierId))
                        .findFirst();
            }
            default -> throw new IllegalArgumentException("False identifiere");
        }
        return CompletableFuture.completedFuture(selectedYearlyBooking.orElse(null));
    };
    @Async
    public CompletableFuture<YearlyBookingPrediction[]> getYearlyBookingPrediction(UUID IdentifierId, IdentifierType identifier){
        List<YearlyBooking> yearlyBookings = (List<YearlyBooking>)yearlyBookingRepo.findAll();
        if(yearlyBookings.isEmpty())
        {
            return CompletableFuture.completedFuture(null);
        }
        List<YearlyBooking> selectedYearlyBookings;
        switch (identifier){
            case Location -> {
                selectedYearlyBookings = yearlyBookings.stream()
                        .filter(booking -> booking.getFk_location() != null &&
                                Objects.equals(booking.getFk_location().getPk_locationid(), IdentifierId) &&
                                booking.getFk_building() == null &&
                                booking.getFk_floor() == null)
                        .toList();
            }
            case Building -> {
                selectedYearlyBookings = yearlyBookings.stream()
                        .filter(booking -> booking.getFk_location() == null &&
                                booking.getFk_building() != null &&
                                Objects.equals(booking.getFk_building().getPk_buildingid(), IdentifierId) &&
                                booking.getFk_floor() == null)
                        .toList();
            }
            case Floor -> {
                selectedYearlyBookings = yearlyBookings.stream()
                        .filter(booking -> booking.getFk_location() == null &&
                                booking.getFk_building() == null &&
                                booking.getFk_floor() != null &&
                                Objects.equals(booking.getFk_floor().getPk_floorid(), IdentifierId))
                        .toList();
            }
            default -> throw new IllegalArgumentException("False identifiere");
        }
        if(selectedYearlyBookings.isEmpty())
        {
            return CompletableFuture.completedFuture(null);
        }
        int bookingSize = selectedYearlyBookings.size();
        YearlyBookingPrediction[] convertedBookings = new YearlyBookingPrediction[bookingSize+1];
        for (int i = 0; i < selectedYearlyBookings.size(); i++) {
            YearlyBooking sourceBooking = selectedYearlyBookings.get(i);
            YearlyBookingPrediction convertedBooking = new YearlyBookingPrediction();
            convertedBooking.setYear(sourceBooking.getYear());
            convertedBooking.setTotal(sourceBooking.getTotal());
            convertedBooking.setMorning_highestBooking((double) sourceBooking.getMorning_highestBooking().getMorning());
            convertedBooking.setMorningAverageBooking(sourceBooking.getMorningAverageBooking());
            convertedBooking.setMorning_lowestBooking((double) sourceBooking.getMorning_lowestBooking().getMorning());
            convertedBooking.setAfternoon_highestBooking((double) sourceBooking.getAfternoon_highestBooking().getAfternoon());
            convertedBooking.setAfternoonAverageBooking(sourceBooking.getAfternoonAverageBooking());
            convertedBooking.setAfternoon_lowestBooking((double) sourceBooking.getAfternoon_lowestBooking().getAfternoon());
            convertedBookings[i] = convertedBooking;
        }
        if(bookingSize == 1)
        {
            convertedBookings[bookingSize] = convertedBookings[bookingSize-1];
            convertedBookings[bookingSize].setYear(convertedBookings[bookingSize].getYear() + 1);
            return CompletableFuture.completedFuture(convertedBookings);
        } else {
            convertedBookings[bookingSize+1] = perdictionResult(convertedBookings);
            return  CompletableFuture.completedFuture((YearlyBookingPrediction[]) Arrays.stream(convertedBookings).toArray());
        }
    };
    private YearlyBookingPrediction perdictionResult(YearlyBookingPrediction[] yearlyBookingPredictions){
        YearlyBookingPrediction prediction = new YearlyBookingPrediction();
        prediction.setYear(String.valueOf(Integer.parseInt(yearlyBookingPredictions[yearlyBookingPredictions.length - 1].getYear())+1));
        prediction.setTotal(predictNextValue((List<Double>) Arrays.stream(yearlyBookingPredictions).mapToDouble(YearlyBookingPrediction::getTotal)).intValue());
        prediction.setMorning_highestBooking(predictNextValue(Arrays.stream(yearlyBookingPredictions).map(YearlyBookingPrediction::getMorning_highestBooking).toList()));
        prediction.setMorningAverageBooking(predictNextValue(Arrays.stream(yearlyBookingPredictions).map(YearlyBookingPrediction::getMorningAverageBooking).toList()));
        prediction.setMorning_lowestBooking(predictNextValue(Arrays.stream(yearlyBookingPredictions).map(YearlyBookingPrediction::getMorning_lowestBooking).toList()));
        prediction.setAfternoon_highestBooking(predictNextValue(Arrays.stream(yearlyBookingPredictions).map(YearlyBookingPrediction::getAfternoon_highestBooking).toList()));
        prediction.setAfternoonAverageBooking(predictNextValue(Arrays.stream(yearlyBookingPredictions).map(YearlyBookingPrediction::getAfternoonAverageBooking).toList()));
        prediction.setAfternoon_lowestBooking(predictNextValue(Arrays.stream(yearlyBookingPredictions).map(YearlyBookingPrediction::getAfternoon_lowestBooking).toList()));
        return prediction;
    }
}
