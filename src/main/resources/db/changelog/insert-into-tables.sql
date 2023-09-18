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
VALUES ('Building A', (SELECT pk_locationId FROM Locations WHERE locationName = 'Salzburg')),
       ('Building B', (SELECT pk_locationId FROM Locations WHERE locationName = 'Wien')),
       ('Building C', (SELECT pk_locationId FROM Locations WHERE locationName = 'Hagenberg'));

-- changeset liquibase:6
INSERT INTO Floors (floorName, fk_buildingId)
VALUES ('3rd Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building A')),
       ('4th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building B')),
       ('5th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building C'));

-- changeset liquibase:7
INSERT INTO Desks (deskNum, x, y, fk_floorId)
VALUES ('301', 10, 10, (SELECT pk_floorId FROM Floors WHERE floorName = '3rd Floor')),
       ('401', 20, 20, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('402', 25, 20, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('403', 30, 20, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('404', 35, 20, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('405', 40, 20, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('406', 45, 20, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('407', 50, 20, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('408', 55, 20, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('501', 15, 15, (SELECT pk_floorId FROM Floors WHERE floorName = '5th Floor'));

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
INSERT INTO BookingsLog (bookingNumber, date, isMorning, isAfternoon, wasDeleted, fk_userId, fk_deskId)
VALUES ('B123', '2023-08-23', true, false, true,
        (SELECT pk_userId FROM Users WHERE username = 'Alina'),
        (SELECT pk_deskId FROM Desks WHERE deskNum = '301')),
       ('B124', '2023-08-24', false, true, false,
        (SELECT pk_userId FROM Users WHERE username = 'Markus'),
        (SELECT pk_deskId FROM Desks WHERE deskNum = '401')),
       ('B125', '2023-08-25', true, true, false,
        (SELECT pk_userId FROM Users WHERE username = 'Jupp'),
        (SELECT pk_deskId FROM Desks WHERE deskNum = '501'));

-- changeset liquibase:12
INSERT INTO Buildings (buildingName, fk_locationId)
VALUES
    ('Building D', (SELECT pk_locationId FROM Locations WHERE locationName = 'Salzburg')),
    ('Building E', (SELECT pk_locationId FROM Locations WHERE locationName = 'Salzburg')),
    ('Building F', (SELECT pk_locationId FROM Locations WHERE locationName = 'Wien')),
    ('Building G', (SELECT pk_locationId FROM Locations WHERE locationName = 'Wien')),
    ('Building H', (SELECT pk_locationId FROM Locations WHERE locationName = 'Hagenberg')),
    ('Building I', (SELECT pk_locationId FROM Locations WHERE locationName = 'Hagenberg'));

-- changeset liquibase:13
INSERT INTO Floors (floorName, fk_buildingId)
VALUES
    ('65th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building D')),
    ('75th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building D')),
    ('55th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building E')),
    ('60th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building E')),
    ('8th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building F')),
    ('9th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building F')),
    ('50th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building G')),
    ('66th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building G')),
    ('76th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building H')),
    ('86th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building H')),
    ('69th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building I')),
    ('79th Floor', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'Building I'));

-- changeset liquibase:14
INSERT INTO Seats (seatNum, x, y, fk_floorId)
SELECT
        seatNum + 10,
        x + 10,
        y + 10,
        (SELECT pk_floorId FROM Floors WHERE floorName = '3rd Floor')
FROM Seats WHERE fk_floorId = (SELECT pk_floorId FROM Floors WHERE floorName = '3rd Floor')
LIMIT 10;

-- changeset liquibase:15
INSERT INTO Seats (seatNum, x, y, fk_floorId)
SELECT
        seatNum + 100,
        x + 20,
        y + 20,
        (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')
FROM Seats WHERE fk_floorId = (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')
LIMIT 10;

-- changeset liquibase:16
INSERT INTO Seats (seatNum, x, y, fk_floorId)
SELECT
        seatNum + 200,
        x + 15,
        y + 15,
        (SELECT pk_floorId FROM Floors WHERE floorName = '5th Floor')
FROM Seats WHERE fk_floorId = (SELECT pk_floorId FROM Floors WHERE floorName = '5th Floor')
LIMIT 10;

-- changeset liquibase:17
INSERT INTO Seats (seatNum, x, y, fk_floorId)
SELECT
        seatNum + 10,
        x + 10,
        y + 10,
        (SELECT pk_floorId FROM Floors WHERE floorName = '6th Floor')
FROM Seats WHERE fk_floorId = (SELECT pk_floorId FROM Floors WHERE floorName = '6th Floor')
LIMIT 10;
