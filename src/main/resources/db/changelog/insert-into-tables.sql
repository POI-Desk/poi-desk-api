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
       ('B', (SELECT pk_locationId FROM Locations WHERE locationName = 'Wien'));

-- changeset liquibase:6
INSERT INTO Floors (floorName, fk_buildingId)
VALUES ('3', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'A')),
       ('4', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'B')),
       ('5', (SELECT pk_buildingId FROM Buildings WHERE buildingName = 'C'));

-- changeset liquibase:7
-- INSERT INTO Desks (deskNum, x, y, rotation)
-- VALUES ('301', 10, 10, 0),
--        ('401', 20, 20, 0),
--        ('402', 25, 20, 0),
--        ('403', 30, 20, 0),
--        ('404', 35, 20, 0),
--        ('405', 40, 20, 0),
--        ('406', 45, 20, 0),
--        ('407', 50, 20, 0),
--        ('408', 55, 20, 0),
--        ('501', 15, 15, 0);

-- changeset liquibase:8
INSERT INTO Attributes (attributeName)
VALUES ('Silent'),
       ('Noisy'),
       ('Loud');

-- changeset liquibase:9
-- INSERT INTO Desks_Attributes (pk_fk_deskId, pk_fk_attributeId)
-- VALUES ((SELECT pk_deskId FROM Desks WHERE deskNum = '301'),
--         (SELECT pk_attributeId FROM Attributes WHERE attributeName = 'Silent')),
--        ((SELECT pk_deskId FROM Desks WHERE deskNum = '401'),
--         (SELECT pk_attributeId FROM Attributes WHERE attributeName = 'Noisy')),
--        ((SELECT pk_deskId FROM Desks WHERE deskNum = '501'),
--         (SELECT pk_attributeId FROM Attributes WHERE attributeName = 'Loud'));

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
select createemptyyearlyanalysisentries();
-- changeset liquibase:19
select createemptyquarterlyanalysisentries();
-- changeset liquibase:20
select createemptymonthlyanalysisentries();
-- changeset liquibase:24
insert into MonthlyBookings(month, fk_Location, fk_quarterlyBookingId)
SELECT to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY-MM'),
       l.pk_locationid,
       (select q.pk_quarterlyBookingId
        from QuarterlyBookings q
        where q.fk_location = l.pk_locationid
          and year = to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY')
          and q.quarter = getcurrentquarter())
from locations l;
-- changeset liquibase:25
insert into MonthlyBookings(month, fk_building, fk_quarterlyBookingId)
SELECT to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY-MM'),
       b.pk_buildingid,
       (select q.pk_quarterlyBookingId
        from QuarterlyBookings q
        where q.fk_building = b.pk_buildingid
          and year = to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY')
          and q.quarter = getcurrentquarter())
from buildings b;
-- changeset liquibase:26
insert into MonthlyBookings(month, fk_floor, fk_quarterlyBookingId)
SELECT to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY-MM'),
       f.pk_floorid,
       (select q.pk_quarterlyBookingId
        from QuarterlyBookings q
        where q.fk_floor = f.pk_floorid
          and year = to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY')
          and q.quarter = getcurrentquarter())
from floors f;
-- changeset liquibase:27
insert into dailybookings(day, morning, afternoon, total, fk_floor, fk_monthlybookingid) values
('2024-03-01', 157, 128, 285, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-02', 42, 80, 122, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-03', 157, 184, 341, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-04', 82, 177, 259, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-05', 30, 38, 68, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-06', 106, 68, 174, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-07', 52, 103, 155, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-08', 61, 86, 147, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-09', 43, 175, 218, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-10', 109, 69, 178, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-11', 110, 184, 294, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-12', 160, 107, 267, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-13', 111, 99, 210, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-14', 157, 120, 277, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-15', 85, 39, 124, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-16', 182, 162, 344, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-17', 144, 99, 243, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-18', 149, 144, 293, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-19', 154, 89, 243, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-20', 49, 117, 166, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-21', 123, 59, 182, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-22', 84, 23, 107, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-23', 90, 101, 191, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-24', 116, 124, 240, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-25', 126, 113, 239, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-26', 189, 125, 314, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-27', 158, 9, 167, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-28', 44, 51, 95, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-29', 79, 184, 263, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-03-30', 160, 149, 309, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-03')),
('2024-04-01', 71, 140, 211, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-02', 88, 155, 243, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-03', 98, 114, 212, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-04', 143, 11, 154, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-05', 127, 169, 296, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-06', 109, 47, 156, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-07', 147, 68, 215, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-08', 23, 44, 67, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-09', 133, 82, 215, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-10', 40, 87, 127, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-11', 162, 33, 195, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-12', 74, 28, 102, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-13', 168, 111, 279, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-14', 183, 117, 300, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-15', 50, 70, 120, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-16', 46, 181, 227, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-17', 83, 69, 152, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-18', 114, 72, 186, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-19', 105, 102, 207, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-20', 176, 127, 303, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-21', 55, 184, 239, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-22', 174, 106, 280, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-23', 113, 168, 281, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-24', 65, 106, 171, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-25', 179, 152, 331, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-26', 126, 147, 273, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-27', 177, 110, 287, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-28', 68, 40, 108, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-29', 38, 160, 198, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-30', 113, 154, 267, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-03-01', 16, 78, 94, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-02', 118, 160, 278, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-03', 161, 163, 324, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-04', 40, 46, 86, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-05', 55, 100, 155, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-06', 111, 99, 210, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-07', 129, 108, 237, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-08', 134, 112, 246, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-09', 154, 72, 226, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-10', 60, 120, 180, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-11', 192, 144, 336, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-12', 185, 58, 243, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-13', 83, 55, 138, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-14', 157, 162, 319, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-15', 139, 31, 170, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-16', 113, 45, 158, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-17', 145, 44, 189, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-18', 146, 111, 257, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-19', 18, 135, 153, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-20', 59, 92, 151, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-21', 16, 69, 85, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-22', 30, 72, 102, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-23', 162, 140, 302, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-24', 192, 94, 286, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-25', 78, 41, 119, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-26', 73, 56, 129, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-27', 118, 90, 208, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-28', 37, 139, 176, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-29', 86, 174, 260, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-03-30', 48, 91, 139, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-03')),
('2024-04-01', 150, 172, 322, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-02', 188, 65, 253, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-03', 153, 87, 240, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-04', 18, 176, 194, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-05', 77, 26, 103, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-06', 25, 10, 35, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-07', 163, 33, 196, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-08', 76, 99, 175, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-09', 138, 139, 277, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-10', 131, 118, 249, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-11', 180, 52, 232, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-12', 76, 118, 194, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-13', 146, 151, 297, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-14', 162, 23, 185, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-15', 146, 33, 179, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-16', 133, 122, 255, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-17', 99, 94, 193, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-18', 115, 109, 224, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-19', 59, 168, 227, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-20', 187, 121, 308, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-21', 22, 137, 159, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-22', 147, 28, 175, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-23', 40, 57, 97, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-24', 105, 179, 284, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-25', 35, 134, 169, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-26', 140, 159, 299, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-27', 111, 135, 246, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-28', 131, 135, 266, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-29', 81, 121, 202, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-30', 133, 7, 140, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-03-01', 39, 14, 53, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-02', 19, 92, 111, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-03', 46, 19, 65, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-04', 145, 44, 189, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-05', 92, 23, 115, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-06', 89, 78, 167, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-07', 21, 140, 161, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-08', 63, 24, 87, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-09', 84, 138, 222, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-10', 143, 94, 237, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-11', 99, 140, 239, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-12', 178, 162, 340, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-13', 138, 170, 308, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-14', 142, 51, 193, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-15', 60, 79, 139, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-16', 38, 28, 66, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-17', 64, 157, 221, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-18', 187, 136, 323, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-19', 190, 167, 357, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-20', 115, 88, 203, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-21', 124, 160, 284, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-22', 63, 40, 103, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-23', 191, 149, 340, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-24', 98, 59, 157, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-25', 101, 38, 139, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-26', 17, 137, 154, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-27', 134, 10, 144, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-28', 107, 167, 274, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-29', 166, 138, 304, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-03-30', 36, 34, 70, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-03')),
('2024-04-01', 23, 69, 92, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-02', 136, 106, 242, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-03', 84, 7, 91, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-04', 49, 143, 192, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-05', 116, 110, 226, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-06', 175, 76, 251, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-07', 115, 23, 138, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-08', 187, 86, 273, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-09', 114, 127, 241, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-10', 33, 17, 50, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-11', 141, 118, 259, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-12', 121, 182, 303, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-13', 36, 135, 171, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-14', 112, 151, 263, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-15', 166, 180, 346, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-16', 71, 25, 96, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-17', 177, 167, 344, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-18', 166, 13, 179, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-19', 44, 92, 136, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-20', 108, 111, 219, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-21', 70, 95, 165, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-22', 84, 106, 190, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-23', 161, 109, 270, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-24', 79, 161, 240, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-25', 133, 120, 253, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-26', 102, 99, 201, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-27', 39, 169, 208, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-28', 171, 175, 346, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-29', 77, 62, 139, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-30', 27, 131, 158, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-03-01', 14, 110, 124, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-02', 73, 115, 188, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-03', 99, 116, 215, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-04', 158, 177, 335, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-05', 143, 150, 293, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-06', 64, 32, 96, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-07', 159, 156, 315, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-08', 62, 98, 160, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-09', 189, 147, 336, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-10', 31, 160, 191, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-11', 174, 159, 333, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-12', 89, 31, 120, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-13', 43, 72, 115, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-14', 22, 149, 171, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-15', 26, 34, 60, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-16', 166, 112, 278, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-17', 105, 72, 177, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-18', 137, 147, 284, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-19', 186, 159, 345, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-20', 83, 65, 148, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-21', 45, 173, 218, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-22', 110, 84, 194, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-23', 112, 123, 235, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-24', 141, 78, 219, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-25', 19, 119, 138, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-26', 20, 66, 86, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-27', 68, 62, 130, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-28', 115, 77, 192, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-29', 59, 95, 154, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-03-30', 97, 160, 257, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-03')),
('2024-04-01', 105, 54, 159, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-02', 102, 79, 181, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-03', 111, 28, 139, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-04', 166, 168, 334, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-05', 112, 122, 234, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-06', 129, 181, 310, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-07', 64, 93, 157, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-08', 14, 98, 112, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-09', 171, 178, 349, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-10', 62, 61, 123, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-11', 170, 23, 193, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-12', 91, 87, 178, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-13', 112, 77, 189, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-14', 154, 24, 178, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-15', 116, 183, 299, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-16', 52, 154, 206, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-17', 125, 24, 149, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-18', 182, 10, 192, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-19', 111, 18, 129, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-20', 132, 9, 141, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-21', 129, 124, 253, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-22', 17, 49, 66, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-23', 130, 8, 138, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-24', 181, 64, 245, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-25', 135, 173, 308, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-26', 130, 172, 302, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-27', 45, 115, 160, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-28', 95, 54, 149, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-29', 27, 25, 52, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-30', 131, 60, 191, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-03-01', 39, 135, 174, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-02', 127, 116, 243, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-03', 82, 58, 140, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-04', 95, 60, 155, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-05', 74, 19, 93, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-06', 18, 100, 118, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-07', 113, 150, 263, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-08', 17, 96, 113, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-09', 44, 115, 159, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-10', 101, 141, 242, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-11', 121, 91, 212, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-12', 131, 16, 147, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-13', 88, 15, 103, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-14', 69, 115, 184, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-15', 47, 140, 187, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-16', 149, 163, 312, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-17', 50, 92, 142, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-18', 91, 111, 202, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-19', 127, 109, 236, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-20', 162, 40, 202, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-21', 166, 81, 247, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-22', 174, 174, 348, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-23', 112, 158, 270, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-24', 149, 168, 317, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-25', 16, 166, 182, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-26', 191, 149, 340, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-27', 81, 116, 197, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-28', 82, 150, 232, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-29', 39, 121, 160, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-03-30', 151, 109, 260, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-03')),
('2024-04-01', 61, 179, 240, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-02', 42, 104, 146, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-03', 88, 87, 175, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-04', 43, 42, 85, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-05', 164, 80, 244, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-06', 66, 160, 226, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-07', 29, 177, 206, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-08', 177, 110, 287, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-09', 170, 151, 321, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-10', 95, 27, 122, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-11', 95, 30, 125, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-12', 35, 22, 57, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-13', 101, 59, 160, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-14', 151, 123, 274, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-15', 93, 12, 105, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-16', 61, 133, 194, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-17', 170, 99, 269, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-18', 87, 151, 238, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-19', 104, 117, 221, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-20', 180, 152, 332, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-21', 16, 64, 80, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-22', 184, 119, 303, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04'));


-- changeset liquibase:28
select createMonthlyAnalysisEntriesForFloors();
-- changeset liquibase:29
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
WHERE d.fk_floor IS NOT NULL
GROUP BY f.fk_buildingid, day;
-- changeset liquibase:30
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
WHERE d.fk_building IS NOT NULL
GROUP BY b.fk_locationid, day;
-- changeset liquibase:31
With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, d.fk_monthlybookingid
              from dailybookings d
              where d.fk_floor is not null
                and Left(d.day, 7) = to_char(CURRENT_DATE  - INTERVAL '1 month', 'YYYY-MM'))

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
where month = to_char(CURRENT_DATE  - INTERVAL '1 month', 'YYYY-MM')
  and m.fk_floor is not null;

-- changeset liquibase:32
With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, d.fk_monthlybookingid
              from dailybookings d
              where d.fk_building is not null
                and Left(d.day, 7) = to_char(CURRENT_DATE  - INTERVAL '1 month', 'YYYY-MM'))

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
where month = to_char(CURRENT_DATE  - INTERVAL '1 month', 'YYYY-MM')
  and m.fk_building is not null;

-- changeset liquibase:33
With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, d.fk_monthlybookingid
              from dailybookings d
              where d.fk_location is not null
                and Left(d.day, 7) = to_char(CURRENT_DATE  - INTERVAL '1 month', 'YYYY-MM'))

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
where month = to_char(CURRENT_DATE  - INTERVAL '1 month', 'YYYY-MM')
  and m.fk_location is not null;

-- changeset liquibase:34
select runYearlyAnalysisFunctions();