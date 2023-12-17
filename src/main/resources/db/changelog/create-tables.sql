-- liquibase formatted sql

-- changeset liquibase:1
CREATE TABLE Roles
(
    pk_roleId UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    roleName  VARCHAR(255) NOT NULL,
    createdOn TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- changeset liquibase:2
CREATE TABLE Locations
(
    pk_locationId UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    locationName  VARCHAR(255) NOT NULL,
    createdOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- changeset liquibase:3
CREATE TABLE Buildings
(
    pk_buildingId UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    buildingName  VARCHAR(255) NOT NULL,
    createdOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_locationId UUID,
    FOREIGN KEY (fk_locationId) REFERENCES Locations (pk_locationId)
);
-- changeset liquibase:4
CREATE TABLE Floors
(
    pk_floorId    UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    floorName     VARCHAR(255) NOT NULL,
    createdOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_buildingId UUID,
    FOREIGN KEY (fk_buildingId) REFERENCES Buildings (pk_buildingId)
);

-- changeset liquibase:5
CREATE TABLE Users
(
    pk_userId     UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    username      VARCHAR(255) NOT NULL,
    createdOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_locationId UUID,
    FOREIGN KEY (fk_locationId) REFERENCES Locations (pk_locationId)
);

-- changeset liquibase:6
CREATE TABLE Roles_Users
(
    pk_fk_roleId UUID,
    pk_fk_userId UUID,
    PRIMARY KEY (pk_fk_roleId, pk_fk_userId),
    FOREIGN KEY (pk_fk_roleId) REFERENCES Roles (pk_roleId),
    FOREIGN KEY (pk_fk_userId) REFERENCES Users (pk_userId)
);

-- changeset liquibase:7
CREATE TABLE Maps
(
    pk_mapId    UUID PRIMARY KEY    DEFAULT gen_random_uuid(),
    width       INT NOT NULL,
    height      INT NOT NULL,
    createdOn   TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    updatedOn   TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    fk_floorId  UUID,
    FOREIGN KEY (fk_floorId) REFERENCES Floors (pk_floorId)
);

-- changeset liquibase:8
CREATE TABLE Desks
(
    pk_deskId  UUID PRIMARY KEY   DEFAULT gen_random_uuid(),
    deskNum    VARCHAR   NOT NULL,
    x          INT       NOT NULL,
    y          INT       NOT NULL,
    rotation   INT       NOT NULL,
    createdOn  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_floorId UUID,
    fk_mapId   UUID,
    FOREIGN KEY (fk_floorId) REFERENCES Floors (pk_floorId),
    FOREIGN KEY (fk_mapId)   REFERENCES Maps   (pk_mapId)
);

-- changeset liquibase:9
CREATE TABLE Bookings
(
    pk_bookingId  UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    bookingNumber VARCHAR(255) NOT NULL,
    date          DATE         NOT NULL,
    createdOn     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    updatedOn     TIMESTAMP    DEFAULT CURRENT_TIMESTAMP,
    isMorning     BOOLEAN      NOT NULL,
    isAfternoon   BOOLEAN      NOT NULL,
    fk_userId     UUID,
    fk_deskId     UUID,
    FOREIGN KEY (fk_userId) REFERENCES Users (pk_userId),
    FOREIGN KEY (fk_deskId) REFERENCES Desks (pk_deskId)
);

-- changeset liquibase:10
CREATE TABLE Attributes
(
    pk_attributeId UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    attributeName  VARCHAR(255) NOT NULL,
    createdOn      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- changeset liquibase:11
CREATE TABLE Desks_Attributes
(
    pk_fk_deskId      UUID,
    pk_fk_attributeId UUID,
    PRIMARY KEY (pk_fk_deskId, pk_fk_attributeId),
    FOREIGN KEY (pk_fk_deskId) REFERENCES Desks (pk_deskId),
    FOREIGN KEY (pk_fk_attributeId) REFERENCES Attributes (pk_attributeId)
);

-- changeset liquibase:12
CREATE  TABLE Rooms
(
    pk_roomId   UUID PRIMARY KEY    DEFAULT  gen_random_uuid(),
    x           INT NOT NULL,
    y           INT NOT NULL,
    width       INT NOT NULL,
    height      INT NOT NULL,
    createdOn   TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    updatedOn   TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    fk_mapId    UUID,
    FOREIGN KEY (fk_mapId)   REFERENCES Maps   (pk_mapId)
)

-- changeset liquibase:13
CREATE TYPE interiorType AS ENUM ('Couch', 'Aquarium')

-- changeset liquibase:14
CREATE TABLE Interiors
(
    pk_interiorId   UUID PRIMARY KEY    DEFAULT  gen_random_uuid(),
    type            interiorType NOT NULL,
    x               INT NOT NULL,
    y               INT NOT NULL,
    rotation        INT NOT NULL,
    width           INT NOT NULL,
    height          INT NOT NULL,
    createdOn       TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    updatedOn       TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    fk_mapId        UUID,
    FOREIGN KEY (fk_mapId)   REFERENCES Maps   (pk_mapId)
)

-- changeset liquibase:15
CREATE TABLE Labels
(
    pk_labelId      UUID PRIMARY KEY    DEFAULT  gen_random_uuid(),
    x               INT NOT NULL,
    y               INT NOT NULL,
    rotation        INT NOT NULL,
    pt              INT NOT NULL,
    createdOn       TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    updatedOn       TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    fk_mapId        UUID,
    FOREIGN KEY (fk_mapId)   REFERENCES Maps   (pk_mapId)
)
-- changeset liquibase:16
create table DailyBookings(
                              pk_dailyBookingId       uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                              day                     char(10) DEFAULT to_char(CURRENT_DATE, 'YYYY-MM-DD'),
                              morning                 INTEGER NOT NULL,
                              afternoon               INTEGER NOT NULL,
                              totalBookings           INTEGER NOT NULL,
                              createdOn               TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
                              updatedOn               TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
                              fk_Location             UUID NOT NULL ,
                              fk_building             UUID,
                              fk_floor                UUID,
                              fk_monthlyBookingId     UUID NOT NULL ,
                              FOREIGN KEY (fk_Location)        REFERENCES locations (pk_locationid),
                              Foreign Key (fk_building)           REFERENCES buildings (pk_buildingid),
                              Foreign Key (fk_floor)              REFERENCES floors (pk_floorid)
);
-- changeset liquibase:17
create table YearlyBookings(
                               pk_yearlyBookingId      uuid PRIMARY KEY DEFAULT gen_random_uuid(),
                               year                    char(4) DEFAULT to_char(current_date, 'YYYY'),
                               totalBookings           INTEGER DEFAULT 0,
                               days                    INT NOT NULL DEFAULT 0,
                               amountOfDesks           INT NOT NULL DEFAULT 0,
                               morning_highestBooking UUID,
                               morning_averageBooking double precision NOT NULL DEFAULT 0,
                               morning_lowestBooking  UUID,
                               afternoon_highestBooking UUID,
                               afternoon_averageBooking double precision NOT NULL DEFAULT 0,
                               afternoon_lowestBooking  UUID,
                               fk_Location             UUID NOT NULL ,
                               fk_building             UUID,
                               fk_floor                UUID,
                               createdOn       TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
                               updatedOn       TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
                               FOREIGN KEY (fk_Location)           REFERENCES locations (pk_locationid),
                               Foreign Key (fk_building)           REFERENCES buildings (pk_buildingid),
                               Foreign Key (fk_floor)              REFERENCES floors (pk_floorid),
                               Foreign Key (morning_highestBooking)   REFERENCES DailyBookings (pk_dailyBookingId),
                               Foreign Key (morning_lowestBooking)    REFERENCES DailyBookings (pk_dailyBookingId),
                               Foreign Key (afternoon_highestBooking) REFERENCES DailyBookings (pk_dailyBookingId),
                               Foreign Key (afternoon_lowestBooking)  REFERENCES DailyBookings (pk_dailyBookingId)
);
-- changeset liquibase:18
create table QuarterlyBookings(
                                  pk_quarterlyBookingId   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                                  year                    char(4) DEFAULT to_char(current_date, 'YYYY'),
                                  quarter                 Varchar(2) NOT NULL CHECK ( quarter IN ('Q1','Q2','Q3','Q4')),
                                  totalBookings           INTEGER DEFAULT 0,
                                  days                    INT NOT NULL DEFAULT 0,
                                  amountOfDesks           INT NOT NULL DEFAULT 0,
                                  morning_highestBooking UUID,
                                  morning_averageBooking double precision NOT NULL DEFAULT 0,
                                  morning_lowestBooking  UUID,
                                  afternoon_highestBooking UUID,
                                  afternoon_averageBooking double precision NOT NULL DEFAULT 0,
                                  afternoon_lowestBooking  UUID,
                                  fk_Location             UUID NOT NULL ,
                                  fk_building             UUID,
                                  fk_floor                UUID,
                                  fk_yearlyBookingId   UUID NOT NULL,
                                  createdOn       TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
                                  updatedOn       TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
                                  FOREIGN KEY (fk_Location)           REFERENCES locations (pk_locationid),
                                  Foreign Key (fk_building)           REFERENCES buildings (pk_buildingid),
                                  Foreign Key (fk_floor)              REFERENCES floors (pk_floorid),
                                  FOREIGN KEY (fk_yearlyBookingId)    REFERENCES YearlyBookings (pk_yearlyBookingId),
                                  Foreign Key (morning_highestBooking)   REFERENCES DailyBookings (pk_dailyBookingId),
                                  Foreign Key (morning_lowestBooking)    REFERENCES DailyBookings (pk_dailyBookingId),
                                  Foreign Key (afternoon_highestBooking) REFERENCES DailyBookings (pk_dailyBookingId),
                                  Foreign Key (afternoon_lowestBooking)  REFERENCES DailyBookings (pk_dailyBookingId)
);
-- changeset liquibase:19
create table MonthlyBookings(
                                pk_monthlyBookingId     UUID PRIMARY KEY DEFAULT gen_random_uuid(),
                                month                   char(7) DEFAULT to_char(current_date, 'YYYY-MM'),
                                totalBookings           INTEGER NOT NULL DEFAULT 0 ,
                                days                    INT NOT NULL DEFAULT 0,
                                amountOfDesks           INT NOT NULL DEFAULT 0,
                                morning_highestBooking UUID,
                                morning_averageBooking double precision NOT NULL DEFAULT 0,
                                morning_lowestBooking  UUID,
                                afternoon_highestBooking UUID,
                                afternoon_averageBooking double precision NOT NULL DEFAULT 0,
                                afternoon_lowestBooking  UUID,
                                fk_Location             UUID NOT NULL ,
                                fk_building             UUID,
                                fk_floor                UUID,
                                fk_quarterlyBookingId   UUID NOT NULL ,
                                createdOn       TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
                                updatedOn       TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
                                FOREIGN KEY (fk_Location)           REFERENCES locations (pk_locationid),
                                Foreign Key (fk_building)           REFERENCES buildings (pk_buildingid),
                                Foreign Key (fk_floor)              REFERENCES floors (pk_floorid),
                                FOREIGN KEY (fk_quarterlyBookingId) REFERENCES QuarterlyBookings (pk_quarterlyBookingId),
                                Foreign Key (morning_highestBooking)   REFERENCES DailyBookings (pk_dailyBookingId),
                                Foreign Key (morning_lowestBooking)    REFERENCES DailyBookings (pk_dailyBookingId),
                                Foreign Key (afternoon_highestBooking) REFERENCES DailyBookings (pk_dailyBookingId),
                                Foreign Key (afternoon_lowestBooking)  REFERENCES DailyBookings (pk_dailyBookingId)
);

-- changeset liquibase:20
CREATE TABLE UserAnalytic (
                              pk_useranalyticid UUID PRIMARY KEY  DEFAULT gen_random_uuid(),
                              fk_userid              UUID      NOT NULL,
                              year              INTEGER   NOT NULL,
                              result            JSONB     NOT NULL,
                              createdOn         TIMESTAMP  NOT NULL DEFAULT CURRENT_TIMESTAMP,
                              FOREIGN KEY (fk_userid) REFERENCES Users (pk_userId)
);

--changeset liquibase:21
CREATE TABLE Walls (
    pk_wallId   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    x           INT NOT NULL,
    y           INT NOT NULL,
    rotation    INT NOT NULL,
    width       INT NOT NULL,
    createdOn   TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    updatedOn   TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    fk_mapId    UUID,
    FOREIGN KEY (fk_mapId) REFERENCES Maps (pk_mapId)
)

--changeset liquibase:22
CREATE TABLE Doors (
    pk_doorId   UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    x           INT NOT NULL,
    y           INT NOT NULL,
    rotation    INT NOT NULL,
    width       INT NOT NULL,
    createdOn   TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    updatedOn   TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    fk_mapId    UUID,
    FOREIGN KEY (fk_mapId) REFERENCES Maps (pk_mapId)
)
-- changeset liquibase:23
ALTER TABLE DailyBookings
    ADD CONSTRAINT fk_morningMonthlyBookingId FOREIGN KEY (fk_monthlyBookingId) REFERENCES MonthlyBookings (pk_monthlyBookingId);
