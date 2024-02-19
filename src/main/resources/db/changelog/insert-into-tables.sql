-- liquibase formatted sql

-- changeset liquibase:1
INSERT INTO Roles (roleName)
VALUES ('Standard'),
       ('Admin'),
       ('Super Admin');

-- changeset liquibase:2
INSERT INTO Locations (locationName)
VALUES ('Salzburg'),
       ('Wien'),
       ('Hagenberg');

-- changeset liquibase:3
INSERT INTO Users (username, fk_locationId)
VALUES ('Alina', (SELECT pk_locationId FROM Locations WHERE locationName = 'Salzburg')),
       ('Markus', (SELECT pk_locationId FROM Locations WHERE locationName = 'Wien')),
       ('Jupp', (SELECT pk_locationId FROM Locations WHERE locationName = 'Hagenberg'));

-- changeset liquibase:4
INSERT INTO Roles_Users (pk_fk_roleId, pk_fk_userId)
VALUES ((SELECT pk_roleId FROM Roles WHERE roleName = 'Standard'),
        (SELECT pk_userId FROM Users WHERE username = 'Alina')),
       ((SELECT pk_roleId FROM Roles WHERE roleName = 'Admin'),
        (SELECT pk_userId FROM Users WHERE username = 'Markus')),
       ((SELECT pk_roleId FROM Roles WHERE roleName = 'Super Admin'),
        (SELECT pk_userId FROM Users WHERE username = 'Jupp'));

-- changeset liquibase:5
INSERT INTO Buildings (buildingName, fk_locationId)
VALUES ('A', (SELECT pk_locationId FROM Locations WHERE locationName = 'Salzburg')),
       ('B', (SELECT pk_locationId FROM Locations WHERE locationName = 'Wien')),
       ('C', (SELECT pk_locationId FROM Locations WHERE locationName = 'Hagenberg'));

-- changeset liquibase:6
INSERT INTO Floors (floorName, fk_buildingId)
VALUES ('3', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'A')),
       ('4', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'B')),
       ('5', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'C'));

-- changeset liquibase:7
INSERT INTO Desks (deskNum, x, y, rotation)
VALUES ('301', 10, 10, 0),
       ('401', 20, 20, 0),
       ('402', 25, 20, 0),
       ('403', 30, 20, 0),
       ('404', 35, 20, 0),
       ('405', 40, 20, 0),
       ('406', 45, 20, 0),
       ('407', 50, 20, 0),
       ('408', 55, 20, 0),
       ('501', 15, 15, 0);

-- changeset liquibase:8
INSERT INTO Attributes (attributeName)
VALUES ('Silent'),
       ('Noisy'),
       ('Loud');

-- changeset liquibase:9
INSERT INTO Desks_Attributes (pk_fk_deskId, pk_fk_attributeId)
VALUES ((SELECT pk_deskId FROM Desks WHERE deskNum = '301'),
        (SELECT pk_attributeId FROM Attributes WHERE attributeName = 'Silent')),
       ((SELECT pk_deskId FROM Desks WHERE deskNum = '401'),
        (SELECT pk_attributeId FROM Attributes WHERE attributeName = 'Noisy')),
       ((SELECT pk_deskId FROM Desks WHERE deskNum = '501'),
        (SELECT pk_attributeId FROM Attributes WHERE attributeName = 'Loud'));

-- changeset liquibase:10
INSERT INTO Bookings (bookingNumber, date, isMorning, isAfternoon, fk_userId, fk_deskId)
VALUES ('B123', '2023-08-23', true, false,
        (SELECT pk_userId FROM Users WHERE username = 'Alina'),
        (SELECT pk_deskId FROM Desks WHERE deskNum = '301')),
       ('B124', '2023-08-24', false, true,
        (SELECT pk_userId FROM Users WHERE username = 'Markus'),
        (SELECT pk_deskId FROM Desks WHERE deskNum = '401')),
       ('B125', '2023-08-25', true, true,
        (SELECT pk_userId FROM Users WHERE username = 'Jupp'),
        (SELECT pk_deskId FROM Desks WHERE deskNum = '501'));

-- changeset liquibase:11
INSERT INTO Buildings (buildingName, fk_locationId)
VALUES
    ('D', (SELECT pk_locationId FROM Locations WHERE locationName = 'Salzburg')),
    ('E', (SELECT pk_locationId FROM Locations WHERE locationName = 'Salzburg')),
    ('F', (SELECT pk_locationId FROM Locations WHERE locationName = 'Wien')),
    ('G', (SELECT pk_locationId FROM Locations WHERE locationName = 'Wien')),
    ('H', (SELECT pk_locationId FROM Locations WHERE locationName = 'Hagenberg')),
    ('I', (SELECT pk_locationId FROM Locations WHERE locationName = 'Hagenberg'));

-- changeset liquibase:12
INSERT INTO Floors (floorName, fk_buildingId)
VALUES
    ('65', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'D')),
    ('75', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'D')),
    ('55', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'E')),
    ('60', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'E')),
    ('8', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'F')),
    ('9', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'F')),
    ('50', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'G')),
    ('66', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'G')),
    ('76', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'H')),
    ('86', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'H')),
    ('69', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'I')),
    ('79', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'I'));

-- changeset liquibase:14
-- INSERT INTO Desks (deskNum, x, y, rotation, fk_floorId)
-- SELECT
--         concat(deskNum, '10'),
--         x + 10,
--         y + 10,
--         rotation,
--         (SELECT pk_floorId FROM Floors WHERE floorName = '3')
-- FROM Desks WHERE fk_floorId = (SELECT pk_floorId FROM Floors WHERE floorName = '3')
-- LIMIT 10;

-- changeset liquibase:15
-- INSERT INTO Desks (deskNum, x, y, rotation, fk_floorId)
-- SELECT
--         concat(deskNum, '100'),
--         x + 20,
--         y + 20,
--         rotation,
--         (SELECT pk_floorId FROM Floors WHERE floorName = '4')
-- FROM Desks WHERE fk_floorId = (SELECT pk_floorId FROM Floors WHERE floorName = '4')
-- LIMIT 10;

-- changeset liquibase:16
-- INSERT INTO Desks (deskNum, x, y, rotation, fk_floorId)
-- SELECT
--         concat(deskNum, '200'),
--         x + 15,
--         y + 15,
--         rotation,
--         (SELECT pk_floorId FROM Floors WHERE floorName = '5')
-- FROM Desks WHERE fk_floorId = (SELECT pk_floorId FROM Floors WHERE floorName = '5')
-- LIMIT 10;

-- changeset liquibase:17
-- INSERT INTO Desks (deskNum, x, y, rotation, fk_floorId)
-- SELECT
--         concat(deskNum, '10'),
--         x + 10,
--         y + 10,
--         rotation,
--         (SELECT pk_floorId FROM Floors WHERE floorName = '6')
-- FROM Desks WHERE fk_floorId = (SELECT pk_floorId FROM Floors WHERE floorName = '6')
-- LIMIT 10;

-- changeset liquibase:18
select createEmptyAnalysisEntries();

-- changeset liquibase:19
select createemptymonthlyanalysisentries();

-- changeset liquibase:20
insert into DailyBookings( pk_dailyBookingId, day, morning, afternoon, totalBookings, createdOn, updatedOn, fk_Location, fk_building, fk_floor, fk_monthlyBookingId)
values
    (default, '2023-12-15', 120, 231, 351, default, default, (select pk_locationid from locations where locationname = 'Wien'), null, null, (select pk_monthlyBookingId from monthlybookings where month = '2023-12' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
    (default, '2023-12-16', 94, 42, 136, default, default, (select pk_locationid from locations where locationname = 'Wien'), null, null, (select pk_monthlyBookingId from monthlybookings where month = '2023-12' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
    (default, '2023-12-17', 289, 154, 443, default, default, (select pk_locationid from locations where locationname = 'Wien'), null, null, (select pk_monthlyBookingId from monthlybookings where month = '2023-12' and fk_location = (select pk_locationid from locations where locationname = 'Wien')));
