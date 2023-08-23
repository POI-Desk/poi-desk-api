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
INSERT INTO Seats (seatNum, x, y, fk_floorId)
VALUES (301, 10, 10, (SELECT pk_floorId FROM Floors WHERE floorName = '3rd Floor')),
       (401, 20, 20, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       (501, 15, 15, (SELECT pk_floorId FROM Floors WHERE floorName = '5th Floor'));

-- changeset liquibase:8
INSERT INTO Attributes (attributeName)
VALUES ('Silent'),
       ('Noisy'),
       ('Loud');

-- changeset liquibase:9
INSERT INTO Seats_Attributes (pk_fk_seatId, pk_fk_attributeId)
VALUES ((SELECT pk_seatId FROM Seats WHERE seatNum = 301),
        (SELECT pk_attributeId FROM Attributes WHERE attributeName = 'Silent')),
       ((SELECT pk_seatId FROM Seats WHERE seatNum = 401),
        (SELECT pk_attributeId FROM Attributes WHERE attributeName = 'Noisy')),
       ((SELECT pk_seatId FROM Seats WHERE seatNum = 501),
        (SELECT pk_attributeId FROM Attributes WHERE attributeName = 'Loud'));

-- changeset liquibase:10
INSERT INTO Bookings (bookingNumber, date, isMorning, isAfternoon, fk_userId, fk_seatId)
VALUES ('B123', '2023-08-23', true, false,
        (SELECT pk_userId FROM Users WHERE username = 'Alina'),
        (SELECT pk_seatId FROM Seats WHERE seatNum = 101)),
       ('B124', '2023-08-24', false, true,
        (SELECT pk_userId FROM Users WHERE username = 'Markus'),
        (SELECT pk_seatId FROM Seats WHERE seatNum = 202)),
       ('B125', '2023-08-25', true, true,
        (SELECT pk_userId FROM Users WHERE username = 'Jupp'),
        (SELECT pk_seatId FROM Seats WHERE seatNum = 103));

-- changeset liquibase:11
INSERT INTO BookingsLog (bookingNumber, date, isMorning, isAfternoon, fk_userId, fk_seatId)
VALUES ('B123', '2023-08-23', true, false,
        (SELECT pk_userId FROM Users WHERE username = 'Alina'),
        (SELECT pk_seatId FROM Seats WHERE seatNum = 101)),
       ('B124', '2023-08-24', false, true,
        (SELECT pk_userId FROM Users WHERE username = 'Markus'),
        (SELECT pk_seatId FROM Seats WHERE seatNum = 202)),
       ('B125', '2023-08-25', true, true,
        (SELECT pk_userId FROM Users WHERE username = 'Jupp'),
        (SELECT pk_seatId FROM Seats WHERE seatNum = 103));

