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
CREATE TABLE BookingsLog
(
    pk_bookingLogId UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    bookingNumber   VARCHAR(255) NOT NULL,
    date            DATE         NOT NULL,
    createdOn       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn       TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    isMorning       BOOLEAN      NOT NULL,
    isAfternoon     BOOLEAN      NOT NULL,
    wasDeleted      BOOlEAN      NOT NULL,
    fk_userId       UUID,
    fk_deskId       UUID,
    FOREIGN KEY (fk_userId) REFERENCES Users (pk_userId),
    FOREIGN KEY (fk_deskId) REFERENCES Desks (pk_deskId)
);

-- changeset liquibase:11
CREATE TABLE Attributes
(
    pk_attributeId UUID PRIMARY KEY      DEFAULT gen_random_uuid(),
    attributeName  VARCHAR(255) NOT NULL,
    createdOn      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updatedOn      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- changeset liquibase:12
CREATE TABLE Desks_Attributes
(
    pk_fk_deskId      UUID,
    pk_fk_attributeId UUID,
    PRIMARY KEY (pk_fk_deskId, pk_fk_attributeId),
    FOREIGN KEY (pk_fk_deskId) REFERENCES Desks (pk_deskId),
    FOREIGN KEY (pk_fk_attributeId) REFERENCES Attributes (pk_attributeId)
);

-- changeset liquibase:13
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

-- changeset liquibase:14
CREATE TYPE interiorType AS ENUM ('Couch', 'Aquarium')

-- changeset liquibase:15
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

-- changeset liquibase:16
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