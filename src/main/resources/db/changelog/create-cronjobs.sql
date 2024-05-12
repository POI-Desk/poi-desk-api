-- liquibase formatted sql

-- changeset liquibase:1
CREATE EXTENSION IF NOT EXISTS pg_cron;

-- changeset liquibase:2
SELECT cron.schedule('0 0 * * *', $$DELETE FROM bookings WHERE date < to_char(current_date - interval '14 days', 'YYYY-MM-DD')$$);

-- changeset liquibase:3
SELECT cron.schedule('0 1 1 1 *', $$SELECT createEmptyYearlyAnalysisEntries()$$);

-- changeset liquibase:4
SELECT cron.schedule('0 2 1 3,6,9,12 *', $$SELECT createEmptyQuarterlyAnalysisEntries()$$);

-- changeset liquibase:5
SELECT cron.schedule('0 3 1 * *', $$SELECT createEmptyMonthlyAnalysisEntries()$$);

-- changeset liquibase:6
SELECT cron.schedule('0 20 * * 1-5', $$SELECT runDailyAnalysisFunctions()$$);

-- changeset liquibase:7
SELECT cron.schedule('0 21 $ 1,2,4,5,7,8,10,11 *', $$SELECT runMonthlyAnalysisFunctions()$$);

-- changeset liquibase:8
SELECT cron.schedule('0 21 $ 3,6,9 *', $$SELECT runQuarterlyAnalysisFunctions()$$);

-- changeset liquibase:9
SELECT cron.schedule('0 21 $ 12 *', $$SELECT runYearlyAnalysisFunctions()$$);
