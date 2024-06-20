package at.porscheinformatik.desk.POIDeskAPI.ModelsClasses;

import java.util.List;

public class Prediction {
    public static Double calculateDifference(List<Double> data, int count){
        double percentageChange = 0.00;
        for (int i = count; i < data.size(); i++) {
            Double currentData = data.get(i);
            Double previousData = data.get(i - count);

            double percentageDifference = calculatePercentageDifference(
                    currentData,
                    previousData
            );
            percentageChange += percentageDifference;
        }

        double result = data.get(count) * (1 +(percentageChange / count));
        if(result < 0)
            return 0.00;
        return result;
    }

    public static Double predictNextValue(List<Double> data) {
        int size = data.size();

        if (size < 2) {
            throw new IllegalArgumentException("Linear regression requires at least two data points.");
        }

        double[] x = new double[size];
        double[] y = new double[size];

        for (int i = 0; i < size; i++) {
            x[i] = i;
            y[i] = data.get(i);
        }

        double slope = calculateSlope(x, y);
        double intercept = calculateIntercept(x, y, slope);
        double newX = size;

        return predictValue(slope, intercept, newX);
    }

    private static double calculateSlope(double[] x, double[] y) {
        int n = x.length;

        // Calculate the mean of x and y
        double meanX = calculateMean(x);
        double meanY = calculateMean(y);

        // Calculate the covariance and variance of x
        double covarianceXY = calculateCovariance(x, y, meanX, meanY);
        double varianceX = calculateVariance(x, meanX);

        // Calculate the slope
        return covarianceXY / varianceX;
    }

    private static double calculateIntercept(double[] x, double[] y, double slope) {
        // Calculate the mean of x and y
        double meanX = calculateMean(x);
        double meanY = calculateMean(y);

        // Calculate the intercept
        return meanY - ( slope * meanX );
    }

    private static double calculateMean(double[] values) {
        if (values.length == 0) {
            throw new IllegalArgumentException("Array length must be greater than zero for mean calculation.");
        }

        double sum = 0;
        for (double value : values) {
            sum += value;
        }
        return sum / values.length;
    }

    private static double calculateCovariance(double[] x, double[] y, double meanX, double meanY) {
        double sum = 0;
        for (int i = 0; i < x.length; i++) {
            sum += (x[i] - meanX) * (y[i] - meanY);
        }
        return sum / x.length;
    }

    private static double calculateVariance(double[] values, double mean) {
        double sum = 0;
        for (double value : values) {
            sum += Math.pow(value - mean, 2);
        }
        return sum / values.length;
    }

    private static double predictValue(double slope, double intercept, double x) {
        return intercept + (slope * x);
    }

    private static double calculatePercentageDifference(double currentValue, double previousValue) {
        return (currentValue - previousValue) / 100.0;
    }

    public static double predictValueWithIncrease(double previousValue, double percentageIncrease) {
        return previousValue + (previousValue * (percentageIncrease / 100.0));
    }
}