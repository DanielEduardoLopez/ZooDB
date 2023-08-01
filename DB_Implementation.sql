/*
Database Design and Implementation For a Zoo

Daniel Eduardo López
27/07/2023

*/
-- Database creation
DROP SCHEMA IF EXISTS ZooDB;
CREATE SCHEMA ZooDB;

-- Use of the database
USE ZooDB;

-- TABLES
-- Table Species
DROP TABLE IF EXISTS Species;
CREATE TABLE Species(
idSpecie INT NOT NULL AUTO_INCREMENT,
CommonName VARCHAR(45),
ScientificName VARCHAR(45),
GeneralDescription VARCHAR(100),
PRIMARY KEY (idSpecie)
);

-- Table Habitats
DROP TABLE IF EXISTS Habitats;
CREATE TABLE Habitats(
idHabitat INT NOT NULL AUTO_INCREMENT,
Name VARCHAR(45),
Climate VARCHAR(45),
Vegetation VARCHAR(45),
PRIMARY KEY (idHabitat)
);

-- Table Continents
DROP TABLE IF EXISTS Continents;
CREATE TABLE Continents(
idContinent INT NOT NULL AUTO_INCREMENT,
Name VARCHAR(45),
PRIMARY KEY (idContinents)
);

-- Table Species_Habitats
DROP TABLE IF EXISTS Species_Habitats;
CREATE TABLE Species_Habitats(
idSpecie INT NOT NULL,
idHabitat INT NOT NULL,
PRIMARY KEY (idSpecie, idHabitat),
FOREIGN KEY (idSpecie) REFERENCES Species(idSpecie)
ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (idHabitat) REFERENCES Habitats(idHabitat)
ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table Habitats_Continents
DROP TABLE IF EXISTS Habitats_Continents;
CREATE TABLE Habitats_Continents(
idHabitat INT NOT NULL,
idContinent INT NOT NULL,
PRIMARY KEY (idHabitat, idContinent),
FOREIGN KEY (idHabitat) REFERENCES Habitats(idHabitat)
ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (idContinent) REFERENCES Continents(idContinent)
ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table Zones
DROP TABLE IF EXISTS Zones;
CREATE TABLE Zones(
idZone INT NOT NULL AUTO_INCREMENT,
Name VARCHAR(45),
Size DECIMAL(2),
PRIMARY KEY(idZone)
);

-- Table Cages
DROP TABLE IF EXISTS Cages;
CREATE TABLE Cages(
idCage INT NOT NULL AUTO_INCREMENT,
Occupants INT,
idSpecie INT NOT NULL,
idZone INT NOT NULL,
PRIMARY KEY(idCage),
FOREIGN KEY(idSpecie) REFERENCES Species(idSpecie)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY(idZone) REFERENCES Zones(idZone)
ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Table Itineraries
DROP TABLE IF EXISTS Itineraries;
CREATE TABLE Itineraries(
idItinerary INT NOT NULL AUTO_INCREMENT,
Duration DECIMAL(1),
StartHour TIME,
EndHour TIME,
Length DECIMAL(1),
MaxPeople INT,
NoSpecies INT,
PRIMARY KEY(idItinerary)
);

-- Table Zones_Itineraries
DROP TABLE IF EXISTS Zones_Itineraries;
CREATE TABLE Zones_Itineraries(
idItinerary INT NOT NULL,
idZone INT NOT NULL,
Dates DATE,
PRIMARY KEY(idItinerary, idZone),
FOREIGN KEY(idItinerary) REFERENCES Itineraries(idItinerary)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY(idZone) REFERENCES Zones(idZone)
ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Table Influx
DROP TABLE IF EXISTS Influx;
CREATE TABLE Influx(
Dates DATE NOT NULL,
Visitors INT,
Revenue DECIMAL(2),
idItinerary INT NOT NULL,
PRIMARY KEY(Dates, idItinerary),
FOREIGN KEY(idItinerary) REFERENCES Itineraries(idItinerary)
ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Table Employees
DROP TABLE IF EXISTS Employees;
CREATE TABLE Employees(
idEmployee INT NOT NULL AUTO_INCREMENT,
Name VARCHAR(45),
Address VARCHAR(90),
Phone VARCHAR(45),
HiringDate DATE,
Manager VARCHAR(45),
Role VARCHAR(45),
PRIMARY KEY(idEmployee)
);

-- Table Salaries
DROP TABLE IF EXISTS Salaries;
CREATE TABLE Employees(
Dates DATE NOT NULL,
BaseSalary DECIMAL(2),
ExtraSalary DECIMAL(2),
ManagerExtra DECIMAL(2),
TotalSalary DECIMAL(2),
idEmployee INT NOT NULL,
PRIMARY KEY(Dates, idEmployee),
FOREIGN KEY(idEmployee) REFERENCES Employees(idEmployee)
ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table Guides
DROP TABLE IF EXISTS Guides;
CREATE TABLE Guides(
idEmployee INT NOT NULL,
idItinerary INT NOT NULL,
Dates DATE,
Hours TIME,
PRIMARY KEY(idEmployee, idItinerary),
FOREIGN KEY(idEmployee) REFERENCES Employees(idEmployee)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY(idItinerary) REFERENCES Itineraries(idItinerary)
ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Caretakers
DROP TABLE IF EXISTS Caretakers;
CREATE TABLE Caretakers(
idEmployee INT NOT NULL,
idSpecie INT NOT NULL,
Dates DATE,
PRIMARY KEY(idEmployee, idSpecie),
FOREIGN KEY(idEmployee) REFERENCES Employees(idEmployee)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY(idSpecie) REFERENCES Species(idSpecie)
ON UPDATE CASCADE ON DELETE RESTRICT
);