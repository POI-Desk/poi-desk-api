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
INSERT INTO Desks (deskNum, x, y, rotation, fk_floorId)
VALUES ('301', 10, 10, 0, (SELECT pk_floorId FROM Floors WHERE floorName = '3rd Floor')),
       ('401', 20, 20, 0, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('402', 25, 20, 0, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('403', 30, 20, 0, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('404', 35, 20, 0, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('405', 40, 20, 0, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('406', 45, 20, 0, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('407', 50, 20, 0, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('408', 55, 20, 0, (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')),
       ('501', 15, 15, 0, (SELECT pk_floorId FROM Floors WHERE floorName = '5th Floor'));

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
    ('Building D', (SELECT pk_locationId FROM Locations WHERE locationName = 'Salzburg')),
    ('Building E', (SELECT pk_locationId FROM Locations WHERE locationName = 'Salzburg')),
    ('Building F', (SELECT pk_locationId FROM Locations WHERE locationName = 'Wien')),
    ('Building G', (SELECT pk_locationId FROM Locations WHERE locationName = 'Wien')),
    ('Building H', (SELECT pk_locationId FROM Locations WHERE locationName = 'Hagenberg')),
    ('Building I', (SELECT pk_locationId FROM Locations WHERE locationName = 'Hagenberg'));

-- changeset liquibase:12
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
INSERT INTO Desks (deskNum, x, y, rotation, fk_floorId)
SELECT
        concat(deskNum, '10'),
        x + 10,
        y + 10,
        rotation,
        (SELECT pk_floorId FROM Floors WHERE floorName = '3rd Floor')
FROM Desks WHERE fk_floorId = (SELECT pk_floorId FROM Floors WHERE floorName = '3rd Floor')
LIMIT 10;

-- changeset liquibase:15
INSERT INTO Desks (deskNum, x, y, rotation, fk_floorId)
SELECT
        concat(deskNum, '100'),
        x + 20,
        y + 20,
        rotation,
        (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')
FROM Desks WHERE fk_floorId = (SELECT pk_floorId FROM Floors WHERE floorName = '4th Floor')
LIMIT 10;

-- changeset liquibase:16
INSERT INTO Desks (deskNum, x, y, rotation, fk_floorId)
SELECT
        concat(deskNum, '200'),
        x + 15,
        y + 15,
        rotation,
        (SELECT pk_floorId FROM Floors WHERE floorName = '5th Floor')
FROM Desks WHERE fk_floorId = (SELECT pk_floorId FROM Floors WHERE floorName = '5th Floor')
LIMIT 10;

-- changeset liquibase:17
INSERT INTO Desks (deskNum, x, y, rotation, fk_floorId)
SELECT
        concat(deskNum, '10'),
        x + 10,
        y + 10,
        rotation,
        (SELECT pk_floorId FROM Floors WHERE floorName = '6th Floor')
FROM Desks WHERE fk_floorId = (SELECT pk_floorId FROM Floors WHERE floorName = '6th Floor')
LIMIT 10;

-- changeset liquibase:18
select createEmptyAnalysisEntries();

-- changeset liquibase:19
select createemptymonthlyanalysisentries();

-- changeset liquibase:20
INSERT Into monthlybookings( month, fk_location, amountofdesks, fk_quarterlybookingid) values
    ('2023-10', (select pk_locationid from locations where locationname = 'Wien'), 210, (select pk_quarterlybookingid from quarterlybookings where quarter='Q4' and fk_location = (select pk_locationid from locations where locationname = 'Wien')));

-- changeset liquibase:21
Insert into DailyBookings values
       ('2023-10-1', (select pk_locationid from locations where locationname = 'Wien'), 141 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-2', (select pk_locationid from locations where locationname = 'Wien'), 136 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-3', (select pk_locationid from locations where locationname = 'Wien'), 96 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-4', (select pk_locationid from locations where locationname = 'Wien'), 16 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-5', (select pk_locationid from locations where locationname = 'Wien'), 183 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-6', (select pk_locationid from locations where locationname = 'Wien'), 88 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-7', (select pk_locationid from locations where locationname = 'Wien'), 163 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-8', (select pk_locationid from locations where locationname = 'Wien'), 50 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-9', (select pk_locationid from locations where locationname = 'Wien'), 129 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-10', (select pk_locationid from locations where locationname = 'Wien'), 78 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-11', (select pk_locationid from locations where locationname = 'Wien'), 199 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-12', (select pk_locationid from locations where locationname = 'Wien'), 17 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-13', (select pk_locationid from locations where locationname = 'Wien'), 81 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-14', (select pk_locationid from locations where locationname = 'Wien'), 37 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-15', (select pk_locationid from locations where locationname = 'Wien'), 19 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-16', (select pk_locationid from locations where locationname = 'Wien'), 54 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-17', (select pk_locationid from locations where locationname = 'Wien'), 112 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-18', (select pk_locationid from locations where locationname = 'Wien'), 161 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-19', (select pk_locationid from locations where locationname = 'Wien'), 127 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-20', (select pk_locationid from locations where locationname = 'Wien'), 19 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-21', (select pk_locationid from locations where locationname = 'Wien'), 51 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-22', (select pk_locationid from locations where locationname = 'Wien'), 42 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-23', (select pk_locationid from locations where locationname = 'Wien'), 117 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-24', (select pk_locationid from locations where locationname = 'Wien'), 112 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-25', (select pk_locationid from locations where locationname = 'Wien'), 97 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-26', (select pk_locationid from locations where locationname = 'Wien'), 138 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-27', (select pk_locationid from locations where locationname = 'Wien'), 158 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-28', (select pk_locationid from locations where locationname = 'Wien'), 13 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-29', (select pk_locationid from locations where locationname = 'Wien'), 169 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-10-30', (select pk_locationid from locations where locationname = 'Wien'), 60 , (select pk_monthlybookingid from monthlybookings where month = '2023-10' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-1', (select pk_locationid from locations where locationname = 'Wien'), 47 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-2', (select pk_locationid from locations where locationname = 'Wien'), 117 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-3', (select pk_locationid from locations where locationname = 'Wien'), 149 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-4', (select pk_locationid from locations where locationname = 'Wien'), 67 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-5', (select pk_locationid from locations where locationname = 'Wien'), 197 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-6', (select pk_locationid from locations where locationname = 'Wien'), 159 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-7', (select pk_locationid from locations where locationname = 'Wien'), 148 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-8', (select pk_locationid from locations where locationname = 'Wien'), 78 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-9', (select pk_locationid from locations where locationname = 'Wien'), 79 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-10', (select pk_locationid from locations where locationname = 'Wien'), 102 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-11', (select pk_locationid from locations where locationname = 'Wien'), 93 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-12', (select pk_locationid from locations where locationname = 'Wien'), 28 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-13', (select pk_locationid from locations where locationname = 'Wien'), 67 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-14', (select pk_locationid from locations where locationname = 'Wien'), 13 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-15', (select pk_locationid from locations where locationname = 'Wien'), 159 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-16', (select pk_locationid from locations where locationname = 'Wien'), 146 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-17', (select pk_locationid from locations where locationname = 'Wien'), 94 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-18', (select pk_locationid from locations where locationname = 'Wien'), 43 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-19', (select pk_locationid from locations where locationname = 'Wien'), 78 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-20', (select pk_locationid from locations where locationname = 'Wien'), 83 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-21', (select pk_locationid from locations where locationname = 'Wien'), 67 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-22', (select pk_locationid from locations where locationname = 'Wien'), 47 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-23', (select pk_locationid from locations where locationname = 'Wien'), 42 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-24', (select pk_locationid from locations where locationname = 'Wien'), 37 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-25', (select pk_locationid from locations where locationname = 'Wien'), 154 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-26', (select pk_locationid from locations where locationname = 'Wien'), 109 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-27', (select pk_locationid from locations where locationname = 'Wien'), 28 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-28', (select pk_locationid from locations where locationname = 'Wien'), 184 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-29', (select pk_locationid from locations where locationname = 'Wien'), 120 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien'))),
       ('2023-11-30', (select pk_locationid from locations where locationname = 'Wien'), 54 , (select pk_monthlybookingid from monthlybookings where month = '2023-11' and fk_location = (select pk_locationid from locations where locationname = 'Wien')));

-- changeset liquibase:22
select createmonthanalysisentries();