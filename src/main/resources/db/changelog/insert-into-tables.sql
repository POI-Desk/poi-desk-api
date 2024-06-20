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
INSERT INTO Users (username, password)
VALUES ('admin', '$argon2id$v=19$m=16384,t=2,p=1$AkRjz6sebXLjD6+dtf6rRw$nMiqJ9CTpHHV2DB8n7kEcQD91Iif66IwmlzT018BIX8');

-- changeset liquibase:4
INSERT INTO Roles_Users (pk_fk_roleId, pk_fk_userId)
VALUES ((SELECT pk_roleId FROM Roles WHERE roleName = 'Standard'),
        (SELECT pk_userId FROM Users WHERE username = 'admin')),
       ((SELECT pk_roleId FROM Roles WHERE roleName = 'Admin'),
        (SELECT pk_userId FROM Users WHERE username = 'admin')),
       ((SELECT pk_roleId FROM Roles WHERE roleName = 'Super Admin'),
        (SELECT pk_userId FROM Users WHERE username = 'admin'));

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
-- changeset liquibase:23
insert into MonthlyBookings(month, fk_Location, fk_quarterlyBookingId)
SELECT to_char((CURRENT_DATE - INTERVAL '2 month'), 'YYYY-MM'),
       l.pk_locationid,
       (select q.pk_quarterlyBookingId
        from QuarterlyBookings q
        where q.fk_location = l.pk_locationid
          and year = to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY')
          and q.quarter = getcurrentquarter())
from locations l;
-- changeset liquibase:24
insert into MonthlyBookings(month, fk_building, fk_quarterlyBookingId)
SELECT to_char((CURRENT_DATE - INTERVAL '2 month'), 'YYYY-MM'),
       b.pk_buildingid,
       (select q.pk_quarterlyBookingId
        from QuarterlyBookings q
        where q.fk_building = b.pk_buildingid
          and year = to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY')
          and q.quarter = getcurrentquarter())
from buildings b;
-- changeset liquibase:25
insert into MonthlyBookings(month, fk_floor, fk_quarterlyBookingId)
SELECT to_char((CURRENT_DATE - INTERVAL '2 month'), 'YYYY-MM'),
       f.pk_floorid,
       (select q.pk_quarterlyBookingId
        from QuarterlyBookings q
        where q.fk_floor = f.pk_floorid
          and year = to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY')
          and q.quarter = getcurrentquarter())
from floors f;


-- changeset liquibase:26
insert into MonthlyBookings(month, fk_Location, fk_quarterlyBookingId)
SELECT to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY-MM'),
       l.pk_locationid,
       (select q.pk_quarterlyBookingId
        from QuarterlyBookings q
        where q.fk_location = l.pk_locationid
          and year = to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY')
          and q.quarter = getcurrentquarter())
from locations l;
-- changeset liquibase:27
insert into MonthlyBookings(month, fk_building, fk_quarterlyBookingId)
SELECT to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY-MM'),
       b.pk_buildingid,
       (select q.pk_quarterlyBookingId
        from QuarterlyBookings q
        where q.fk_building = b.pk_buildingid
          and year = to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY')
          and q.quarter = getcurrentquarter())
from buildings b;
-- changeset liquibase:28
insert into MonthlyBookings(month, fk_floor, fk_quarterlyBookingId)
SELECT to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY-MM'),
       f.pk_floorid,
       (select q.pk_quarterlyBookingId
        from QuarterlyBookings q
        where q.fk_floor = f.pk_floorid
          and year = to_char((CURRENT_DATE - INTERVAL '1 month'), 'YYYY')
          and q.quarter = getcurrentquarter())
from floors f;
-- changeset liquibase:29
select createemptymonthlyanalysisentries();

-- changeset liquibase:30
insert into dailybookings(day, morning, afternoon, total, fk_floor, fk_monthlybookingid) values
('2024-04-01', 58, 61, 119, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-02', 92, 102, 194, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-03', 167, 113, 280, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-04', 153, 29, 182, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-05', 17, 129, 146, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-06', 125, 151, 276, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-07', 89, 163, 252, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-08', 21, 10, 31, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-09', 79, 57, 136, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-10', 160, 128, 288, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-11', 50, 190, 240, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-12', 175, 82, 257, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-13', 135, 99, 234, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-14', 51, 177, 228, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-15', 166, 137, 303, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-16', 96, 26, 122, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-17', 124, 51, 175, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-18', 170, 171, 341, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-19', 148, 151, 299, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-20', 122, 170, 292, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-21', 38, 92, 130, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-22', 45, 55, 100, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-23', 22, 58, 80, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-24', 100, 185, 285, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-25', 42, 129, 171, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-26', 113, 59, 172, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-27', 119, 40, 159, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-28', 114, 185, 299, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-29', 141, 70, 211, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-04-30', 84, 56, 140, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-01', 180, 156, 336, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-02', 153, 163, 316, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-03', 84, 169, 253, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-04', 149, 120, 269, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-05', 137, 75, 212, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-06', 79, 62, 141, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-07', 35, 30, 65, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-08', 111, 163, 274, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-09', 66, 87, 153, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-10', 107, 168, 275, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-11', 118, 119, 237, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-12', 90, 87, 177, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-13', 109, 14, 123, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-14', 98, 66, 164, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-15', 138, 75, 213, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-16', 134, 67, 201, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-17', 70, 67, 137, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-18', 116, 163, 279, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-19', 110, 77, 187, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-20', 15, 77, 92, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-21', 85, 176, 261, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-22', 99, 195, 294, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-23', 130, 149, 279, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-24', 57, 192, 249, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-25', 76, 180, 256, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-26', 166, 79, 245, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-27', 157, 57, 214, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-28', 80, 77, 157, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-29', 125, 84, 209, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-05-30', 15, 95, 110, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-04')),
('2024-06-01', 76, 65, 141, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-06')),
('2024-06-02', 27, 55, 82, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-06')),
('2024-06-03', 85, 136, 221, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-06')),
('2024-06-04', 23, 80, 103, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-06')),
('2024-06-05', 112, 27, 139, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-06')),
('2024-06-06', 145, 162, 307, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-06')),
('2024-06-07', 135, 20, 155, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-06')),
('2024-06-08', 165, 171, 336, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-06')),
('2024-06-09', 63, 156, 219, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-06')),
('2024-06-10', 21, 73, 94, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-06')),
('2024-06-11', 178, 195, 373, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-06')),
('2024-06-12', 142, 161, 303, (select f.pk_floorid from floors f where f.floorname = '4'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '4') and month = '2024-06')),
('2024-04-01', 39, 13, 52, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-02', 156, 41, 197, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-03', 22, 107, 129, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-04', 54, 186, 240, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-05', 71, 72, 143, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-06', 67, 54, 121, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-07', 32, 68, 100, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-08', 50, 101, 151, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-09', 165, 23, 188, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-10', 87, 131, 218, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-11', 69, 162, 231, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-12', 83, 184, 267, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-13', 177, 39, 216, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-14', 168, 66, 234, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-15', 136, 34, 170, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-16', 60, 13, 73, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-17', 80, 36, 116, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-18', 55, 57, 112, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-19', 148, 61, 209, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-20', 107, 147, 254, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-21', 167, 7, 174, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-22', 119, 87, 206, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-23', 83, 26, 109, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-24', 158, 157, 315, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-25', 33, 21, 54, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-26', 56, 182, 238, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-27', 113, 143, 256, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-28', 140, 99, 239, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-29', 50, 48, 98, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-04-30', 166, 123, 289, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-01', 68, 42, 110, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-02', 85, 177, 262, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-03', 57, 179, 236, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-04', 163, 116, 279, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-05', 14, 69, 83, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-06', 81, 59, 140, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-07', 36, 192, 228, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-08', 49, 118, 167, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-09', 38, 102, 140, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-10', 157, 157, 314, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-11', 130, 33, 163, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-12', 89, 146, 235, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-13', 41, 148, 189, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-14', 165, 175, 340, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-15', 137, 76, 213, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-16', 61, 9, 70, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-17', 59, 148, 207, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-18', 63, 128, 191, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-19', 148, 179, 327, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-20', 131, 155, 286, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-21', 26, 57, 83, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-22', 151, 96, 247, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-23', 175, 150, 325, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-24', 46, 171, 217, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-25', 178, 195, 373, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-26', 123, 12, 135, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-27', 115, 189, 304, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-28', 48, 189, 237, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-29', 138, 70, 208, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-05-30', 61, 61, 122, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-04')),
('2024-06-01', 40, 157, 197, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-06')),
('2024-06-02', 108, 74, 182, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-06')),
('2024-06-03', 136, 118, 254, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-06')),
('2024-06-04', 176, 189, 365, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-06')),
('2024-06-05', 107, 157, 264, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-06')),
('2024-06-06', 145, 116, 261, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-06')),
('2024-06-07', 117, 184, 301, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-06')),
('2024-06-08', 46, 70, 116, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-06')),
('2024-06-09', 42, 112, 154, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-06')),
('2024-06-10', 144, 158, 302, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-06')),
('2024-06-11', 15, 43, 58, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-06')),
('2024-06-12', 15, 159, 174, (select f.pk_floorid from floors f where f.floorname = '8'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '8') and month = '2024-06')),
('2024-04-01', 14, 8, 22, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-02', 84, 93, 177, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-03', 140, 170, 310, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-04', 78, 25, 103, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-05', 38, 152, 190, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-06', 165, 70, 235, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-07', 181, 91, 272, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-08', 62, 121, 183, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-09', 102, 144, 246, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-10', 154, 77, 231, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-11', 149, 20, 169, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-12', 66, 124, 190, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-13', 48, 70, 118, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-14', 49, 55, 104, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-15', 126, 76, 202, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-16', 17, 41, 58, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-17', 175, 132, 307, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-18', 65, 125, 190, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-19', 123, 23, 146, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-20', 110, 133, 243, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-21', 92, 132, 224, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-22', 56, 165, 221, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-23', 44, 93, 137, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-24', 133, 154, 287, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-25', 75, 186, 261, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-26', 52, 150, 202, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-27', 140, 102, 242, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-28', 151, 93, 244, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-29', 84, 139, 223, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-04-30', 100, 148, 248, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-01', 49, 122, 171, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-02', 62, 67, 129, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-03', 16, 40, 56, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-04', 24, 75, 99, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-05', 122, 127, 249, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-06', 78, 162, 240, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-07', 28, 120, 148, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-08', 39, 190, 229, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-09', 108, 137, 245, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-10', 64, 98, 162, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-11', 32, 174, 206, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-12', 71, 162, 233, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-13', 131, 82, 213, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-14', 75, 184, 259, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-15', 81, 72, 153, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-16', 120, 149, 269, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-17', 112, 90, 202, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-18', 28, 156, 184, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-19', 145, 152, 297, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-20', 54, 32, 86, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-21', 72, 133, 205, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-22', 120, 73, 193, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-23', 128, 44, 172, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-24', 84, 22, 106, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-25', 132, 188, 320, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-26', 84, 38, 122, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-27', 172, 18, 190, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-28', 41, 43, 84, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-29', 106, 106, 212, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-05-30', 13, 189, 202, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-04')),
('2024-06-01', 158, 60, 218, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-06')),
('2024-06-02', 69, 26, 95, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-06')),
('2024-06-03', 138, 133, 271, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-06')),
('2024-06-04', 58, 131, 189, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-06')),
('2024-06-05', 109, 148, 257, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-06')),
('2024-06-06', 161, 37, 198, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-06')),
('2024-06-07', 41, 52, 93, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-06')),
('2024-06-08', 93, 49, 142, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-06')),
('2024-06-09', 98, 58, 156, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-06')),
('2024-06-10', 44, 96, 140, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-06')),
('2024-06-11', 150, 16, 166, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-06')),
('2024-06-12', 146, 190, 336, (select f.pk_floorid from floors f where f.floorname = '9'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '9') and month = '2024-06')),
('2024-04-01', 27, 30, 57, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-02', 122, 39, 161, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-03', 46, 140, 186, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-04', 160, 43, 203, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-05', 44, 9, 53, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-06', 85, 51, 136, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-07', 106, 115, 221, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-08', 34, 156, 190, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-09', 170, 9, 179, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-10', 56, 106, 162, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-11', 83, 118, 201, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-12', 36, 119, 155, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-13', 33, 194, 227, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-14', 75, 59, 134, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-15', 176, 64, 240, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-16', 138, 46, 184, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-17', 179, 173, 352, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-18', 137, 137, 274, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-19', 39, 92, 131, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-20', 120, 130, 250, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-21', 129, 183, 312, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-22', 130, 78, 208, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-23', 51, 83, 134, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-24', 36, 7, 43, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-25', 108, 87, 195, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-26', 93, 12, 105, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-27', 173, 103, 276, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-28', 129, 110, 239, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-29', 63, 162, 225, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-04-30', 18, 192, 210, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-01', 107, 85, 192, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-02', 25, 169, 194, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-03', 82, 178, 260, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-04', 31, 24, 55, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-05', 151, 183, 334, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-06', 35, 79, 114, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-07', 81, 130, 211, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-08', 156, 124, 280, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-09', 63, 90, 153, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-10', 137, 36, 173, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-11', 119, 32, 151, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-12', 19, 94, 113, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-13', 97, 72, 169, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-14', 101, 136, 237, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-15', 126, 180, 306, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-16', 83, 44, 127, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-17', 96, 193, 289, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-18', 111, 31, 142, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-19', 76, 116, 192, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-20', 66, 143, 209, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-21', 22, 28, 50, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-22', 65, 86, 151, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-23', 60, 57, 117, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-24', 54, 172, 226, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-25', 131, 74, 205, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-26', 79, 156, 235, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-27', 27, 147, 174, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-28', 16, 104, 120, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-29', 163, 51, 214, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-05-30', 53, 128, 181, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-04')),
('2024-06-01', 47, 47, 94, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-06')),
('2024-06-02', 128, 95, 223, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-06')),
('2024-06-03', 66, 112, 178, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-06')),
('2024-06-04', 64, 160, 224, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-06')),
('2024-06-05', 68, 105, 173, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-06')),
('2024-06-06', 130, 118, 248, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-06')),
('2024-06-07', 72, 126, 198, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-06')),
('2024-06-08', 83, 88, 171, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-06')),
('2024-06-09', 35, 19, 54, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-06')),
('2024-06-10', 39, 30, 69, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-06')),
('2024-06-11', 47, 112, 159, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-06')),
('2024-06-12', 132, 99, 231, (select f.pk_floorid from floors f where f.floorname = '50'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '50') and month = '2024-06')),
('2024-04-01', 92, 26, 118, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-02', 139, 182, 321, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-03', 75, 29, 104, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-04', 18, 38, 56, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-05', 16, 160, 176, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-06', 16, 80, 96, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-07', 62, 119, 181, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-08', 106, 62, 168, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-09', 108, 98, 206, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-10', 85, 63, 148, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-11', 168, 100, 268, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-12', 144, 123, 267, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-13', 88, 20, 108, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-14', 142, 78, 220, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-15', 39, 126, 165, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-16', 165, 173, 338, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-17', 108, 116, 224, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-18', 68, 55, 123, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-19', 48, 106, 154, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-20', 107, 76, 183, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-21', 147, 176, 323, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-22', 154, 130, 284, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-23', 122, 60, 182, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-24', 133, 175, 308, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-25', 33, 27, 60, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-26', 132, 43, 175, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-27', 131, 20, 151, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-28', 66, 71, 137, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-29', 33, 28, 61, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-04-30', 15, 167, 182, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-01', 141, 82, 223, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-02', 59, 93, 152, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-03', 115, 34, 149, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-04', 71, 162, 233, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-05', 105, 17, 122, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-06', 136, 65, 201, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-07', 122, 116, 238, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-08', 148, 189, 337, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-09', 121, 103, 224, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-10', 82, 28, 110, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-11', 65, 75, 140, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-12', 34, 105, 139, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-13', 73, 181, 254, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-14', 152, 173, 325, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-15', 115, 80, 195, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-16', 157, 42, 199, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-17', 133, 42, 175, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-18', 130, 139, 269, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-19', 36, 182, 218, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-20', 159, 50, 209, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-21', 59, 190, 249, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-22', 179, 184, 363, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-23', 157, 175, 332, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-24', 138, 140, 278, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-25', 159, 118, 277, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-26', 53, 56, 109, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-27', 178, 186, 364, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-28', 59, 76, 135, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-29', 51, 13, 64, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-05-30', 124, 180, 304, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-04')),
('2024-06-01', 182, 147, 329, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-06')),
('2024-06-02', 172, 17, 189, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-06')),
('2024-06-03', 161, 173, 334, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-06')),
('2024-06-04', 110, 100, 210, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-06')),
('2024-06-05', 87, 22, 109, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-06')),
('2024-06-06', 56, 46, 102, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-06')),
('2024-06-07', 149, 98, 247, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-06')),
('2024-06-08', 157, 84, 241, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-06')),
('2024-06-09', 50, 132, 182, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-06')),
('2024-06-10', 13, 157, 170, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-06')),
('2024-06-11', 139, 145, 284, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-06')),
('2024-06-12', 182, 55, 237, (select f.pk_floorid from floors f where f.floorname = '66'), (select m.pk_monthlybookingid from monthlybookings m where fk_floor = (select f.pk_floorid from floors f where f.floorname = '66') and month = '2024-06'));

-- changeset liquibase:32
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
-- changeset liquibase:33
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

-- changeset liquibase:34
With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, d.fk_monthlybookingid
              from dailybookings d
              where d.fk_floor is not null
                and Left(d.day, 7) = to_char(CURRENT_DATE  - INTERVAL '2 month', 'YYYY-MM'))

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
where month = to_char(CURRENT_DATE  - INTERVAL '2 month', 'YYYY-MM')
  and m.fk_floor is not null;

-- changeset liquibase:35
With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, d.fk_monthlybookingid
              from dailybookings d
              where d.fk_building is not null
                and Left(d.day, 7) = to_char(CURRENT_DATE  - INTERVAL '2 month', 'YYYY-MM'))

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
where month = to_char(CURRENT_DATE  - INTERVAL '2 month', 'YYYY-MM')
  and m.fk_building is not null;

-- changeset liquibase:36
With Days as (select d.pk_dailybookingid, d.morning, d.afternoon, d.total, d.fk_monthlybookingid
              from dailybookings d
              where d.fk_location is not null
                and Left(d.day, 7) = to_char(CURRENT_DATE  - INTERVAL '2 month', 'YYYY-MM'))

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
where month = to_char(CURRENT_DATE  - INTERVAL '2 month', 'YYYY-MM')
  and m.fk_location is not null;

-- changeset liquibase:37
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
-- changeset liquibase:38
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
-- changeset liquibase:39
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


-- changeset liquibase:40
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

-- changeset liquibase:41
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

-- changeset liquibase:42
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
  and m.fk_location is not null