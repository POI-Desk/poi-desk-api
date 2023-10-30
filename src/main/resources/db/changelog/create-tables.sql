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
CREATE TABLE Maps
(
    pk_mapId    UUID PRIMARY KEY    DEFAULT gen_random_uuid(),
    width       INT NOT NULL,
    height      INT NOT NULL,
    createdOn   TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP,
    updatedOn   TIMESTAMP NOT NULL  DEFAULT CURRENT_TIMESTAMP
);

-- changeset liquibase:4
CREATE TABLE Users
(
    pk_userId     UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    username      VARCHAR(255) NOT NULL,
    createdOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_locationId UUID,
    FOREIGN KEY (fk_locationId) REFERENCES Locations (pk_locationId)
);

-- changeset liquibase:5
CREATE TABLE Roles_Users
(
    pk_fk_roleId UUID,
    pk_fk_userId UUID,
    PRIMARY KEY (pk_fk_roleId, pk_fk_userId),
    FOREIGN KEY (pk_fk_roleId) REFERENCES Roles (pk_roleId),
    FOREIGN KEY (pk_fk_userId) REFERENCES Users (pk_userId)
);

-- changeset liquibase:6
CREATE TABLE Buildings
(
    pk_buildingId UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    buildingName  VARCHAR(255) NOT NULL,
    createdOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_locationId UUID,
    FOREIGN KEY (fk_locationId) REFERENCES Locations (pk_locationId)
);

-- changeset liquibase:7
CREATE TABLE Floors
(
    pk_floorId    UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    floorName     VARCHAR(255) NOT NULL,
    createdOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_buildingId UUID,
    FOREIGN KEY (fk_buildingId) REFERENCES Buildings (pk_buildingId)
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
create table YearlyBookings(
    pk_yearlyBookingId uuid DEFAULT gen_random_uuid(),
    year char(4) DEFAULT to_char(current_date, 'YYYY'),
    fk_Location UUID NOT NULL,
    totalBookings INTEGER DEFAULT 0,
    amountOfDesks INT,
    highestBookings INT,
    averageBookings INT,
    lowestBookings INT,
    PRIMARY KEY (pk_yearlyBookingId),
    FOREIGN KEY (fk_Location) REFERENCES locations (pk_locationid)
);
-- changeset liquibase:17
create table QuarterlyBookings(
    pk_quarterlyBookingId uuid DEFAULT gen_random_uuid(),
    year char(4) DEFAULT to_char(current_date, 'YYYY'),
    fk_Location UUID NOT NULL ,
    quarter Varchar(2) NOT NULL CHECK ( quarter IN ('Q1','Q2','Q3','Q4')),
    totalBookings INTEGER DEFAULT 0,
    amountOfDesks INT,
    highestBookings INT,
    averageBookings INT,
    lowestBookings INT,
    fk_yearlyBookingId UUID NOT NULL,
    PRIMARY KEY (pk_quarterlyBookingId),
    FOREIGN KEY (fk_Location) REFERENCES locations (pk_locationid),
    FOREIGN KEY (fk_yearlyBookingId) REFERENCES YearlyBookings (pk_yearlyBookingId)
);
-- changeset liquibase:18
create table MonthlyBookings(
    pk_monthlyBookingId uuid DEFAULT gen_random_uuid(),
    month char(7) DEFAULT to_char(current_date, 'YYYY-MM'),
    fk_Location UUID NOT NULL ,
    totalBookings INTEGER DEFAULT 0 ,
    amountOfDesks INT,
    highestBookings INT,
    averageBookings INT,
    lowestBookings INT,
    fk_quarterlyBookingId UUID,
    PRIMARY KEY (pk_monthlyBookingId),
    FOREIGN KEY (fk_Location) REFERENCES locations (pk_locationid),
    FOREIGN KEY (fk_quarterlyBookingId) REFERENCES QuarterlyBookings (pk_quarterlyBookingId)
);
-- changeset liquibase:19
create table DailyBookings(
    pk_day char(10) DEFAULT to_char(CURRENT_DATE, 'YYYY-MM-DD'),
    pk_fk_Location UUID NOT NULL ,
    totalBookings INTEGER NOT NULL ,
    fk_monthlyBookingId UUID NOT NULL ,
    PRIMARY KEY (pk_day, pk_fk_Location),
    FOREIGN KEY (pk_fk_Location) REFERENCES locations (pk_locationid),
    FOREIGN KEY (fk_monthlyBookingId) REFERENCES MonthlyBookings (pk_monthlyBookingId)
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
