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
    locationName  VARCHAR(255) NOT NULL UNIQUE,
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
    fk_accountId  varchar,
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
    published   BOOLEAN NOT NULL DEFAULT FALSE,
    name        TEXT NOT NULL,
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
    fk_mapId   UUID,
    fk_userId  UUID,
    FOREIGN KEY (fk_mapId)      REFERENCES Maps   (pk_mapId),
    FOREIGN KEY (fk_userId)     REFERENCES Users  (pk_userId)   ON DELETE SET NULL
);

-- changeset liquibase:9
CREATE TABLE Bookings
(
    pk_bookingId  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    bookingNumber VARCHAR(255) NOT NULL,
    date          DATE         NOT NULL,
    createdOn     TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    updatedOn     TIMESTAMP        DEFAULT CURRENT_TIMESTAMP,
    isMorning     BOOLEAN      NOT NULL,
    isAfternoon   BOOLEAN      NOT NULL,
    fk_userId     UUID,
    fk_deskId     UUID,
    FOREIGN KEY (fk_userId) REFERENCES Users (pk_userId) ON DELETE SET NULL,
    FOREIGN KEY (fk_deskId) REFERENCES Desks (pk_deskId) ON DELETE CASCADE
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
CREATE TABLE Rooms
(
    pk_roomId UUID PRIMARY KEY   DEFAULT gen_random_uuid(),
    x         INT       NOT NULL,
    y         INT       NOT NULL,
    width     INT       NOT NULL,
    height    INT       NOT NULL,
    createdOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_mapId  UUID,
    FOREIGN KEY (fk_mapId) REFERENCES Maps (pk_mapId)
)

-- changeset liquibase:13
CREATE TYPE interiorType AS ENUM ('Couch', 'Aquarium')

-- changeset liquibase:14
CREATE TABLE Interiors
(
    pk_interiorId UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    type          interiorType NOT NULL,
    x             INT          NOT NULL,
    y             INT          NOT NULL,
    rotation      INT          NOT NULL,
    width         INT          NOT NULL,
    height        INT          NOT NULL,
    createdOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn     TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_mapId      UUID,
    FOREIGN KEY (fk_mapId) REFERENCES Maps (pk_mapId)
)

-- changeset liquibase:15
CREATE TABLE Labels
(
    pk_labelId      UUID PRIMARY KEY    DEFAULT  gen_random_uuid(),
    text            VARCHAR,
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
create table DailyBookings
(
    pk_dailyBookingId   uuid PRIMARY KEY   DEFAULT gen_random_uuid(),
    day                 char(10)           DEFAULT to_char(CURRENT_DATE, 'YYYY-MM-DD'),
    morning             INTEGER   NOT NULL,
    afternoon           INTEGER   NOT NULL,
    total               INTEGER   NOT NULL,
    createdOn           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn           TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_location         UUID,
    fk_building         UUID,
    fk_floor            UUID,
    fk_monthlyBookingId UUID,
    FOREIGN KEY (fk_location) REFERENCES locations (pk_locationid) ON DELETE CASCADE,
    Foreign Key (fk_building) REFERENCES buildings (pk_buildingid) ON DELETE CASCADE,
    Foreign Key (fk_floor) REFERENCES floors (pk_floorid) ON DELETE CASCADE
);

-- changeset liquibase:17
create table YearlyBookings
(
    pk_yearlyBookingId       uuid PRIMARY KEY          DEFAULT gen_random_uuid(),
    year                     char(4)                   DEFAULT to_char(current_date, 'YYYY'),
    total                    INTEGER                   DEFAULT 0,
    days                     INT              NOT NULL DEFAULT 0,
    amountOfDesks            INT              NOT NULL DEFAULT 0,
    morning_highestBooking   UUID,
    morning_averageBooking   double precision NOT NULL DEFAULT 0,
    morning_lowestBooking    UUID,
    afternoon_highestBooking UUID,
    afternoon_averageBooking double precision NOT NULL DEFAULT 0,
    afternoon_lowestBooking  UUID,
    fk_location              UUID,
    fk_building              UUID,
    fk_floor                 UUID,
    createdOn                TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn                TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (fk_location) REFERENCES locations (pk_locationid) ON DELETE CASCADE,
    Foreign Key (fk_building) REFERENCES buildings (pk_buildingid) ON DELETE CASCADE,
    Foreign Key (fk_floor) REFERENCES floors (pk_floorid) ON DELETE CASCADE,
    Foreign Key (morning_highestBooking) REFERENCES DailyBookings (pk_dailyBookingId) ON DELETE CASCADE,
    Foreign Key (morning_lowestBooking) REFERENCES DailyBookings (pk_dailyBookingId) ON DELETE CASCADE,
    Foreign Key (afternoon_highestBooking) REFERENCES DailyBookings (pk_dailyBookingId) ON DELETE CASCADE,
    Foreign Key (afternoon_lowestBooking) REFERENCES DailyBookings (pk_dailyBookingId) ON DELETE CASCADE
);
-- changeset liquibase:18
create table QuarterlyBookings
(
    pk_quarterlyBookingId    UUID PRIMARY KEY          DEFAULT gen_random_uuid(),
    year                     char(4)                   DEFAULT to_char(current_date, 'YYYY'),
    quarter                  SMALLINT         NOT NULL CHECK ( quarter IN (1, 2, 3, 4)),
    total                    INTEGER                   DEFAULT 0,
    days                     INT              NOT NULL DEFAULT 0,
    amountOfDesks            INT              NOT NULL DEFAULT 0,
    morning_highestBooking   UUID,
    morning_averageBooking   double precision NOT NULL DEFAULT 0,
    morning_lowestBooking    UUID,
    afternoon_highestBooking UUID,
    afternoon_averageBooking double precision NOT NULL DEFAULT 0,
    afternoon_lowestBooking  UUID,
    fk_location              UUID,
    fk_building              UUID,
    fk_floor                 UUID,
    fk_yearlyBookingId       UUID,
    createdOn                TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn                TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (fk_location) REFERENCES locations (pk_locationid) ON DELETE CASCADE,
    Foreign Key (fk_building) REFERENCES buildings (pk_buildingid) ON DELETE CASCADE,
    Foreign Key (fk_floor) REFERENCES floors (pk_floorid) ON DELETE CASCADE,
    FOREIGN KEY (fk_yearlyBookingId) REFERENCES YearlyBookings (pk_yearlyBookingId) ON DELETE CASCADE,
    Foreign Key (morning_highestBooking) REFERENCES DailyBookings (pk_dailyBookingId) ON DELETE CASCADE,
    Foreign Key (morning_lowestBooking) REFERENCES DailyBookings (pk_dailyBookingId) ON DELETE CASCADE,
    Foreign Key (afternoon_highestBooking) REFERENCES DailyBookings (pk_dailyBookingId) ON DELETE CASCADE,
    Foreign Key (afternoon_lowestBooking) REFERENCES DailyBookings (pk_dailyBookingId) ON DELETE CASCADE
);
-- changeset liquibase:19
create table MonthlyBookings
(
    pk_monthlyBookingId      UUID PRIMARY KEY          DEFAULT gen_random_uuid(),
    month                    char(7)                   DEFAULT to_char(current_date, 'YYYY-MM'),
    total                    INTEGER          NOT NULL DEFAULT 0,
    days                     INT              NOT NULL DEFAULT 0,
    amountOfDesks            INT              NOT NULL DEFAULT 0,
    morning_highestBooking   UUID,
    morning_averageBooking   double precision NOT NULL DEFAULT 0,
    morning_lowestBooking    UUID,
    afternoon_highestBooking UUID,
    afternoon_averageBooking double precision NOT NULL DEFAULT 0,
    afternoon_lowestBooking  UUID,
    fk_location              UUID,
    fk_building              UUID,
    fk_floor                 UUID,
    fk_quarterlyBookingId    UUID,
    createdOn                TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn                TIMESTAMP        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (fk_location) REFERENCES locations (pk_locationid) ON DELETE CASCADE,
    Foreign Key (fk_building) REFERENCES buildings (pk_buildingid) ON DELETE CASCADE,
    Foreign Key (fk_floor) REFERENCES floors (pk_floorid) ON DELETE CASCADE,
    FOREIGN KEY (fk_quarterlyBookingId) REFERENCES QuarterlyBookings (pk_quarterlyBookingId) ON DELETE CASCADE,
    Foreign Key (morning_highestBooking) REFERENCES DailyBookings (pk_dailyBookingId) ON DELETE CASCADE,
    Foreign Key (morning_lowestBooking) REFERENCES DailyBookings (pk_dailyBookingId) ON DELETE CASCADE,
    Foreign Key (afternoon_highestBooking) REFERENCES DailyBookings (pk_dailyBookingId) ON DELETE CASCADE,
    Foreign Key (afternoon_lowestBooking) REFERENCES DailyBookings (pk_dailyBookingId) ON DELETE CASCADE
);

-- changeset liquibase:20
ALTER TABLE DailyBookings
    ADD CONSTRAINT fk_MonthlyBookingId FOREIGN KEY (fk_monthlyBookingId) REFERENCES MonthlyBookings (pk_monthlyBookingId) ON DELETE CASCADE;


--changeset liquibase:21
CREATE TABLE Walls
(
    pk_wallId UUID PRIMARY KEY   DEFAULT gen_random_uuid(),
    x         INT       NOT NULL,
    y         INT       NOT NULL,
    rotation  INT       NOT NULL,
    width     INT       NOT NULL,
    createdOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_mapId  UUID,
    FOREIGN KEY (fk_mapId) REFERENCES Maps (pk_mapId)
);

--changeset liquibase:22
CREATE TABLE Doors
(
    pk_doorId UUID PRIMARY KEY   DEFAULT gen_random_uuid(),
    x         INT       NOT NULL,
    y         INT       NOT NULL,
    rotation  INT       NOT NULL,
    width     INT       NOT NULL,
    createdOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fk_mapId  UUID,
    FOREIGN KEY (fk_mapId) REFERENCES Maps (pk_mapId)
)
-- changeset liquibase:23
ALTER TABLE DailyBookings
    ADD CONSTRAINT fk_morningMonthlyBookingId FOREIGN KEY (fk_monthlyBookingId) REFERENCES MonthlyBookings (pk_monthlyBookingId);

-- changeset liquibase:24

CREATE TABLE accounts(
    pk_accountid    varchar PRIMARY KEY NOT NULL,
    provider        VARCHAR NOT NULL,
    access_token    VARCHAR NOT NULL,
    refresh_token   VARCHAR NOT NULL,
    createdOn       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)

-- changeset liquibase:25

ALTER TABLE Users ADD CONSTRAINT fk_accountid FOREIGN KEY (fk_accountId) references accounts (pk_accountid) ON DELETE CASCADE;

