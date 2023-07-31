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
FOREIGN KEY (idHabitat) REFERENCES Habitats(idHabitat),
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
ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY(idZone) REFERENCES Zones(idZone)
ON UPDATE CASCADE ON DELETE CASCADE
),
