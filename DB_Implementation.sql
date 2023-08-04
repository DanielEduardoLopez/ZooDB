/*
Database Design and Implementation For a Zoo

Daniel Eduardo López
27/07/2023

*/
-- Database creation
DROP SCHEMA IF EXISTS zoo;
CREATE SCHEMA zoo;

-- Use of the database
USE zoo;

-- TABLES
-- Table Species
DROP TABLE IF EXISTS species;
CREATE TABLE species(
species_id INT NOT NULL AUTO_INCREMENT,
common_name VARCHAR(45),
scientific_name VARCHAR(45),
general_description VARCHAR(100),
PRIMARY KEY (species_id)
);

-- Table Habitat
DROP TABLE IF EXISTS habitat;
CREATE TABLE habitat(
habitat_id INT NOT NULL AUTO_INCREMENT,
habitat_name VARCHAR(45),
climate VARCHAR(45),
vegetation VARCHAR(45),
PRIMARY KEY (habitat_id)
);

-- Table Continents
DROP TABLE IF EXISTS continent;
CREATE TABLE continent(
continent_id INT NOT NULL AUTO_INCREMENT,
continent_name VARCHAR(45),
PRIMARY KEY (continent_id)
);

-- Table Species_Habitats
DROP TABLE IF EXISTS species_habitat;
CREATE TABLE species_habitat(
species_id INT NOT NULL,
habitat_id INT NOT NULL,
PRIMARY KEY (species_id, habitat_id),
FOREIGN KEY (species_id) REFERENCES species(species_id)
ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (habitat_id) REFERENCES habitat(habitat_id)
ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table Habitats_Continents
DROP TABLE IF EXISTS habitat_continent;
CREATE TABLE habitat_continent(
habitat_id INT NOT NULL,
continent_id INT NOT NULL,
PRIMARY KEY (habitat_id, continent_id),
FOREIGN KEY (habitat_id) REFERENCES habitat(habitat_id)
ON UPDATE CASCADE ON DELETE CASCADE,
FOREIGN KEY (continent_id) REFERENCES continent(continent_id)
ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table Zones
DROP TABLE IF EXISTS zone;
CREATE TABLE zone(
zone_id INT NOT NULL AUTO_INCREMENT,
zone_name VARCHAR(45),
size DECIMAL(2),
PRIMARY KEY(zone_id)
);

-- Table Cages
DROP TABLE IF EXISTS cage;
CREATE TABLE cage(
cage_id INT NOT NULL AUTO_INCREMENT,
occupants INT,
species_id INT NOT NULL,
zone_id INT NOT NULL,
PRIMARY KEY(cage_id),
FOREIGN KEY(species_id) REFERENCES species(species_id)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY(zone_id) REFERENCES zones(zone_id)
ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Table Itineraries
DROP TABLE IF EXISTS itinerary;
CREATE TABLE itinerary(
itinerary_id INT NOT NULL AUTO_INCREMENT,
duration DECIMAL(1),
start_hour TIME,
end_hour TIME,
itinerary_length DECIMAL(1),
max_people INT,
no_species INT,
PRIMARY KEY(itinerary_id)
);

-- Table Zones_Itineraries
DROP TABLE IF EXISTS route;
CREATE TABLE route(
itinerary_id INT NOT NULL,
zone_id INT NOT NULL,
route_date DATE,
PRIMARY KEY(itinerary_id, idZone),
FOREIGN KEY(itinerary_id) REFERENCES itinerary(itinerary_id)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY(zone_id) REFERENCES zone(zone_id)
ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Table Influx
DROP TABLE IF EXISTS influx;
CREATE TABLE influx(
influx_date DATE NOT NULL,
no_visitors INT,
revenue DECIMAL(2),
itinerary_id INT NOT NULL,
PRIMARY KEY(influx_date, itinerary_id),
FOREIGN KEY(itinerary_id) REFERENCES itinerary(itinerary_id)
ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Table Employees
DROP TABLE IF EXISTS staff;
CREATE TABLE staff(
staff_id INT NOT NULL AUTO_INCREMENT,
staff_name VARCHAR(45),
address VARCHAR(90),
phone VARCHAR(45),
hiring_date DATE,
manager VARCHAR(45),
staff_role VARCHAR(45),
PRIMARY KEY(staff_id)
);

-- Table Salaries
DROP TABLE IF EXISTS salary;
CREATE TABLE salary(
salary_date DATE NOT NULL,
base_salary DECIMAL(2),
extra_salary DECIMAL(2),
manager_extra DECIMAL(2),
total_salary DECIMAL(2),
staff_id INT NOT NULL,
PRIMARY KEY(salary_date, staff_id),
FOREIGN KEY(staff_id) REFERENCES staff(staff_id)
ON UPDATE CASCADE ON DELETE CASCADE
);

-- Table Guides
DROP TABLE IF EXISTS guide;
CREATE TABLE guide(
staff_id INT NOT NULL,
itinerary_id INT NOT NULL,
guide_date DATE,
guide_hour TIME,
PRIMARY KEY(staff_id, itinerary_id),
FOREIGN KEY(staff_id) REFERENCES staff(staff_id)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY(itinerary_id) REFERENCES itinerary(itinerary_id)
ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Caretakers
DROP TABLE IF EXISTS caretaker;
CREATE TABLE caretaker(
staff_id INT NOT NULL,
species_id INT NOT NULL,
caretaker_date DATE,
PRIMARY KEY(staff_id, idSpecies),
FOREIGN KEY(staff_id) REFERENCES staff(staff_id)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY(species_id) REFERENCES species(species_id)
ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Stored Procedure to Add Species
DROP PROCEDURE IF EXISTS add_species;
DELIMITER //
CREATE PROCEDURE add_species(
IN common_name_value VARCHAR(45),
IN scientific_name_value VARCHAR(45),
IN general_description_value VARCHAR(100)
)
BEGIN
	INSERT INTO species(common_name, scientific_name, general_description)
	VALUES (common_name_value, scientific_name_value, general_description_value);
    
	SELECT CONCAT('Added Species: ', common_name_value);
END//
DELIMITER ;

-- Adding some data for the Species Table
CALL add_species("Rabbit", "Oryctolagus cuniculus", "Small mammal in the family Leporidae.");
CALL add_species("Duck", "Anas platyrhynchos", "Dabbling duck with green head.");
CALL add_species("Guinea pig", "Cavia porcellus", "Rodent belonging to the genus Cavia in the family Caviidae.");
CALL add_species("Giant panda", "Ailuropoda melanoleuca", "Bear species endemic to China.");
CALL add_species("Mexican wolf", "Canis lupus baileyi", "Subspecies of gray wolf native to southeastern United States, and northern Mexico.");
CALL add_species("Teporingo ", "Romerolagus diazi", "Small rabbit that resides in the mountains of Mexico.");

-- Stored Procedure to Delete Species
DROP PROCEDURE IF EXISTS delete_species;
DELIMITER //
CREATE PROCEDURE delete_species(
IN species_id_value INT
)
BEGIN
	DECLARE deleted_species VARCHAR(45);

	SELECT scientific_name 
	INTO deleted_species
	FROM mytable
	WHERE species_id = species_id_value;

	DELETE FROM species
	WHERE species_id = species_id_value;
	SELECT CONCAT('Deleted Species: ', deleted_species);
END//
DELIMITER ;