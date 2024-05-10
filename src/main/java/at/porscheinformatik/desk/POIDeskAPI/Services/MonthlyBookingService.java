package at.porscheinformatik.desk.POIDeskAPI.Services;

import at.porscheinformatik.desk.POIDeskAPI.ControllerRepos.MonthlyBookingRepo;
import at.porscheinformatik.desk.POIDeskAPI.Models.MonthlyBooking;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.MonthlyBookingPrediction;
import at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Types.IdentifierType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.stream.Collectors;

import static at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Prediction.calculateDifference;
import static at.porscheinformatik.desk.POIDeskAPI.ModelsClasses.Prediction.predictNextValue;

@Service
public class MonthlyBookingService {
    @Autowired
    private MonthlyBookingRepo monthlyBookingRepo;

    @Async
    public CompletableFuture<MonthlyBooking> getMonthlyBooking(String year, String month, UUID IdentifierId, IdentifierType identifier){
        List<MonthlyBooking> monthlyBookings = filterMonthlyBookings(IdentifierId, identifier);
        if(monthlyBookings == null || monthlyBookings.isEmpty()){
            System.err.println("monthlyBookings is null or empty. Unable to proceed.");
            return CompletableFuture.completedFuture(null);
        }
        String finalMonth = String.format("%02d", Integer.parseInt(month));
        Optional<MonthlyBooking> monthlyBooking = monthlyBookings.stream()
                .filter(booking -> Objects.equals(booking.getMonth(), year + "-" + finalMonth)).findAny();
        if(monthlyBooking.isEmpty())
            return CompletableFuture.completedFuture(null);
        MonthlyBooking selectedBooking = monthlyBooking.get();
        //selectedBooking.setDailyBookings(selectedBooking.getSortedDailyBookings());
        return CompletableFuture.completedFuture(selectedBooking);
    };
    @Async
    public CompletableFuture<MonthlyBookingPrediction[]> getMonthlyBookingPrediction(UUID IdentifierId, IdentifierType identifier){
        List<MonthlyBooking> monthlyBookings = filterMonthlyBookings(IdentifierId, identifier);
        if (monthlyBookings == null || monthlyBookings.isEmpty()) {
            System.err.println("monthlyBookings is null or empty. Unable to proceed.");
            return CompletableFuture.completedFuture(null);
        }
        try {
            monthlyBookings.sort(Comparator.comparing(MonthlyBooking::getMonth));
            monthlyBookings.forEach(MonthlyBooking::getSortedDailyBookings);
        }
        catch (Exception ex){
            System.out.println("Error" + ex);
        }
        int bookingSize = monthlyBookings.size();
        MonthlyBookingPrediction[] convertedBookings = new MonthlyBookingPrediction[bookingSize+1];
        for (int i = 0; i < monthlyBookings.size(); i++) {
            MonthlyBooking sourceBooking = monthlyBookings.get(i);
            MonthlyBookingPrediction convertedBooking = new MonthlyBookingPrediction();
            convertedBooking.setMonth(sourceBooking.getMonth());
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
            convertedBookings[bookingSize].setMonth(String.valueOf(YearMonth.parse(convertedBookings[bookingSize].getMonth(), DateTimeFormatter.ofPattern("yyyy-MM")).plusMonths(1)));
            return CompletableFuture.completedFuture(convertedBookings);
        } else if (bookingSize <= 13) {
            convertedBookings[bookingSize] = perdictionResultUnder13(Arrays.copyOfRange(convertedBookings,0 , bookingSize));
            return  CompletableFuture.completedFuture(convertedBookings);
        } else {
            int newSize = Math.min(23, bookingSize);
            MonthlyBookingPrediction[] last23Entries = Arrays.copyOfRange(convertedBookings, bookingSize - newSize, bookingSize);
            convertedBookings[bookingSize] = perdictionResultOver13(last23Entries);
            return  CompletableFuture.completedFuture((MonthlyBookingPrediction[]) Arrays.stream(convertedBookings).toArray());
        }
    };
    private MonthlyBookingPrediction perdictionResultUnder13(MonthlyBookingPrediction[] monthlyBookingsPrediction) {
        MonthlyBookingPrediction prediction = new MonthlyBookingPrediction();
        prediction.setMonth(String.valueOf(YearMonth.parse(monthlyBookingsPrediction[monthlyBookingsPrediction.length-1].getMonth(), DateTimeFormatter.ofPattern("yyyy-MM")).plusMonths(1)));
        prediction.setTotal(predictNextValue((Arrays.stream(monthlyBookingsPrediction)).mapToDouble(MonthlyBookingPrediction::getTotal).boxed().collect(Collectors.toList())).intValue());
        prediction.setMorning_highestBooking(predictNextValue(Arrays.stream(monthlyBookingsPrediction).map(MonthlyBookingPrediction::getMorning_highestBooking).toList()));
        prediction.setMorningAverageBooking(predictNextValue(Arrays.stream(monthlyBookingsPrediction).map(MonthlyBookingPrediction::getMorningAverageBooking).toList()));
        prediction.setMorning_lowestBooking(predictNextValue(Arrays.stream(monthlyBookingsPrediction).map(MonthlyBookingPrediction::getMorning_lowestBooking).toList()));
        prediction.setAfternoon_highestBooking(predictNextValue(Arrays.stream(monthlyBookingsPrediction).map(MonthlyBookingPrediction::getAfternoon_highestBooking).toList()));
        prediction.setAfternoonAverageBooking(predictNextValue(Arrays.stream(monthlyBookingsPrediction).map(MonthlyBookingPrediction::getAfternoonAverageBooking).toList()));
        prediction.setAfternoon_lowestBooking(predictNextValue(Arrays.stream(monthlyBookingsPrediction).map(MonthlyBookingPrediction::getAfternoon_lowestBooking).toList()));

        return prediction;
    }

    private MonthlyBookingPrediction perdictionResultOver13(MonthlyBookingPrediction[] monthlyBookingsPrediction){
        Map<Integer, MonthlyBookingPrediction> resultMap = new HashMap<>();
        for (int i = 0; i < monthlyBookingsPrediction.length-1; i++) {
            resultMap.put(i + 1, monthlyBookingsPrediction[i]);
        }

        MonthlyBookingPrediction prediction = new MonthlyBookingPrediction();
        prediction.setMonth(String.valueOf(YearMonth.parse(monthlyBookingsPrediction[monthlyBookingsPrediction.length-1].getMonth(), DateTimeFormatter.ofPattern("yyyy-MM")).plusMonths(1)));
        prediction.setTotal(calculateDifference((List<Double>) resultMap.values().stream().mapToDouble(MonthlyBookingPrediction::getTotal), 12).intValue());
        prediction.setMorning_highestBooking(calculateDifference(resultMap.values().stream().map(MonthlyBookingPrediction::getMorning_highestBooking).toList(), 12));
        prediction.setMorningAverageBooking(calculateDifference(resultMap.values().stream().map(MonthlyBookingPrediction::getMorningAverageBooking).toList(), 12));
        prediction.setMorning_lowestBooking(calculateDifference(resultMap.values().stream().map(MonthlyBookingPrediction::getMorning_lowestBooking).toList(), 12));
        prediction.setAfternoon_highestBooking(calculateDifference(resultMap.values().stream().map(MonthlyBookingPrediction::getAfternoon_highestBooking).toList(), 12));
        prediction.setAfternoonAverageBooking(calculateDifference(resultMap.values().stream().map(MonthlyBookingPrediction::getAfternoonAverageBooking).toList(), 12));
        prediction.setAfternoon_lowestBooking(calculateDifference(resultMap.values().stream().map(MonthlyBookingPrediction::getAfternoon_lowestBooking).toList(), 12));
        return prediction;
    }
    private List<MonthlyBooking> filterMonthlyBookings(UUID IdentifierId, IdentifierType identifier){
        List<MonthlyBooking> monthlyBookings = (List<MonthlyBooking>)monthlyBookingRepo.findAll();
        switch (identifier){
            case Location -> {
                return monthlyBookings.stream()
                        .filter(booking -> booking.getFk_location() != null &&
                                Objects.equals(booking.getFk_location().getPk_locationid(), IdentifierId))
                        .toList();
            }
            case Building -> {
                return monthlyBookings.stream()
                        .filter(booking -> booking.getFk_building() != null &&
                                Objects.equals(booking.getFk_building().getPk_buildingid(), IdentifierId))
                        .toList();
            }
            case Floor -> {
                return monthlyBookings.stream()
                        .filter(booking -> booking.getFk_floor() != null &&
                                Objects.equals(booking.getFk_floor().getPk_floorid(), IdentifierId))
                        .toList();
            }
            default -> throw new IllegalArgumentException("False Identifier");
        }
    }
}
