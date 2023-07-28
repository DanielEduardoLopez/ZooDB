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


