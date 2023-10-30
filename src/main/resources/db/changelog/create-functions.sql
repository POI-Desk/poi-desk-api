-- changeset liquibase:1
CREATE OR REPLACE FUNCTION getAmountOfSeatsinLocationById(locationId uuid)
    RETURNS INTEGER
AS $$
BEGIN
    return (select COALESCE(count(pk_deskid), 0) from desks d1
    join floors f on f.pk_floorid = d1.fk_floorid
    join buildings b on b.pk_buildingid = f.fk_buildingid
    where b.fk_locationid = locationId);
END;
$$
LANGUAGE plpgsql;
-- changeset liquibase:2
CREATE OR REPLACE FUNCTION getQuarterFromCurrentMonth()
    RETURNS INTEGER
AS $$
BEGIN
    return CASE
               WHEN SUBSTRING(to_char(CURRENT_DATE, 'YYYY-MM') from 6)::Integer BETWEEN 1 AND 3 THEN 'Q1'
               WHEN SUBSTRING(to_char(CURRENT_DATE, 'YYYY-MM') from 6)::Integer BETWEEN 4 AND 6 THEN 'Q2'
               WHEN SUBSTRING(to_char(CURRENT_DATE, 'YYYY-MM') from 6)::Integer BETWEEN 7 AND 9 THEN 'Q3'
               WHEN SUBSTRING(to_char(CURRENT_DATE, 'YYYY-MM') from 6)::Integer BETWEEN 10 AND 12 THEN 'Q4'
        END;
END;
$$
LANGUAGE plpgsql;
-- changeset liquibase:3
CREATE OR REPLACE FUNCTION createEmptyAnalysisEntries()
    RETURNS VOID
AS $$
BEGIN
    insert into YearlyBookings(fk_Location)
    SELECT l.pk_locationid from locations l;

    insert into QuarterlyBookings(fk_Location, quarter, fk_yearlyBookingId)
    SELECT l.pk_locationid, 'Q1', (select pk_yearlyBookingId from yearlybookings where fk_Location = l.pk_locationid) from locations l;

    insert into QuarterlyBookings(fk_Location, quarter, fk_yearlyBookingId)
    SELECT l.pk_locationid, 'Q2', (select pk_yearlyBookingId from yearlybookings where fk_Location = l.pk_locationid) from locations l;

    insert into QuarterlyBookings(fk_Location, quarter, fk_yearlyBookingId)
    SELECT l.pk_locationid, 'Q3', (select pk_yearlyBookingId from yearlybookings where fk_Location = l.pk_locationid) from locations l;

    insert into QuarterlyBookings(fk_Location, quarter, fk_yearlyBookingId)
    SELECT l.pk_locationid, 'Q4', (select pk_yearlyBookingId from yearlybookings where fk_Location = l.pk_locationid) from locations l;

END;
$$
LANGUAGE plpgsql;
-- changeset liquibase:4
CREATE OR REPLACE FUNCTION createEmptyMonthlyAnalysisEntries()
    RETURNS VOID
AS $$
BEGIN
    WITH Month AS (
        SELECT
            to_char(CURRENT_DATE, 'YYYY-MM') as "month")

    insert into MonthlyBookings(month, fk_Location, fk_quarterlyBookingId)
    SELECT m.month as "month", l.pk_locationid,
           (select q.pk_quarterlyBookingId from QuarterlyBookings q where q.fk_Location = l.pk_locationid and
                   year = to_char(CURRENT_DATE, 'YYYY') and q.quarter = getQuarterFromCurrentMonth())
    from Month m
             cross join locations l;
END;
$$
LANGUAGE plpgsql;
-- changeset liquibase:5
CREATE OR REPLACE FUNCTION createDaylyAnalysisEntries()
    RETURNS VOID
AS $$
BEGIN
    insert into DailyBookings(pk_day, pk_fk_Location, totalBookings, fk_monthlyBookingId)
    SELECT to_char(CURRENT_DATE, 'YYYY-MM-DD') as "day", b2.fk_locationid, count(*),
           (select m.pk_monthlyBookingId from MonthlyBookings m where
                   m.fk_location = b2.fk_locationid and m.month = to_char(CURRENT_DATE, 'YYYY-MM'))  from bookings b
                                                                                                              join desks d on d.pk_deskid = b.fk_deskid
                                                                                                              join floors f on d.fk_floorid = f.pk_floorid
                                                                                                              join buildings b2 on b2.pk_buildingid = f.fk_buildingid
    where b.date = current_date
    group by day, b2.fk_locationid;
END;
$$
    LANGUAGE plpgsql;
-- changeset liquibase:6
CREATE OR REPLACE FUNCTION createMonthAnalysisEntries()
    RETURNS VOID
AS $$
BEGIN
    With Month as (
        select d.totalBookings, m.pk_monthlyBookingId from dailybookings d
                                                               join monthlybookings m on d.fk_monthlyBookingId = m.pk_monthlyBookingId
        where d.pk_fk_Location = m.fk_Location
    )

    update monthlybookings m
    set
        totalbookings  =  (select COALESCE(sum(m2.totalBookings), 0) from Month m2 where m.pk_monthlyBookingId = m2.pk_monthlyBookingId),
        highestBookings = (select COALESCE(max(m2.totalBookings), 0) from Month m2 where m.pk_monthlyBookingId = m2.pk_monthlyBookingId),
        averageBookings = (select COALESCE(avg(m2.totalBookings), 0) from Month m2 where m.pk_monthlyBookingId = m2.pk_monthlyBookingId),
        lowestBookings =  (select COALESCE(min(m2.totalBookings), 0) from Month m2 where m.pk_monthlyBookingId = m2.pk_monthlyBookingId),
        amountOfDesks = getAmountOfSeatsinLocationById(m.fk_Location)
    where month = to_char(CURRENT_DATE, 'YYYY-MM');

END;
$$
LANGUAGE plpgsql;
-- changeset liquibase:7
CREATE OR REPLACE FUNCTION createQuarterAnalysisEntries()
    RETURNS VOID
AS $$
BEGIN
    With Quarter as (
        select d.totalBookings, q2.pk_quarterlyBookingId from dailybookings d
                                                                  join monthlybookings m on d.fk_monthlyBookingId = m.pk_monthlyBookingId
                                                                  join quarterlybookings q2 on m.fk_quarterlyBookingId = q2.pk_quarterlyBookingId
        where d.pk_fk_Location = q2.fk_Location and
                q2.quarter = getQuarterFromCurrentMonth()
    )

    update quarterlybookings q
    set
        amountOfDesks = getAmountOfSeatsinLocationById(q.fk_Location),
        totalbookings =   (select COALESCE(sum(d.totalBookings), 0) from Quarter d where d.pk_quarterlyBookingId = q.pk_quarterlyBookingId),
        highestBookings = (select COALESCE(max(d.totalBookings), 0) from Quarter d where d.pk_quarterlyBookingId = q.pk_quarterlyBookingId),
        averageBookings = (select COALESCE(avg(d.totalBookings), 0) from Quarter d where d.pk_quarterlyBookingId = q.pk_quarterlyBookingId),
        lowestBookings =  (select COALESCE(min(d.totalBookings), 0) from Quarter d where d.pk_quarterlyBookingId = q.pk_quarterlyBookingId)
    where quarter = getQuarterFromCurrentMonth() and year = to_char(CURRENT_DATE, 'YYYY');

END;
$$
LANGUAGE plpgsql;
-- changeset liquibase:8
CREATE OR REPLACE FUNCTION createYearAnalysisEntries()
    RETURNS VOID
AS $$
BEGIN
    With Year as (
        select d.totalBookings, q.fk_yearlybookingid from dailybookings d
        join monthlybookings m on d.fk_monthlyBookingId = m.pk_monthlyBookingId
        join quarterlybookings q on m.fk_quarterlyBookingId = q.pk_quarterlyBookingId
        where q.year = to_char(CURRENT_DATE, 'YYYY') and
                q.fk_Location = d.pk_fk_Location
    )

    update yearlybookings y
    set
        amountOfDesks = getAmountOfSeatsinLocationById(y.fk_Location),
        totalbookings =   (select COALESCE(sum(y2.totalBookings), 0) from Year y2 where y2.fk_yearlyBookingId = y.pk_yearlyBookingId),
        highestBookings = (select COALESCE(max(y2.totalBookings), 0) from Year y2 where y2.fk_yearlyBookingId = y.pk_yearlyBookingId),
        averageBookings = (select COALESCE(avg(y2.totalBookings), 0) from Year y2 where y2.fk_yearlyBookingId = y.pk_yearlyBookingId),
        lowestBookings =  (select COALESCE(min(y2.totalBookings), 0) from Year y2 where y2.fk_yearlyBookingId = y.pk_yearlyBookingId)
    where year = to_char(CURRENT_DATE, 'YYYY');

END;
$$
LANGUAGE plpgsql;