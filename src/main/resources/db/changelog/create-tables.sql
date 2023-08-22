-- liquibase formatted sql

-- changeset liquibase:1
CREATE TABLE Roles
(
    pk_roleId   uuid UNIQUE NOT NULL,
    description varchar(255),
    PRIMARY KEY (pk_roleId)
)

-- changeset liquibase:2
CREATE TABLE Users
(
    pk_userId uuid UNIQUE NOT NULL,
    username  varchar(255),
    PRIMARY KEY (pk_userId)
)

-- changeset liquibase:3
CREATE TABLE Role_User
(
    pk_fk_roleId uuid,
    pk_fk_userId uuid,
    PRIMARY KEY (pk_fk_roleId, pk_fk_userId),
    FOREIGN KEY (pk_fk_userId) REFERENCES Users (pk_userId),
    FOREIGN KEY (pk_fk_roleId) REFERENCES Roles (pk_roleId)
)

-- changeset liquibase:4
CREATE TABLE Locations
(
    pk_locationId uuid UNIQUE NOT NULL,
    locationName  varchar(255),
    PRIMARY KEY (pk_locationId)
)

-- changeset liquibase:5
CREATE TABLE Seats
(
    pk_seatId     uuid UNIQUE NOT NULL,
    floor         int,
    seatNum       int,
    x             float4,
    y             float4,
    fk_locationId uuid,
    PRIMARY KEY (pk_seatId),
    FOREIGN KEY (fk_locationId) REFERENCES Locations (pk_locationId),
    UNIQUE (fk_locationId, seatNum)
)

-- changeset liquibase:6
CREATE TABLE Attributes
(
    pk_attributeId uuid UNIQUE NOT NULL,
    description    varchar(255),
    color          varchar(255)
);

-- changeset liquibase:7
CREATE TABLE Seat_Attribute
(
    pk_fk_seatId      uuid,
    pk_fk_attributeId uuid,
    PRIMARY KEY (pk_fk_seatId, pk_fk_attributeId),
    FOREIGN KEY (pk_fk_seatId) REFERENCES Seats (pk_seatId),
    FOREIGN KEY (pk_fk_attributeId) REFERENCES Attributes (pk_attributeId)
)

-- changeset liquibase:8
CREATE TABLE Intervals
(
    pk_intervalId uuid UNIQUE NOT NULL,
    description   varchar(255),
    PRIMARY KEY (pk_intervalId)
)

-- changeset liquibase:9
CREATE TABLE Bookings
(
    pk_bookingId  uuid UNIQUE NOT NULL,
    bookingNumber int,
    fk_userId     uuid,
    fk_seatId     uuid,
    fk_intervalId uuid,
    PRIMARY KEY (pk_bookingId),
    FOREIGN KEY (fk_userId) REFERENCES Users (pk_userId),
    FOREIGN KEY (fk_seatId) REFERENCES Seats (pk_seatId),
    FOREIGN KEY (fk_intervalId) REFERENCES Intervals (pk_intervalId)
)