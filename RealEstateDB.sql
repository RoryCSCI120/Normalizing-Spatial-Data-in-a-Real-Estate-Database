-- Enable PostGIS
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE PropertyDetails (
    PropertyID SERIAL PRIMARY KEY,
    Address VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(50),
    Country VARCHAR(50),
    ZoningType VARCHAR(100),
    Utility VARCHAR(100),
    GeoLocation GEOMETRY(Point, 4326), -- Spatial data type
    CityPopulation INT
);
--Creates a table called Properties, which is made up of a generated PropertyID, a unique value to represetn items in the table, and columns for Address, City, State, Country, ZoningType, Utility, GeoLocation and CityPopulation
--This table violates normalization because the Utility column is not atomic.

INSERT INTO PropertyDetails (Address, City, State, Country, ZoningType, Utility, GeoLocation, CityPopulation) VALUES
('38 Florence Street', 'Worcester', 'MA', 'United States of America', 'residential', 'parking, laundry, heating, wifi', ST_GeomFromText('POINT(42.25426959982486 -71.82287410064943)', 4326), '206518'),
('39 Florence Street', 'Worcester', 'MA', 'United States of America', 'residential', 'parking, laundry, heating, wifi, dishwasher', ST_GeomFromText('POINT(42.25395648962181 -71.8225515229365)', 4326), '206518'),
('906 Main Street', 'Worcester', 'MA', 'United States of America', 'mixed', 'laundry, heating, wifi', ST_GeomFromText('POINT(42.25198553968143 -71.81957156404147)', 4326), '206518'),
('27 Lakeview Avenue', 'Shrewsbury', 'MA', 'United States of America', 'commercial', 'heating, wifi', ST_GeomFromText('POINT(42.27680611764474 -71.74878558826882)', 4326), '37973'),
('1 Centre Hill Avenue', 'Petersburg', 'VA', 'United States of America', 'residential', 'heating, air conditioning', ST_GeomFromText('POINT(37.230697527996554 -77.4012331298219)', 4326), '33429'),
('1600 Pennsylvania Avenue NW', 'Washington', 'DC', 'United States of America', 'unzoned', 'laundry, heating, air conditioning, wifi, dishwasher, bowling alley', ST_GeomFromText('POINT(38.897916337838154 -77.03657759196909)', 4326), '712816');
--populates all of the columns in the PropertyDetails table

SELECT * FROM PropertyDetails;

CREATE TABLE PropertyAdresses (
 	AddressID SERIAL PRIMARY KEY,
    Address VARCHAR(255)
);
--Creates a table for the addresses so they can be assinged unique IDs

INSERT INTO PropertyAdresses (Address)
SELECT DISTINCT Address FROM PropertyDetails;
--Populates ProperyAdresses table

SELECT * FROM PropertyAdresses;

CREATE TABLE Utilities (
    UtilityID SERIAL PRIMARY KEY,
    AddressID INT,
    UtilityName VARCHAR(255),
    FOREIGN KEY (AddressID) REFERENCES PropertyAdresses(AddressID)
);
--This creates a table for Utilities, featuring UtilityID, a generated variable to represent each utility, alongside a column for names of the differnt utilities in the previous table.

INSERT INTO Utilities (AddressID, UtilityName) VALUES
(1, 'parking'), 
(1, 'laundry'), 
(1, 'heating'), 
(1, 'wifi'), 
(2, 'laundry'), 
(2, 'heating'), 
(2, 'wifi'),
(3, 'heating'),
(3, 'air conditioning'),
(4, 'parking'), 
(4, 'laundry'), 
(4, 'heating'), 
(4, 'wifi'),
(4, 'dishwasher'), 
(5, 'heating'),
(5, 'wifi'),
(6, 'laundry'),
(6, 'heating'), 
(6, 'wifi'),
(6, 'dishwasher'),
(6, 'air conditioning'), 
(6, 'bowling alley');
--Populates Utilities table

SELECT * FROM Utilities;

ALTER TABLE PropertyDetails DROP COLUMN Utility;
--removes the Utility column from PropertyDetails so it adheres to 1NF

CREATE TABLE CityDemographics (
    City VARCHAR(100) PRIMARY KEY,
    State VARCHAR(50),
    Country VARCHAR(50),
    CityPopulation INT
);
--creates a city demographics table to eliminate partial dependency

INSERT INTO CityDemographics (City, State, Country, CityPopulation) VALUES
('Worcester', 'MA', 'United States of America', '206518'),
('Shrewsbury', 'MA', 'United States of America', '37973'),
('Petersburg', 'VA', 'United States of America', '33429'),
('Washington', 'DC', 'United States of America', '712816');
--populates City Demographics with the City names, States, Country and populations

SELECT * FROM CityDemographics;

ALTER TABLE PropertyDetails DROP COLUMN CityPopulation, DROP COLUMN State, DROP COLUMN Country;
--Removes the CityPopulation, State and Country columns from the initial PropertyDetails table so it now adheres to 3NF

CREATE TABLE PropertyZoning (
    PropertyZoningID SERIAL PRIMARY KEY,
    PropertyID INT REFERENCES PropertyDetails(PropertyID),
    ZoningType VARCHAR(100)
);
--Creates a table called PropertyZoning, containging columsn for a PropertyZoningID, Property ID

INSERT INTO PropertyZoning (PropertyID, ZoningType) VALUES
(1, 'residential'),
(2, 'residential'),
(3, 'mixed'),
(4, 'commercial'),
(5, 'residential'),
(6, 'unzoned');

SELECT * FROM PropertyZoning;

CREATE TABLE PropertyUtilities (
    PropertyUtilityID SERIAL PRIMARY KEY,
    PropertyID INT REFERENCES PropertyDetails(PropertyID),
    Utility VARCHAR(100)
);
--creates a new table called PropertyUtilities containing a propertyutility ID column, the propertyID column and the utilities of those respective properties

INSERT INTO PropertyUtilities (PropertyID, Utility) VALUES
(1, 'parking'),
(1, 'laundry'),
(1, 'heating'),
(1, 'wifi'),
(2, 'parking'),
(2, 'laundry'),
(2, 'heating'),
(2, 'wifi'),
(2, 'dishwasher'),
(3, 'laundry'),
(3, 'heating'),
(3, 'wifi'),
(4, 'heating'),
(4, 'wifi'),
(5, 'heating'),
(5, 'air conditioning'),
(6, 'laundry'),
(6, 'heating'),
(6, 'air conditioning'),
(6, 'wifi'),
(6, 'dishwasher'),
(6, 'bowling alley');
--populates the PropertyUtilities table

SELECT * FROM PropertyUtilities;

ALTER TABLE PropertyDetails DROP COLUMN ZoningType;
--removes teh ZoningType column from PropertyDetails table

INSERT INTO PropertyDetails (Address, City, GeoLocation)
VALUES ('123 Main St', 'Springfield', ST_GeomFromText('POINT(-89.6501483 39.7817213)', 4326));
--adds a new property to PropertyDetails

SELECT Address, City
FROM PropertyDetails
WHERE ST_DWithin(
    GeoLocation,
    ST_GeomFromText('POINT(-89.6501483 39.7817213)', 4326),
    10000 -- 10km radius
);
--Queries properties within a radius
