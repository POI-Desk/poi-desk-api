--changeset liquibase:1
CREATE OR REPLACE FUNCTION getAmountOfSeatsInLocationById(locationId uuid)
    RETURNS INTEGER
AS
$$
BEGIN
    return (select COALESCE(count(pk_deskid), 0)
            from desks d1
                     join maps m on m.pk_mapid = d1.fk_mapid
                     join floors f on f.pk_floorid = m.fk_floorid
                     join buildings b on b.pk_buildingid = f.fk_buildingid
            where b.fk_locationid = locationId);
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:2
CREATE OR REPLACE FUNCTION getAmountOfSeatsInBuildingById(buildingId uuid)
    RETURNS INTEGER
AS
$$
BEGIN
    return (select COALESCE(count(pk_deskid), 0)
            from desks d1
                     join maps m on m.pk_mapid = d1.fk_mapid
                     join floors f on f.pk_floorid = m.fk_floorid
            where f.fk_buildingid = buildingId);
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:3
CREATE OR REPLACE FUNCTION getAmountOfSeatsInFloorById(floorId uuid)
    RETURNS INTEGER
AS
$$
BEGIN
    return (select COALESCE(count(pk_deskid), 0)
            from desks d1
                     join maps m on m.pk_mapid = d1.fk_mapid
            where m.fk_floorid = floorId);
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:4
CREATE OR REPLACE FUNCTION getCurrentQuarter()
    RETURNS smallint
AS
$$
BEGIN
    return CEIL(EXTRACT(MONTH FROM CURRENT_DATE) / 3);
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:5
CREATE OR REPLACE FUNCTION createEmptyYearlyAnalysisEntries()
    RETURNS VOID
AS
$$
BEGIN
    insert into YearlyBookings(fk_location)
    SELECT l.pk_locationid
    from locations l;
    insert into YearlyBookings(fk_building)
    SELECT b.pk_buildingid
    from buildings b;
    insert into YearlyBookings(fk_floor)
    SELECT f.pk_floorid
    from floors f;
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:6
CREATE OR REPLACE FUNCTION createEmptyQuarterlyAnalysisEntries()
    RETURNS VOID
AS
$$
BEGIN
    insert into QuarterlyBookings(fk_location, quarter, fk_yearlyBookingId)
    SELECT l.pk_locationid,
           getCurrentQuarter(),
           (select y.pk_yearlyBookingId
            from yearlybookings y
            where y.fk_location = l.pk_locationid
              and y.year = to_char(current_date, 'YYYY'))
    from locations l;
    insert into QuarterlyBookings(fk_building, quarter, fk_yearlyBookingId)
    SELECT b.pk_buildingid,
           getCurrentQuarter(),
           (select y.pk_yearlyBookingId
            from yearlybookings y
            where y.fk_building = b.pk_buildingid
              and y.year = to_char(current_date, 'YYYY'))
    from buildings b;
    insert into QuarterlyBookings(fk_floor, quarter, fk_yearlyBookingId)
    SELECT f.pk_floorid,
           getCurrentQuarter(),
           (select y.pk_yearlyBookingId
            from yearlybookings y
            where y.fk_floor = f.pk_floorid
              and y.year = to_char(current_date, 'YYYY'))
    from floors f;
END;
$$
    LANGUAGE plpgsql;
--changeset liquibase:7
CREATE OR REPLACE FUNCTION createEmptyMonthlyAnalysisEntries()
    RETURNS VOID
AS
$$
BEGIN
    insert into MonthlyBookings(month, fk_Location, fk_quarterlyBookingId)
    SELECT to_char(CURRENT_DATE, 'YYYY-MM'),
           l.pk_locationid,
           (select q.pk_quarterlyBookingId
            from QuarterlyBookings q
            where q.fk_location = l.pk_locationid
              and year = to_char(CURRENT_DATE, 'YYYY')
              and q.quarter = getcurrentquarter())
    from locations l;
    insert into MonthlyBookings(month, fk_building, fk_quarterlyBookingId)
    SELECT to_char(CURRENT_DATE, 'YYYY-MM'),
           b.pk_buildingid,
           (select q.pk_quarterlyBookingId
            from QuarterlyBookings q
            where q.fk_building = b.pk_buildingid
              and year = to_char(CURRENT_DATE, 'YYYY')
              and q.quarter = getcurrentquarter())
    from buildings b;
    insert into MonthlyBookings(month, fk_floor, fk_quarterlyBookingId)
    SELECT to_char(CURRENT_DATE, 'YYYY-MM'),
           f.pk_floorid,
           (select q.pk_quarterlyBookingId
            from QuarterlyBookings q
            where q.fk_floor = f.pk_floorid
              and year = to_char(CURRENT_DATE, 'YYYY')
              and q.quarter = getcurrentquarter())
    from floors f;
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:8
CREATE OR REPLACE FUNCTION createDailyAnalysisEntriesForFloors()
    RETURNS VOID
AS
$$
BEGIN
    insert into DailyBookings(day, morning, afternoon, total, fk_floor, fk_monthlyBookingId)
    SELECT CURRENT_DATE,
           COALESCE((select count(*)
                     from bookings
                              join desks d2 on d2.pk_deskid = bookings.fk_deskid
                     where ismorning = true
                       and date = CURRENT_DATE
                       and d2.fk_floorid = f.pk_floorid
                     group by d2.fk_floorid), 0) as "morning",
           COALESCE((select count(*)
                     from bookings
                              join desks d2 on d2.pk_deskid = bookings.fk_deskid
                     where isafternoon = true
                       and date = CURRENT_DATE
                       and d2.fk_floorid = f.pk_floorid
                     group by d2.fk_floorid), 0) as "afternoon",
           COALESCE((select count(*)
                     from bookings
                              join desks d2 on d2.pk_deskid = bookings.fk_deskid
                     where ismorning = true
                       and date = CURRENT_DATE
                       and d2.fk_floorid = f.pk_floorid
                     group by d2.fk_floorid), 0) +
           COALESCE((select count(*)
                     from bookings
                              join desks d2 on d2.pk_deskid = bookings.fk_deskid
                     where isafternoon = true
                       and date = CURRENT_DATE
                       and d2.fk_floorid = f.pk_floorid
                     group by d2.fk_floorid), 0) as total,
           m.fk_floorid,
           (select m2.pk_monthlyBookingId
            from MonthlyBookings m2
            where m2.fk_floor is not null
              and m2.fk_floor = m.fk_floorid
              and m2.month = to_char(CURRENT_DATE, 'YYYY-MM'))
    from bookings b
             join desks d on d.pk_deskid = b.fk_deskid
             join maps m on d.fk_mapid = m.pk_mapid
    where b.date = CURRENT_DATE
    group by m.fk_floorid;
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:9
CREATE OR REPLACE FUNCTION createDailyAnalysisEntriesForBuildings()
    RETURNS VOID
AS
$$
BEGIN
    insert into DailyBookings(day, morning, afternoon, total, fk_building, fk_monthlyBookingId)
    SELECT day,
           SUM(d.morning),
           SUM(d.afternoon),
           SUM(d.total),
           f.fk_buildingid,
           (select pk_monthlyBookingId
            from MonthlyBookings m
            where m.fk_building is not null
              and m.fk_building = f.fk_buildingid
              and Left(d.day, 7) = m.month)
    FROM DailyBookings d
             JOIN Floors f ON d.fk_floor = f.pk_floorId
    WHERE d.fk_floor IS NOT NULL AND
          d.day = current_date
    GROUP BY f.fk_buildingid, day;
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:10
CREATE OR REPLACE FUNCTION createDailyAnalysisEntriesForLocations()
    RETURNS VOID
AS
$$
BEGIN
    insert into DailyBookings(day, morning, afternoon, total, fk_location, fk_monthlyBookingId)
    SELECT day,
           SUM(d.morning),
           SUM(d.afternoon),
           SUM(d.total),
           b.fk_locationid,
           (select pk_monthlyBookingId
            from MonthlyBookings m
            where m.fk_location is not null
              and m.fk_location = b.fk_locationid
              and Left(d.day, 7) = m.month)
    FROM DailyBookings d
             JOIN Buildings b ON d.fk_building = b.pk_buildingId
    WHERE d.fk_building IS NOT NULL AND
          d.day = current_date
    GROUP BY b.fk_locationid, day;
END;
$$
    LANGUAGE plpgsql;
--changeset liquibase:11
CREATE OR REPLACE FUNCTION createMonthlyAnalysisEntriesForFloors()
    RETURNS VOID
AS
$$
BEGIN
    With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, d.fk_monthlybookingid
                  from dailybookings d
                  where d.fk_floor is not null
                    and Left(d.day, 7) = to_char(CURRENT_DATE, 'YYYY-MM'))

    update monthlybookings m
    set total                    = (select COALESCE(sum(d.total), 0)
                                    from Days d
                                    where m.pk_monthlyBookingId = d.fk_monthlybookingid),
        days                     = (select count(*) from Days d where m.pk_monthlyBookingId = d.fk_monthlybookingid),
        amountOfDesks            = getamountofseatsinfloorbyid(m.fk_floor),
        morning_highestbooking   = (select pk_dailybookingid
                                    from Days d
                                    where d.fk_monthlybookingid = m.pk_monthlybookingid
                                    order by d.morning DESC
                                    LIMIT 1),
        morning_averageBooking   = (select COALESCE(round(avg(d.morning),2), 0)
                                    from Days d
                                    where m.pk_monthlyBookingId = d.fk_monthlybookingid),
        morning_lowestBooking    = (select pk_dailybookingid
                                    from Days d
                                    where d.fk_monthlybookingid = m.pk_monthlybookingid
                                    order by d.morning ASC
                                    LIMIT 1),
        afternoon_highestbooking = (select pk_dailybookingid
                                    from Days d
                                    where d.fk_monthlybookingid = m.pk_monthlybookingid
                                    order by d.afternoon DESC
                                    LIMIT 1),
        afternoon_averageBooking = (select COALESCE(round(avg(d.afternoon),2), 0)
                                    from Days d
                                    where m.pk_monthlyBookingId = d.fk_monthlybookingid),
        afternoon_lowestbooking  = (select pk_dailybookingid
                                    from Days d
                                    where d.fk_monthlybookingid = m.pk_monthlybookingid
                                    order by d.afternoon ASC
                                    LIMIT 1),
        updatedOn                = current_timestamp
    where month = to_char(CURRENT_DATE, 'YYYY-MM')
      and m.fk_floor is not null;
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:12
CREATE OR REPLACE FUNCTION createMonthlyAnalysisEntriesForBuildings()
    RETURNS VOID
AS
$$
BEGIN
    With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, d.fk_monthlybookingid
                  from dailybookings d
                  where d.fk_building is not null
                    and Left(d.day, 7) = to_char(CURRENT_DATE, 'YYYY-MM'))

    update monthlybookings m
    set total                    = (select COALESCE(sum(d.total), 0)
                                    from Days d
                                    where m.pk_monthlyBookingId = d.fk_monthlybookingid),
        days                     = (select count(*) from Days d where m.pk_monthlyBookingId = d.fk_monthlybookingid),
        amountOfDesks            = getamountofseatsinbuildingbyid(m.fk_building),
        morning_highestbooking   = (select pk_dailybookingid
                                    from Days d
                                    where d.fk_monthlybookingid = m.pk_monthlybookingid
                                    order by d.morning DESC
                                    LIMIT 1),
        morning_averageBooking   = (select COALESCE(round(avg(d.morning),2), 0)
                                    from Days d
                                    where m.pk_monthlyBookingId = d.fk_monthlybookingid),
        morning_lowestBooking    = (select pk_dailybookingid
                                    from Days d
                                    where d.fk_monthlybookingid = m.pk_monthlybookingid
                                    order by d.morning ASC
                                    LIMIT 1),
        afternoon_highestbooking = (select pk_dailybookingid
                                    from Days d
                                    where d.fk_monthlybookingid = m.pk_monthlybookingid
                                    order by d.afternoon DESC
                                    LIMIT 1),
        afternoon_averageBooking = (select COALESCE(round(avg(d.afternoon),2), 0)
                                    from Days d
                                    where m.pk_monthlyBookingId = d.fk_monthlybookingid),
        afternoon_lowestbooking  = (select pk_dailybookingid
                                    from Days d
                                    where d.fk_monthlybookingid = m.pk_monthlybookingid
                                    order by d.afternoon ASC
                                    LIMIT 1),
        updatedOn                = current_timestamp
    where month = to_char(CURRENT_DATE, 'YYYY-MM')
      and m.fk_building is not null;
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:13
CREATE OR REPLACE FUNCTION createMonthlyAnalysisEntriesForLocations()
    RETURNS VOID
AS
$$
BEGIN
    With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, d.fk_monthlybookingid
                  from dailybookings d
                  where d.fk_location is not null
                    and Left(d.day, 7) = to_char(CURRENT_DATE, 'YYYY-MM'))

    update monthlybookings m
    set total                    = (select COALESCE(sum(d.total), 0)
                                    from Days d
                                    where m.pk_monthlyBookingId = d.fk_monthlybookingid),
        days                     = (select count(*) from Days d where m.pk_monthlyBookingId = d.fk_monthlybookingid),
        amountOfDesks            = getamountofseatsinbuildingbyid(m.fk_building),
        morning_highestbooking   = (select pk_dailybookingid
                                    from Days d
                                    where d.fk_monthlybookingid = m.pk_monthlybookingid
                                    order by d.morning DESC
                                    LIMIT 1),
        morning_averageBooking   = (select COALESCE(round(avg(d.morning),2), 0)
                                    from Days d
                                    where m.pk_monthlyBookingId = d.fk_monthlybookingid),
        morning_lowestBooking    = (select pk_dailybookingid
                                    from Days d
                                    where d.fk_monthlybookingid = m.pk_monthlybookingid
                                    order by d.morning ASC
                                    LIMIT 1),
        afternoon_highestbooking = (select pk_dailybookingid
                                    from Days d
                                    where d.fk_monthlybookingid = m.pk_monthlybookingid
                                    order by d.afternoon DESC
                                    LIMIT 1),
        afternoon_averageBooking = (select COALESCE(round(avg(d.afternoon),2), 0)
                                    from Days d
                                    where m.pk_monthlyBookingId = d.fk_monthlybookingid),
        afternoon_lowestbooking  = (select pk_dailybookingid
                                    from Days d
                                    where d.fk_monthlybookingid = m.pk_monthlybookingid
                                    order by d.afternoon ASC
                                    LIMIT 1),
        updatedOn                = current_timestamp
    where month = to_char(CURRENT_DATE, 'YYYY-MM')
      and m.fk_location is not null;
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:14
CREATE OR REPLACE FUNCTION createQuarterlyAnalysisEntriesForFloors()
    RETURNS VOID
AS
$$
BEGIN
    With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, q.pk_quarterlyBookingId
                  from dailybookings d
                           join monthlybookings m on d.fk_monthlyBookingId = m.pk_monthlyBookingId
                           join quarterlybookings q on m.fk_quarterlybookingid = q.pk_quarterlyBookingId
                  where d.fk_floor is not null
                    and q.quarter = getcurrentquarter()
                    and q.year = to_char(CURRENT_DATE, 'YYYY'))

    update quarterlybookings q
    set total                    = (select COALESCE(sum(d.total), 0)
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId),
        days                     = (select count(*)
                                    from Days d
                                    where q.pk_quarterlybookingid = d.pk_quarterlybookingid),
        amountOfDesks            = getamountofseatsinfloorbyid(q.fk_floor),
        morning_highestBooking   = (select pk_dailyBookingId
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId
                                    order by d.morning Desc
                                    LIMIT 1),
        morning_averageBooking   = (select COALESCE(round(avg(d.morning),2), 0)
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId),
        morning_lowestBooking    = (select pk_dailyBookingId
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId
                                    order by d.morning ASC
                                    LIMIT 1),
        afternoon_highestBooking = (select pk_dailyBookingId
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId
                                    order by d.afternoon Desc
                                    LIMIT 1),
        afternoon_averageBooking = (select COALESCE(round(avg(d.afternoon),2), 0)
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId),
        afternoon_lowestBooking  = (select pk_dailyBookingId
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId
                                    order by d.afternoon ASC
                                    LIMIT 1),
        updatedOn                = current_timestamp
    where quarter = getcurrentquarter()
      and year = to_char(CURRENT_DATE, 'YYYY')
      and q.fk_floor is not null;
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:15
CREATE OR REPLACE FUNCTION createQuarterlyAnalysisEntriesForBuildings()
    RETURNS VOID
AS
$$
BEGIN
    With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, q.pk_quarterlyBookingId
                  from dailybookings d
                           join monthlybookings m on d.fk_monthlyBookingId = m.pk_monthlyBookingId
                           join quarterlybookings q on m.fk_quarterlybookingid = q.pk_quarterlyBookingId
                  where d.fk_building is not null
                    and q.quarter = getcurrentquarter()
                    and q.year = to_char(CURRENT_DATE, 'YYYY'))

    update quarterlybookings q
    set total                    = (select COALESCE(sum(d.total), 0)
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId),
        days                     = (select count(*)
                                    from Days d
                                    where q.pk_quarterlybookingid = d.pk_quarterlybookingid),
        amountOfDesks            = getamountofseatsinbuildingbyid(q.fk_floor),
        morning_highestBooking   = (select pk_dailyBookingId
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId
                                    order by d.morning Desc
                                    LIMIT 1),
        morning_averageBooking   = (select COALESCE(round(avg(d.morning),2), 0)
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId),
        morning_lowestBooking    = (select pk_dailyBookingId
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId
                                    order by d.morning ASC
                                    LIMIT 1),
        afternoon_highestBooking = (select pk_dailyBookingId
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId
                                    order by d.afternoon Desc
                                    LIMIT 1),
        afternoon_averageBooking = (select COALESCE(round(avg(d.afternoon),2), 0)
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId),
        afternoon_lowestBooking  = (select pk_dailyBookingId
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId
                                    order by d.afternoon ASC
                                    LIMIT 1),
        updatedOn                = current_timestamp
    where quarter = getcurrentquarter()
      and year = to_char(CURRENT_DATE, 'YYYY')
      and q.fk_building is not null;
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:16
CREATE OR REPLACE FUNCTION createQuarterlyAnalysisEntriesForLocations()
    RETURNS VOID
AS
$$
BEGIN
    With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, q.pk_quarterlyBookingId
                  from dailybookings d
                           join monthlybookings m on d.fk_monthlyBookingId = m.pk_monthlyBookingId
                           join quarterlybookings q on m.fk_quarterlybookingid = q.pk_quarterlyBookingId
                  where d.fk_location is not null
                    and q.quarter = getcurrentquarter()
                    and q.year = to_char(CURRENT_DATE, 'YYYY'))

    update quarterlybookings q
    set total                    = (select COALESCE(sum(d.total), 0)
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId),
        days                     = (select count(*)
                                    from Days d
                                    where q.pk_quarterlybookingid = d.pk_quarterlybookingid),
        amountOfDesks            = getamountofseatsinlocationbyid(q.fk_floor),
        morning_highestBooking   = (select pk_dailyBookingId
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId
                                    order by d.morning Desc
                                    LIMIT 1),
        morning_averageBooking   = (select COALESCE(round(avg(d.morning),2), 0)
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId),
        morning_lowestBooking    = (select pk_dailyBookingId
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId
                                    order by d.morning ASC
                                    LIMIT 1),
        afternoon_highestBooking = (select pk_dailyBookingId
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId
                                    order by d.afternoon Desc
                                    LIMIT 1),
        afternoon_averageBooking = (select COALESCE(round(avg(d.afternoon),2), 0)
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId),
        afternoon_lowestBooking  = (select pk_dailyBookingId
                                    from Days d
                                    where q.pk_quarterlyBookingId = d.pk_quarterlyBookingId
                                    order by d.afternoon ASC
                                    LIMIT 1),
        updatedOn                = current_timestamp
    where quarter = getcurrentquarter()
      and year = to_char(CURRENT_DATE, 'YYYY')
      and q.fk_location is not null;
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:17
CREATE OR REPLACE FUNCTION createYearlyAnalysisEntriesForFloors()
    RETURNS VOID
AS
$$
BEGIN
    With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, y.pk_yearlyBookingId
                  from dailybookings d
                           join monthlybookings m on d.fk_monthlyBookingId = m.pk_monthlyBookingId
                           join quarterlybookings q2 on m.fk_quarterlybookingid = q2.pk_quarterlyBookingId
                           join yearlybookings y on q2.fk_yearlyBookingId = y.pk_yearlyBookingId
                  where d.fk_floor is not null
                    and y.year = to_char(CURRENT_DATE, 'YYYY'))

    update YearlyBookings y
    set total                    = (select COALESCE(sum(d.total), 0)
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId),
        days                     = (select count(*) from Days d where y.pk_yearlybookingid = d.pk_yearlyBookingId),
        amountOfDesks            = getamountofseatsinfloorbyid(y.fk_floor),
        morning_highestBooking   = (select pk_dailyBookingId
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId
                                    order by d.morning Desc
                                    LIMIT 1),
        morning_averageBooking   = (select COALESCE(round(avg(d.morning),2), 0)
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId),
        morning_lowestBooking    = (select pk_dailyBookingId
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId
                                    order by d.morning ASC
                                    LIMIT 1),
        afternoon_highestBooking = (select pk_dailyBookingId
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId
                                    order by d.afternoon Desc
                                    LIMIT 1),
        afternoon_averageBooking = (select COALESCE(round(avg(d.afternoon),2), 0)
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId),
        afternoon_lowestBooking  = (select pk_dailyBookingId
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId
                                    order by d.afternoon ASC
                                    LIMIT 1),
        updatedOn                = current_timestamp
    where year = to_char(CURRENT_DATE, 'YYYY')
      AND y.fk_floor is not null;
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:18
CREATE OR REPLACE FUNCTION createYearlyAnalysisEntriesForBuildings()
    RETURNS VOID
AS
$$
BEGIN
    With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, y.pk_yearlyBookingId
                  from dailybookings d
                           join monthlybookings m on d.fk_monthlyBookingId = m.pk_monthlyBookingId
                           join quarterlybookings q2 on m.fk_quarterlybookingid = q2.pk_quarterlyBookingId
                           join yearlybookings y on q2.fk_yearlyBookingId = y.pk_yearlyBookingId
                  where d.fk_building is not null
                    and y.year = to_char(CURRENT_DATE, 'YYYY'))

    update YearlyBookings y
    set total                    = (select COALESCE(sum(d.total), 0)
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId),
        days                     = (select count(*) from Days d where y.pk_yearlybookingid = d.pk_yearlyBookingId),
        amountOfDesks            = getamountofseatsinbuildingbyid(y.fk_floor),
        morning_highestBooking   = (select pk_dailyBookingId
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId
                                    order by d.morning Desc
                                    LIMIT 1),
        morning_averageBooking   = (select COALESCE(round(avg(d.morning),2), 0)
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId),
        morning_lowestBooking    = (select pk_dailyBookingId
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId
                                    order by d.morning ASC
                                    LIMIT 1),
        afternoon_highestBooking = (select pk_dailyBookingId
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId
                                    order by d.afternoon Desc
                                    LIMIT 1),
        afternoon_averageBooking = (select COALESCE(round(avg(d.afternoon),2), 0)
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId),
        afternoon_lowestBooking  = (select pk_dailyBookingId
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId
                                    order by d.afternoon ASC
                                    LIMIT 1),
        updatedOn                = current_timestamp
    where year = to_char(CURRENT_DATE, 'YYYY')
      and y.fk_building is not null;
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:19
CREATE OR REPLACE FUNCTION createYearlyAnalysisEntriesForLocations()
    RETURNS VOID
AS
$$
BEGIN
    With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, y.pk_yearlyBookingId
                  from dailybookings d
                           join monthlybookings m on d.fk_monthlyBookingId = m.pk_monthlyBookingId
                           join quarterlybookings q2 on m.fk_quarterlybookingid = q2.pk_quarterlyBookingId
                           join yearlybookings y on q2.fk_yearlyBookingId = y.pk_yearlyBookingId
                  where d.fk_location is not null
                    and y.year = to_char(CURRENT_DATE, 'YYYY'))

    update YearlyBookings y
    set total                    = (select COALESCE(sum(d.total), 0)
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId),
        days                     = (select count(*) from Days d where y.pk_yearlybookingid = d.pk_yearlyBookingId),
        amountOfDesks            = getamountofseatsinlocationbyid(y.fk_floor),
        morning_highestBooking   = (select pk_dailyBookingId
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId
                                    order by d.morning Desc
                                    LIMIT 1),
        morning_averageBooking   = (select COALESCE(round(avg(d.morning),2), 0)
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId),
        morning_lowestBooking    = (select pk_dailyBookingId
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId
                                    order by d.morning ASC
                                    LIMIT 1),
        afternoon_highestBooking = (select pk_dailyBookingId
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId
                                    order by d.afternoon Desc
                                    LIMIT 1),
        afternoon_averageBooking = (select COALESCE(round(avg(d.afternoon),2), 0)
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId),
        afternoon_lowestBooking  = (select pk_dailyBookingId
                                    from Days d
                                    where y.pk_yearlybookingid = d.pk_yearlyBookingId
                                    order by d.afternoon ASC
                                    LIMIT 1),
        updatedOn                = current_timestamp
    where year = to_char(CURRENT_DATE, 'YYYY')
      and y.fk_location is not null;
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:20
CREATE OR REPLACE FUNCTION runDailyAnalysisFunctions()
    RETURNS void AS
$$
BEGIN
    PERFORM createDailyAnalysisEntriesForFloors();

    PERFORM createDailyAnalysisEntriesForBuildings();

    PERFORM createDailyAnalysisEntriesForLocations();
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:21
CREATE OR REPLACE FUNCTION runMonthlyAnalysisFunctions()
    RETURNS void AS
$$
BEGIN
    PERFORM createMonthlyAnalysisEntriesForFloors();

    PERFORM createMonthlyAnalysisEntriesForBuildings();

    PERFORM createMonthlyAnalysisEntriesForLocations();
END;
$$
    LANGUAGE plpgsql;

--changeset liquibase:22
CREATE OR REPLACE FUNCTION runQuarterlyAnalysisFunctions()
    RETURNS void AS
$$
BEGIN
    PERFORM runMonthlyAnalysisFunctions();

    PERFORM createQuarterlyAnalysisEntriesForFloors();

    PERFORM createQuarterlyAnalysisEntriesForBuildings();

    PERFORM createQuarterlyAnalysisEntriesForLocations();
END;
$$
    LANGUAGE plpgsql
    PARALLEL UNSAFE ;

--changeset liquibase:22
CREATE OR REPLACE FUNCTION runYearlyAnalysisFunctions()
    RETURNS void AS
$$
BEGIN
    PERFORM runQuarterlyAnalysisFunctions();

    PERFORM createYearlyAnalysisEntriesForFloors();

    PERFORM createYearlyAnalysisEntriesForBuildings();

    PERFORM createYearlyAnalysisEntriesForLocations();
END;
$$
    LANGUAGE plpgsql;