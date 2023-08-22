-- liquibase formatted sql

-- changeset liquibase:1
INSERT INTO  Roles (pk_roleId, description)
VALUES (gen_random_uuid(), 'Admin'),
       (gen_random_uuid(), 'Markus'),
       (gen_random_uuid(), 'Jupp')

-- changeset liquibase:2
INSERT INTO  Users (pk_userId, username)
VALUES (gen_random_uuid(), 'Admin'),
       (gen_random_uuid(), 'Markus'),
       (gen_random_uuid(), 'Jupp')

-- changeset liquibase:3
INSERT INTO Role_User (pk_fk_roleId, pk_fk_userId)
VALUES ((SELECT pk_roleId FROM Roles WHERE description = 'Admin'),
        (SELECT pk_userId FROM Users WHERE username = 'Admin')),
       ((SELECT pk_roleId FROM Roles WHERE description = 'Markus'),
        (SELECT pk_userId FROM Users WHERE username = 'Markus')),
       ((SELECT pk_roleId FROM Roles WHERE description = 'Jupp'),
        (SELECT pk_userId FROM Users WHERE username = 'Jupp'))

-- changeset liquibase:4
INSERT INTO Locations (pk_locationId, locationName)
VALUES (gen_random_uuid(), 'Salzburg'),
       (gen_random_uuid(), 'Wien'),
       (gen_random_uuid(), 'Hagenberg')

-- changeset liquibase:5
INSERT INTO  Seats (pk_seatId, floor, seatNum, x, y, fk_locationId)
VALUES (gen_random_uuid(), 1, 101, 10.0, 20.0,
        (SELECT pk_locationId FROM  Locations WHERE locationName = 'Salzburg')),
       (gen_random_uuid(), 2, 201, 15.0, 25.0,
        (SELECT pk_locationId FROM  Locations WHERE locationName = 'Wien')),
       (gen_random_uuid(), 3, 301, 20.0, 30.0,
        (SELECT pk_locationId FROM  Locations WHERE locationName = 'Hagenberg'))

-- changeset liquibase:6
INSERT INTO  Attributes (pk_attributeId, description, color)
VALUES (gen_random_uuid(), 'Attribute 1', 'Red'),
       (gen_random_uuid(), 'Attribute 2', 'Blue'),
       (gen_random_uuid(), 'Attribute 3', 'Green')

-- changeset liquibase:7
INSERT INTO  Seat_Attribute (pk_fk_seatId, pk_fk_attributeId)
VALUES ((SELECT pk_seatId FROM  Seats WHERE seatNum = 101),
        (SELECT pk_attributeId FROM  Attributes WHERE description = 'Attribute 1')),
       ((SELECT pk_seatId FROM  Seats WHERE seatNum = 201),
        (SELECT pk_attributeId FROM  Attributes WHERE description = 'Attribute 2')),
       ((SELECT pk_seatId FROM  Seats WHERE seatNum = 301),
        (SELECT pk_attributeId FROM  Attributes WHERE description = 'Attribute 3'))

-- changeset liquibase:8
INSERT INTO  Intervals (pk_intervalId, description)
VALUES (gen_random_uuid(), 'Morning'),
       (gen_random_uuid(), 'Afternoon'),
       (gen_random_uuid(), 'Full Day')

-- changeset liquibase:9
INSERT INTO  Bookings (pk_bookingId, bookingNumber, fk_userId, fk_seatId, fk_intervalId)
VALUES (gen_random_uuid(), 123, (SELECT pk_userId FROM  Users WHERE username = 'Admin'),
        (SELECT pk_seatId FROM  Seats WHERE seatNum = 101),
        (SELECT pk_intervalId FROM  Intervals WHERE description = 'Morning')),
       (gen_random_uuid(), 456, (SELECT pk_userId FROM  Users WHERE username = 'Markus'),
        (SELECT pk_seatId FROM  Seats WHERE seatNum = 201),
        (SELECT pk_intervalId FROM  Intervals WHERE description = 'Afternoon')),
       (gen_random_uuid(), 789, (SELECT pk_userId FROM  Users WHERE username = 'Jupp'),
        (SELECT pk_seatId FROM  Seats WHERE seatNum = 301),
        (SELECT pk_intervalId FROM  Intervals WHERE description = 'Full Day'))