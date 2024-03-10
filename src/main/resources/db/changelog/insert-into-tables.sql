-- liquibase formatted sql

-- changeset liquibase:1
INSERT INTO Roles (roleName)
VALUES ('Standard'),
       ('Extended'),
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

-- changeset liquibase:11
INSERT INTO Buildings (buildingName, fk_locationId)
VALUES ('D', (SELECT pk_locationId FROM Locations WHERE locationName = 'Salzburg')),
       ('E', (SELECT pk_locationId FROM Locations WHERE locationName = 'Salzburg')),
       ('F', (SELECT pk_locationId FROM Locations WHERE locationName = 'Wien')),
       ('G', (SELECT pk_locationId FROM Locations WHERE locationName = 'Wien')),
       ('H', (SELECT pk_locationId FROM Locations WHERE locationName = 'Hagenberg')),
       ('I', (SELECT pk_locationId FROM Locations WHERE locationName = 'Hagenberg'));

-- changeset liquibase:12
INSERT INTO Floors (floorName, fk_buildingId)
VALUES ('65', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'D')),
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
select createemptyyearlyanalysisentries();
-- changeset liquibase:19
select createemptyquarterlyanalysisentries();
-- changeset liquibase:20
select createemptymonthlyanalysisentries();
-- changeset liquibase:21
insert into MonthlyBookings(month, fk_Location, fk_quarterlyBookingId)
SELECT to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY-MM'),
       l.pk_locationid,
       (select q.pk_quarterlyBookingId
        from QuarterlyBookings q
        where q.fk_location = l.pk_locationid
          and year = to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY')
          and q.quarter = getcurrentquarter())
from locations l;
-- changeset liquibase:22
insert into MonthlyBookings(month, fk_building, fk_quarterlyBookingId)
SELECT to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY-MM'),
       b.pk_buildingid,
       (select q.pk_quarterlyBookingId
        from QuarterlyBookings q
        where q.fk_building = b.pk_buildingid
          and year = to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY')
          and q.quarter = getcurrentquarter())
from buildings b;
-- changeset liquibase:23
insert into MonthlyBookings(month, fk_floor, fk_quarterlyBookingId)
SELECT to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY-MM'),
       f.pk_floorid,
       (select q.pk_quarterlyBookingId
        from QuarterlyBookings q
        where q.fk_floor = f.pk_floorid
          and year = to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY')
          and q.quarter = getcurrentquarter())
from floors f;
-- changeset liquibase:24
insert into dailybookings(day, morning, afternoon, total, fk_floor, fk_monthlybookingid)
values ('2024-01-01', 73, 60, 133, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-02', 76, 98, 174, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-03', 81, 107, 188, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-04', 50, 42, 92, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-05', 35, 87, 122, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-06', 98, 84, 182, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-07', 103, 101, 204, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-08', 54, 44, 98, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-09', 70, 106, 176, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-10', 73, 39, 112, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-11', 26, 57, 83, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-12', 91, 55, 146, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-13', 44, 82, 126, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-14', 68, 119, 187, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-15', 101, 124, 225, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-16', 38, 78, 116, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-17', 66, 112, 178, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-18', 37, 94, 131, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-19', 105, 94, 199, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-20', 97, 115, 212, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-21', 43, 110, 153, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-22', 53, 93, 146, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-23', 72, 103, 175, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-24', 34, 47, 81, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-25', 69, 60, 129, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-26', 65, 90, 155, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-27', 54, 84, 138, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-28', 39, 106, 145, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-29', 99, 53, 152, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-01-30', 79, 36, 115, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-01')),
       ('2024-02-01', 98, 89, 187, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-02', 38, 104, 142, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-03', 77, 92, 169, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-04', 66, 62, 128, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-05', 51, 97, 148, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-06', 104, 40, 144, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-07', 61, 117, 178, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-08', 78, 67, 145, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-09', 53, 67, 120, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-10', 75, 84, 159, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-11', 107, 81, 188, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-12', 59, 83, 142, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-13', 30, 48, 78, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-14', 59, 117, 176, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-15', 47, 108, 155, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-16', 57, 49, 106, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-17', 89, 81, 170, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-18', 42, 55, 97, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-19', 61, 46, 107, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-20', 112, 89, 201, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-21', 39, 44, 83, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-22', 54, 55, 109, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-23', 108, 80, 188, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-24', 68, 105, 173, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-25', 41, 94, 135, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-26', 43, 87, 130, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-02-27', 35, 87, 122, (select f.pk_floorid from floors f where f.floorname = '4'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4')
           and month = '2024-02')),
       ('2024-01-01', 52, 92, 144, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-02', 89, 39, 128, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-03', 41, 61, 102, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-04', 82, 91, 173, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-05', 97, 63, 160, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-06', 47, 51, 98, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-07', 64, 113, 177, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-08', 70, 86, 156, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-09', 26, 95, 121, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-10', 49, 48, 97, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-11', 31, 64, 95, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-12', 71, 59, 130, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-13', 96, 97, 193, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-14', 81, 49, 130, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-15', 73, 124, 197, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-16', 84, 67, 151, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-17', 85, 62, 147, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-18', 101, 53, 154, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-19', 79, 43, 122, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-20', 36, 66, 102, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-21', 68, 110, 178, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-22', 84, 82, 166, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-23', 66, 112, 178, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-24', 87, 106, 193, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-25', 72, 50, 122, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-26', 97, 65, 162, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-27', 88, 35, 123, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-28', 56, 83, 139, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-29', 112, 44, 156, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-01-30', 103, 118, 221, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-01')),
       ('2024-02-01', 86, 98, 184, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-02', 67, 37, 104, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-03', 81, 92, 173, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-04', 87, 56, 143, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-05', 29, 117, 146, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-06', 82, 63, 145, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-07', 103, 50, 153, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-08', 74, 39, 113, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-09', 60, 35, 95, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-10', 58, 79, 137, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-11', 82, 90, 172, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-12', 91, 65, 156, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-13', 45, 31, 76, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-14', 79, 103, 182, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-15', 84, 77, 161, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-16', 63, 34, 97, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-17', 26, 121, 147, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-18', 67, 30, 97, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-19', 98, 112, 210, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-20', 86, 111, 197, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-21', 62, 111, 173, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-22', 69, 112, 181, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-23', 46, 73, 119, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-24', 70, 108, 178, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-25', 89, 58, 147, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-26', 84, 103, 187, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-02-27', 65, 39, 104, (select f.pk_floorid from floors f where f.floorname = '8'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8')
           and month = '2024-02')),
       ('2024-01-01', 62, 40, 102, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-02', 84, 76, 160, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-03', 58, 49, 107, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-04', 63, 98, 161, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-05', 61, 76, 137, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-06', 63, 75, 138, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-07', 31, 88, 119, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-08', 72, 90, 162, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-09', 45, 78, 123, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-10', 93, 106, 199, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-11', 79, 100, 179, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-12', 43, 86, 129, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-13', 91, 56, 147, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-14', 69, 70, 139, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-15', 89, 67, 156, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-16', 63, 108, 171, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-17', 101, 54, 155, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-18', 100, 117, 217, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-19', 85, 99, 184, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-20', 113, 124, 237, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-21', 56, 66, 122, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-22', 37, 45, 82, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-23', 35, 86, 121, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-24', 54, 52, 106, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-25', 35, 84, 119, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-26', 63, 38, 101, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-27', 106, 109, 215, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-28', 55, 32, 87, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-29', 29, 97, 126, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-01-30', 88, 101, 189, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-01')),
       ('2024-02-01', 60, 97, 157, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-02', 97, 101, 198, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-03', 96, 112, 208, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-04', 104, 42, 146, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-05', 27, 44, 71, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-06', 60, 54, 114, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-07', 66, 115, 181, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-08', 37, 58, 95, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-09', 70, 99, 169, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-10', 70, 101, 171, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-11', 90, 95, 185, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-12', 96, 32, 128, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-13', 38, 71, 109, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-14', 45, 38, 83, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-15', 108, 53, 161, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-16', 44, 99, 143, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-17', 96, 95, 191, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-18', 33, 38, 71, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-19', 42, 116, 158, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-20', 54, 74, 128, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-21', 55, 60, 115, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-22', 42, 55, 97, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-23', 34, 39, 73, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-24', 96, 124, 220, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-25', 110, 62, 172, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-26', 107, 94, 201, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-02-27', 75, 110, 185, (select f.pk_floorid from floors f where f.floorname = '9'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9')
           and month = '2024-02')),
       ('2024-01-01', 78, 67, 145, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-02', 44, 96, 140, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-03', 27, 120, 147, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-04', 102, 36, 138, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-05', 94, 89, 183, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-06', 88, 108, 196, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-07', 73, 36, 109, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-08', 86, 100, 186, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-09', 39, 64, 103, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-10', 49, 119, 168, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-11', 41, 113, 154, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-12', 43, 123, 166, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-13', 93, 96, 189, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-14', 65, 116, 181, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-15', 75, 119, 194, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-16', 79, 120, 199, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-17', 75, 89, 164, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-18', 85, 42, 127, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-19', 80, 41, 121, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-20', 37, 80, 117, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-21', 87, 107, 194, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-22', 43, 118, 161, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-23', 78, 86, 164, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-24', 25, 112, 137, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-25', 85, 72, 157, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-26', 84, 88, 172, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-27', 73, 113, 186, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-28', 75, 65, 140, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-29', 85, 68, 153, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-01-30', 87, 75, 162, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-01')),
       ('2024-02-01', 73, 90, 163, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-02', 31, 57, 88, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-03', 94, 94, 188, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-04', 73, 108, 181, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-05', 93, 97, 190, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-06', 80, 75, 155, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-07', 106, 75, 181, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-08', 54, 105, 159, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-09', 47, 123, 170, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-10', 27, 36, 63, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-11', 25, 82, 107, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-12', 83, 79, 162, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-13', 58, 73, 131, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-14', 113, 70, 183, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-15', 25, 91, 116, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-16', 41, 110, 151, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-17', 75, 92, 167, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-18', 71, 121, 192, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-19', 98, 32, 130, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-20', 84, 54, 138, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-21', 80, 77, 157, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-22', 70, 122, 192, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-23', 77, 92, 169, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-24', 54, 103, 157, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-25', 95, 51, 146, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-26', 89, 95, 184, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-02-27', 71, 51, 122, (select f.pk_floorid from floors f where f.floorname = '50'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50')
           and month = '2024-02')),
       ('2024-01-01', 102, 60, 162, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-02', 104, 94, 198, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-03', 45, 118, 163, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-04', 92, 84, 176, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-05', 87, 85, 172, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-06', 102, 91, 193, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-07', 105, 63, 168, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-08', 58, 62, 120, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-09', 57, 46, 103, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-10', 112, 97, 209, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-11', 71, 101, 172, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-12', 74, 81, 155, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-13', 55, 46, 101, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-14', 38, 82, 120, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-15', 52, 77, 129, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-16', 33, 33, 66, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-17', 30, 42, 72, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-18', 32, 53, 85, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-19', 49, 111, 160, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-20', 57, 73, 130, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-21', 52, 42, 94, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-22', 101, 57, 158, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-23', 43, 63, 106, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-24', 52, 70, 122, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-25', 81, 36, 117, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-26', 28, 60, 88, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-27', 71, 45, 116, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-28', 85, 77, 162, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-29', 53, 112, 165, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-01-30', 64, 47, 111, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-01')),
       ('2024-02-01', 51, 64, 115, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-02', 61, 39, 100, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-03', 89, 115, 204, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-04', 56, 68, 124, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-05', 72, 102, 174, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-06', 111, 60, 171, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-07', 62, 37, 99, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-08', 62, 30, 92, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-09', 45, 94, 139, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-10', 60, 58, 118, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-11', 78, 63, 141, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-12', 42, 90, 132, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-13', 94, 113, 207, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-14', 36, 47, 83, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-15', 98, 66, 164, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-16', 52, 77, 129, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-17', 33, 103, 136, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-18', 98, 106, 204, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-19', 51, 61, 112, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-20', 25, 43, 68, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-21', 61, 108, 169, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-22', 74, 53, 127, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-23', 78, 96, 174, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-24', 65, 93, 158, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-25', 71, 73, 144, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-26', 98, 92, 190, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02')),
       ('2024-02-27', 47, 33, 80, (select f.pk_floorid from floors f where f.floorname = '66'),
        (select m.pk_monthlybookingid
         from monthlybookings m
         where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66')
           and month = '2024-02'));
-- changeset liquibase:25
select createdailyanalysisentriesforbuildings(),
       createdailyanalysisentriesforlocations(),
       createmonthlyanalysisentriesforfloors(),
       createmonthlyanalysisentriesforbuilding(),
       createmonthlyanalysisentriesforlocation(),
       createquarterlyanalysisentriesforfloors(),
       createquarterlyanalysisentriesforbuilding(),
       createquarterlyanalysisentriesforlocation(),
       createyearlyanalysisentriesforfloors(),
       createyearanalysisentriesforbuilding(),
       createyearanalysisentriesforlocation();
