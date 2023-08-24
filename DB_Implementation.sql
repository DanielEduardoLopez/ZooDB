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
size DECIMAL(10, 2),
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
FOREIGN KEY(zone_id) REFERENCES zone(zone_id)
ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Table Itineraries
DROP TABLE IF EXISTS itinerary;
CREATE TABLE itinerary(
itinerary_id INT NOT NULL AUTO_INCREMENT,
duration DECIMAL(10, 1) CHECK (duration >= 1.0 AND duration <= 2.0), 
start_hour TIME,
end_hour TIME,
itinerary_length DECIMAL(10, 2),
max_people INT,
no_species INT,
PRIMARY KEY(itinerary_id),
CONSTRAINT max_people_value CHECK (max_people <= 10)
);

-- Table Route
DROP TABLE IF EXISTS route;
CREATE TABLE route(
itinerary_id INT NOT NULL,
zone_id INT NOT NULL,
PRIMARY KEY(itinerary_id, zone_id),
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
revenue DECIMAL(10, 2),
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

-- Table Guides
DROP TABLE IF EXISTS guide;
CREATE TABLE guide(
staff_id INT NOT NULL,
itinerary_id INT NOT NULL,
guide_date DATE,
guide_hour TIME,
PRIMARY KEY(staff_id, itinerary_id, guide_date),
FOREIGN KEY(staff_id) REFERENCES staff(staff_id)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY(itinerary_id) REFERENCES itinerary(itinerary_id)
ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Table Caretakers
DROP TABLE IF EXISTS caretaker;
CREATE TABLE caretaker(
staff_id INT NOT NULL,
species_id INT NOT NULL,
caretaker_date DATE,
PRIMARY KEY(staff_id, species_id, caretaker_date),
FOREIGN KEY(staff_id) REFERENCES staff(staff_id)
ON UPDATE CASCADE ON DELETE RESTRICT,
FOREIGN KEY(species_id) REFERENCES species(species_id)
ON UPDATE CASCADE ON DELETE RESTRICT
);

-- Table Salaries
DROP TABLE IF EXISTS salary;
CREATE TABLE salary(
salary_date DATE NOT NULL,
base_salary DECIMAL(10, 2),
extra_salary DECIMAL(10, 2),
manager_extra DECIMAL(10, 2),
total_salary DECIMAL(10, 2),
staff_id INT NOT NULL,
PRIMARY KEY(salary_date, staff_id),
FOREIGN KEY(staff_id) REFERENCES staff(staff_id)
ON UPDATE CASCADE ON DELETE CASCADE
);

-- STORES PROCEDURES
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
    
	SELECT common_name_value AS 'Added Species';
END//
DELIMITER ;

-- Adding some data for the Species Table
CALL add_species("Rabbit", "Oryctolagus cuniculus", "Small mammal in the family Leporidae.");
CALL add_species("Duck", "Anas platyrhynchos", "Dabbling duck with green head.");
CALL add_species("Guinea pig", "Cavia porcellus", "Rodent belonging to the genus Cavia in the family Caviidae.");
CALL add_species("Giant panda", "Ailuropoda melanoleuca", "Bear species endemic to China.");
CALL add_species("Mexican wolf", "Canis lupus baileyi", "Subspecies of gray wolf native to southeastern United States, and northern Mexico.");
CALL add_species("Teporingo", "Romerolagus diazi", "Small rabbit that resides in the mountains of Mexico.");

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
	FROM species
	WHERE species_id = species_id_value;

	DELETE FROM species
	WHERE species_id = species_id_value;
	
	SELECT deleted_species AS 'Deleted Species';
END//
DELIMITER ;

-- Stored Procedure to Add Habitats
DROP PROCEDURE IF EXISTS add_habitat;
DELIMITER //
CREATE PROCEDURE add_habitat(
IN habitat_name_value VARCHAR(45),
IN climate_value VARCHAR(45),
IN vegetation_value VARCHAR(45)
)
BEGIN
	INSERT INTO habitat(habitat_name, climate, vegetation)
	VALUES (habitat_name_value, climate_value, vegetation_value);
    
	SELECT habitat_name_value AS 'Added Habitat';
END//
DELIMITER ;

-- Adding data to the table habitat
CALL add_habitat("Grassland", "Cold semi-arid", "Hedgerows, scrub, and woodland");
CALL add_habitat("Cosmopolitan", "Variable", "Variable");
CALL add_habitat("Rocky Areas", "Tundra", "Coarse vegetation");
CALL add_habitat("Forest", "Humid sub-tropical", "Bamboo");
CALL add_habitat("Forest", "Sub-tropical highland", "Pine, oak");
CALL add_habitat("Grassland", "Sub-tropical highland", "Pine, alder, grass");

-- Stored Procedure to Delete Habitats
DROP PROCEDURE IF EXISTS delete_habitat;
DELIMITER //
CREATE PROCEDURE delete_habitat(
IN habitat_id_value VARCHAR(45)
)
BEGIN
	DECLARE deleted_habitat VARCHAR(45);
	
	SELECT habitat_name 
	INTO deleted_habitat
	FROM habitat 
	WHERE habitat_id = habitat_id_value;
	
	DELETE FROM habitat
	WHERE habitat_id = habitat_id_value;
    
	SELECT deleted_habitat AS 'Deleted Habitat';
END//
DELIMITER ;

-- Stored Procedure to Add species_habitat
DROP PROCEDURE IF EXISTS add_species_habitat;
DELIMITER //
CREATE PROCEDURE add_species_habitat(
IN scientific_name_value VARCHAR(45),
IN habitat_id_value INT
)
BEGIN
	DECLARE species_id_value INT;
    DECLARE habitat_name_value VARCHAR(45);
	
	SELECT species_id
	INTO species_id_value
	FROM species
	WHERE scientific_name = scientific_name_value;
			
	SELECT habitat_name
	INTO habitat_name_value
	FROM habitat
	WHERE habitat_id = habitat_id_value;

	INSERT INTO species_habitat(species_id, habitat_id)
	VALUES (species_id_value, habitat_id_value);
    
	SELECT CONCAT(scientific_name_value, "-", habitat_name_value) AS 'Added Species-Habitat Relationship';
END//
DELIMITER ;

-- Adding data to the table species_habitat
CALL add_species_habitat("Oryctolagus cuniculus", 1);
CALL add_species_habitat("Anas platyrhynchos", 2);
CALL add_species_habitat("Cavia porcellus", 3);
CALL add_species_habitat("Ailuropoda melanoleuca", 4);
CALL add_species_habitat("Canis lupus baileyi", 5);
CALL add_species_habitat("Romerolagus diazi", 6);


-- Stored Procedure to Delete species_habitat
DROP PROCEDURE IF EXISTS delete_species_habitat;
DELIMITER //
CREATE PROCEDURE delete_species_habitat(
IN scientific_name_value VARCHAR(45),
IN habitat_id_value INT
)
BEGIN
	DECLARE species_id_value INT;
    DECLARE habitat_name_value VARCHAR(45);
	
	SELECT species_id
	INTO species_id_value
	FROM species
	WHERE scientific_name = scientific_name_value;
		
	SELECT habitat_name
	INTO habitat_name_value
	FROM habitat
	WHERE habitat_id = habitat_id_value;
	
    SET FOREIGN_KEY_CHECKS = 0;
    
	DELETE FROM species_habitat
	WHERE habitat_id = habitat_id_value AND species_id = species_id_value;
    
    SET FOREIGN_KEY_CHECKS = 1;
    
	SELECT CONCAT(scientific_name_value, "-", habitat_name_value) AS 'Deleted Species-Habitat Relationship';
END//
DELIMITER ;

-- Stored Procedure to Add Continents
DROP PROCEDURE IF EXISTS add_continent;
DELIMITER //
CREATE PROCEDURE add_continent(
IN continent_name_value VARCHAR(45)
)
BEGIN

	INSERT INTO continent(continent_name)
	VALUES (continent_name_value);
    
	SELECT continent_name_value AS 'Added Continent';
END//
DELIMITER ;

-- Adding data to the table continent
CALL add_continent('America');
CALL add_continent('Europe');
CALL add_continent('Asia');
CALL add_continent('Africa');
CALL add_continent('Oceania');
CALL add_continent('Various');

-- Stored Procedure to Delete Continents
DROP PROCEDURE IF EXISTS delete_continent;
DELIMITER //
CREATE PROCEDURE delete_continent(
IN continent_name_value VARCHAR(45)
)
BEGIN

	DECLARE continent_id_value INT;

	SELECT continent_id
	INTO continent_id_value
	FROM continent
	WHERE continent_name = continent_name_value;

	DELETE FROM continent
	WHERE continent_id = continent_id_value;
    
	SELECT continent_name_value AS 'Deleted Continent';
END//
DELIMITER ;


-- Stored Procedure to Add Habitat-Continents
DROP PROCEDURE IF EXISTS add_habitat_continent;
DELIMITER //
CREATE PROCEDURE add_habitat_continent(
IN habitat_id_value INT,
IN continent_name_value VARCHAR(45)
)
BEGIN
	DECLARE continent_id_value INT;
    DECLARE habitat_name_value VARCHAR(45);
	
	SELECT continent_id
	INTO continent_id_value
	FROM continent
	WHERE continent_name = continent_name_value;
			
	SELECT habitat_name
	INTO habitat_name_value
	FROM habitat
	WHERE habitat_id = habitat_id_value;

	INSERT INTO habitat_continent(habitat_id, continent_id)
	VALUES (habitat_id_value, continent_id_value);
    
	SELECT CONCAT(habitat_name_value, "-", continent_name_value) AS 'Added Habitat-Continent Relationship';
END//
DELIMITER ;

-- Adding data to the table habitat_continent
CALL add_habitat_continent(1, 'Europe');
CALL add_habitat_continent(2, 'Various');
CALL add_habitat_continent(3, 'America');
CALL add_habitat_continent(4, 'Asia');
CALL add_habitat_continent(5, 'America');
CALL add_habitat_continent(6, 'America');

-- Stored Procedure to Delete species_habitat
DROP PROCEDURE IF EXISTS delete_habitat_continent;
DELIMITER //
CREATE PROCEDURE delete_habitat_continent(
IN habitat_id_value INT,
IN continent_name_value VARCHAR(45)
)
BEGIN
	DECLARE continent_id_value INT;
    DECLARE habitat_name_value VARCHAR(45);
	
	SELECT continent_id
	INTO continent_id_value
	FROM continent
	WHERE continent_name = continent_name_value;
			
	SELECT habitat_name
	INTO habitat_name_value
	FROM habitat
	WHERE habitat_id = habitat_id_value;
	
    SET FOREIGN_KEY_CHECKS = 0;
    
	DELETE FROM habitat_continent
	WHERE habitat_id = habitat_id_value AND continent_id = continent_id_value;
    
    SET FOREIGN_KEY_CHECKS = 1;
    
	SELECT CONCAT(habitat_name_value, "-", continent_name_value) AS 'Deleted Habitat-Continent Relationship';
END//
DELIMITER ;

-- Stored Procedure to Add Zones
DROP PROCEDURE IF EXISTS add_zone;
DELIMITER //
CREATE PROCEDURE add_zone(
IN zone_name_value VARCHAR(45),
IN size_value DECIMAL(10, 2)
)
BEGIN

	INSERT INTO zone(zone_name, size)
	VALUES (zone_name_value, size_value);
    
	SELECT zone_name_value AS 'Added Zone';
END//
DELIMITER ;

-- Adding data to the table zone
CALL add_zone('Tropical forest', 1.7);
CALL add_zone('Temperate forest', 1.7);
CALL add_zone('Coastal Line', 0.9);
CALL add_zone('Aviary', 0.2);
CALL add_zone('Grasslands', 1.5);
CALL add_zone('Desert', 2.0);

-- Stored Procedure to Delete Zones
DROP PROCEDURE IF EXISTS delete_zone;
DELIMITER //
CREATE PROCEDURE delete_zone(
IN zone_name_value VARCHAR(45)
)
BEGIN
	DECLARE zone_id_value INT;
    
    SELECT zone_id
    INTO zone_id_value
    FROM zone
    WHERE zone_name = zone_name_value;
    
    DELETE FROM zone
    WHERE zone_id = zone_id_value;
    
    SELECT zone_name_value AS 'Deleted Zone';
END//

-- Stored Procedure to Add Cages
DROP PROCEDURE IF EXISTS add_cage;
DELIMITER //
CREATE PROCEDURE add_cage(
IN scientific_name_value VARCHAR(45),
IN zone_name_value VARCHAR(45),
IN occupants_value INT
)
BEGIN
	DECLARE species_id_value INT;
    DECLARE zone_id_value INT;
    
    SELECT species_id
    INTO species_id_value
    FROM species
    WHERE scientific_name = scientific_name_value;
    
    SELECT zone_id
    INTO zone_id_value
    FROM zone
    WHERE zone_name = zone_name_value;
    
    INSERT INTO cage(occupants, species_id, zone_id)
    VALUES (occupants_value, species_id_value, zone_id_value);    
    
    SELECT CONCAT(occupants_value, ' ', scientific_name_value, ' in ', zone_name_value) AS 'Added Cage';
END//

-- Adding data to the table cage
CALL add_cage('Oryctolagus cuniculus', 'Grasslands', 20);
CALL add_cage('Anas platyrhynchos', 'Aviary', 10);
CALL add_cage('Cavia porcellus', 'Temperate forest', 15);
CALL add_cage('Ailuropoda melanoleuca', 'Tropical forest', 2);
CALL add_cage('Canis lupus baileyi', 'Desert', 4);
CALL add_cage('Romerolagus diazi', 'Temperate forest', 30);


-- Store procedure to Delete Cages
DROP PROCEDURE IF EXISTS delete_cage;
DELIMITER //
CREATE PROCEDURE delete_cage(
IN cage_id_value INT
)
BEGIN
	SET FOREIGN_KEY_CHECKS = 0;

    DELETE FROM cage
    WHERE cage_id = cage_id_value;
    
    SET FOREIGN_KEY_CHECKS = 1;
    
    SELECT cage_id_value AS 'Deleted Cage';
END//

-- Stored procedure to Add Itineraries
DROP PROCEDURE IF EXISTS add_itinerary;
DELIMITER //
CREATE PROCEDURE add_itinerary(
IN duration_value DECIMAL(1),
IN start_hour_value TIME,
IN end_hour_value TIME,
IN itinerary_length_value DECIMAL(1),
IN max_people_value INT,
IN no_species_value INT
)
BEGIN
	INSERT INTO itinerary(duration, start_hour, end_hour, itinerary_length, max_people, no_species)
    VALUES (duration_value, start_hour_value, end_hour_value, itinerary_length_value, max_people_value, no_species_value);
    
    SELECT CONCAT('From ', start_hour_value,' to ', end_hour_value) AS 'Added Itinerary';
END//

-- Adding data to the itinerary table
CALL add_itinerary(1.5, '10:00', '11:30', 2.0, 10, 15);
CALL add_itinerary(1.5, '12:00', '13:30', 2.0, 10, 15);
CALL add_itinerary(1.5, '14:00', '15:30', 2.0, 10, 15);
CALL add_itinerary(1.0, '16:00', '17:00', 1.5, 10, 10);

-- Stored procedure to Delete Itineraries
DROP PROCEDURE IF EXISTS delete_itinerary;
DELIMITER //
CREATE PROCEDURE delete_itinerary(
IN itinerary_id_value INT
)
BEGIN
	SET FOREIGN_KEY_CHECKS = 0;
    
	DELETE FROM itinerary
    WHERE itinerary_id = itinerary_id_value;
    
    SET FOREIGN_KEY_CHECKS = 1;
END//

-- Stored procedure to Add Routes
DROP PROCEDURE IF EXISTS add_route;
DELIMITER //
CREATE PROCEDURE add_route(
IN itinerary_id_value INT,
IN zone_name_value VARCHAR(45)
)
BEGIN
	DECLARE zone_id_value INT;
    
	SELECT zone_id
    INTO zone_id_value
    FROM zone
    WHERE zone_name = zone_name_value;
    
    INSERT INTO route(itinerary_id, zone_id)
    VALUES (itinerary_id_value, zone_id_value);
    
    SELECT CONCAT(itinerary_id_value, ' - ', zone_name_value) AS 'Added Route';    
END//

-- Adding Data to the Route table
CALL add_route(1, 'Tropical forest');
CALL add_route(1, 'Temperate forest');
CALL add_route(1, 'Grasslands');
CALL add_route(2, 'Coastal Line');
CALL add_route(2, 'Aviary');
CALL add_route(2, 'Desert');
CALL add_route(3, 'Tropical forest');
CALL add_route(3, 'Aviary');
CALL add_route(3, 'Grasslands');
CALL add_route(4, 'Aviary');
CALL add_route(4, 'Desert');

-- Stored Procedure to Delete Routes
DROP PROCEDURE IF EXISTS delete_route;
DELIMITER //
CREATE PROCEDURE delete_route(
IN itinerary_id_value INT,
IN zone_name_value VARCHAR(45)
)
BEGIN
	DECLARE zone_id_value INT;
    
	SELECT zone_id
    INTO zone_id_value
    FROM zone
    WHERE zone_name = zone_name_value;
    
	SET FOREIGN_KEY_CHECKS = 0;
    
	DELETE FROM route
    WHERE itinerary_id = itinerary_id_value AND zone_id = zone_id_value;
    
    SET FOREIGN_KEY_CHECKS = 1;
    
END//

-- Stored procedure to Add influx
DROP PROCEDURE IF EXISTS add_influx;
DELIMITER //
CREATE PROCEDURE add_influx(
IN itinerary_id_value INT,
IN influx_date_value DATE,
IN no_visitors_value INT,
IN revenue_value DECIMAL(10, 2)
)
BEGIN
	
    INSERT INTO influx(itinerary_id, influx_date, no_visitors, revenue)
    VALUES (itinerary_id_value, influx_date_value, no_visitors_value, revenue_value);

	SELECT CONCAT('The itinerary ', itinerary_id_value, ' had an influx of ', no_visitors_value, ' visitors and $', revenue_value, ' on ', influx_date_value) AS 'Added Influx';
    
END//

-- Adding data to the table influx
CALL add_influx(1, '2023-07-01', 6, 120.00);
CALL add_influx(2, '2023-07-01', 10, 200.00);
CALL add_influx(3, '2023-07-01', 8, 160.00);
CALL add_influx(4, '2023-07-01', 4, 80.00);
CALL add_influx(1, '2023-07-08', 8, 160.00);
CALL add_influx(2, '2023-07-08', 9, 180.00);
CALL add_influx(3, '2023-07-08', 8, 160.00);
CALL add_influx(4, '2023-07-08', 5, 100.00);
CALL add_influx(1, '2023-07-15', 8, 160.00);
CALL add_influx(2, '2023-07-15', 10, 200.00);
CALL add_influx(3, '2023-07-15', 10, 200.00);
CALL add_influx(4, '2023-07-15', 7, 140.00);
CALL add_influx(1, '2023-07-22', 8, 160.00);
CALL add_influx(2, '2023-07-22', 10, 200.00);
CALL add_influx(3, '2023-07-22', 10, 200.00);
CALL add_influx(4, '2023-07-22', 7, 140.00);
CALL add_influx(1, '2023-07-29', 8, 160.00);
CALL add_influx(2, '2023-07-29', 9, 180.00);
CALL add_influx(3, '2023-07-29', 8, 160.00);
CALL add_influx(4, '2023-07-29', 5, 100.00);

CALL add_influx(1, '2023-08-05', 6, 120.00);
CALL add_influx(2, '2023-08-05', 10, 200.00);
CALL add_influx(3, '2023-08-05', 8, 160.00);
CALL add_influx(4, '2023-08-05', 4, 80.00);
CALL add_influx(1, '2023-08-12', 8, 160.00);
CALL add_influx(2, '2023-08-12', 9, 180.00);
CALL add_influx(3, '2023-08-12', 8, 160.00);
CALL add_influx(4, '2023-08-12', 5, 100.00);
CALL add_influx(1, '2023-08-19', 8, 160.00);
CALL add_influx(2, '2023-08-19', 10, 200.00);
CALL add_influx(3, '2023-08-19', 10, 200.00);
CALL add_influx(4, '2023-08-19', 7, 140.00);
CALL add_influx(1, '2023-08-26', 8, 160.00);
CALL add_influx(2, '2023-08-26', 10, 200.00);
CALL add_influx(3, '2023-08-26', 10, 200.00);
CALL add_influx(4, '2023-08-26', 7, 140.00);

-- Stored procedure to delete influx
DROP PROCEDURE IF EXISTS delete_influx;
DELIMITER //
CREATE PROCEDURE delete_influx(
IN itinerary_id_value INT,
IN influx_date_value DATE
)
BEGIN

	SET FOREIGN_KEY_CHECKS = 0;
    
    DELETE FROM influx
    WHERE itinerary_id = itinerary_id_value AND influx_date = influx_date_value;
    
    SET FOREIGN_KEY_CHECKS = 1;

END//

-- Stored procedure to Add Staff
DROP PROCEDURE IF EXISTS add_staff;
DELIMITER //
CREATE PROCEDURE add_staff(
IN staff_name_value VARCHAR(45),
IN address_value VARCHAR(90),
IN phone_value VARCHAR(45),
IN hiring_date_value DATE,
IN manager_value VARCHAR(45),
IN staff_role_value VARCHAR(45)
)
BEGIN
	INSERT INTO staff(staff_name, address, phone, hiring_date, manager, staff_role)
    VALUES (staff_name_value, address_value, phone_value, hiring_date_value, manager_value, staff_role_value);
    
    SELECT CONCAT(staff_name_value, ' - ', staff_role_value) AS 'Added staff';
END//

-- Adding data to table staff
CALL add_staff('John Doe', '1357 Blane Street, Chicago, IL 67105', '(312) 555-0100', '2023-05-18', 'Rita Roe', 'Guide');
CALL add_staff('Jane Doe', '8563 Dr. Waker Avenue, Chicago, IL 69852', '(312) 555-8110', '2023-07-01', 'Rita Roe', 'Guide');
CALL add_staff('Larry Loe', '1986 Oakbroak Street, Chicago, IL 68150', '(312) 555-1586', '2023-03-15', 'Rita Roe', 'Guide');
CALL add_staff('Grace Goe', '7895 Washington Street, Chicago, IL 65983', '(312) 555-7896', '2023-04-15', 'Frank Foe', 'Caretaker');
CALL add_staff('Harry Hoe', '1235 Lincoln Street, Chicago, IL 67894', '(312) 555-1235', '2023-05-01', 'Frank Foe', 'Caretaker');
CALL add_staff('Carla Coe', '6532 Shire Street, Chicago, IL 66897', '(312) 555-7842', '2023-03-15', 'Frank Foe', 'Caretaker');
CALL add_staff('Rita Roe', '1555 Los Alamos Street, Chicago, IL 68150', '(312) 555-1453', '2023-01-01', 'Sammy Soe', 'Manager');
CALL add_staff('Frank Foe', '2569 John Knox Street, Chicago, IL 68150', '(312) 555-3698', '2023-01-01', 'Sammy Soe', 'Manager');
CALL add_staff('Sammy Soe', '1278 Charles Babbage Street, Chicago, IL 67891', '(312) 555-7879', '2023-01-01', 'Owners', 'Director');

-- Stored procedure to Delete Staff
DROP PROCEDURE IF EXISTS delete_staff;
DELIMITER //
CREATE PROCEDURE delete_staff(
IN staff_name_value VARCHAR(45),
IN staff_role_value VARCHAR(45)
)
BEGIN
	
    DECLARE staff_id_value INT;
    
    SELECT staff_id
    INTO staff_id_value
    FROM staff
    WHERE staff_name = staff_name_value AND 
    staff_role = staff_role_value;
    
	SET FOREIGN_KEY_CHECKS = 0;
    
    DELETE FROM staff
    WHERE staff_id = staff_id_value;
    
    SET FOREIGN_KEY_CHECKS = 1;
    
    SELECT CONCAT(staff_name_value, ' - ', staff_role_value) AS 'Deleted Staff';

END//

-- Stored procedure to update a tuple in the table Staff
DROP PROCEDURE IF EXISTS update_staff;
DELIMITER //
CREATE PROCEDURE update_staff(
IN staff_name_value VARCHAR(45),
IN staff_role_value VARCHAR(45),
IN staff_name_new_value VARCHAR(45),
IN address_new_value VARCHAR(90),
IN phone_new_value VARCHAR(45),
IN hiring_date_new_value DATE,
IN manager_new_value VARCHAR(45),
IN staff_role_new_value VARCHAR(45)
)
BEGIN

	DECLARE staff_id_value INT;
    
    SELECT staff_id
    INTO staff_id_value
    FROM staff
    WHERE staff_name = staff_name_value AND
    staff_role = staff_role_value;
    
    UPDATE staff
    SET staff_name = staff_name_new_value, 
    address = address_new_value,
    phone = phone_new_value,
    hiring_date = hiring_date_new_value,
    manager = manager_new_value,
    staff_role = staff_role_new_value
    WHERE staff_id = staff_id_value;
    
    SELECT CONCAT(staff_name_new_value, ' - ', staff_role_new_value) AS 'Updated Staff';
    
END//

-- Stored procedure to Add Guides
DROP PROCEDURE IF EXISTS add_guide;
DELIMITER //
CREATE PROCEDURE add_guide(
IN staff_name_value VARCHAR(45),
IN itinerary_id_value INT,
IN guide_date_value DATE
)
BEGIN

	DECLARE staff_id_value INT;
    DECLARE guide_hour_value TIME;
    
    SELECT staff_id 
    INTO staff_id_value
    FROM staff
    WHERE staff_name = staff_name_value AND
    staff_role = "Guide";
    
    SELECT start_hour
    INTO guide_hour_value
    FROM itinerary
    WHERE itinerary_id = itinerary_id_value;
    
    INSERT INTO guide(staff_id, itinerary_id, guide_date, guide_hour)
    VALUES (staff_id_value, itinerary_id_value, guide_date_value, guide_hour_value);    
           
END//

-- Adding data to the table guide
CALL add_guide('John Doe', 1, '2023-07-01');
CALL add_guide('Jane Doe', 2, '2023-07-01');
CALL add_guide('Larry Loe', 3, '2023-07-01');
CALL add_guide('John Doe', 4, '2023-07-01');
CALL add_guide('John Doe', 1, '2023-07-08');
CALL add_guide('Jane Doe', 2, '2023-07-08');
CALL add_guide('Larry Loe', 3, '2023-07-08');
CALL add_guide('Jane Doe', 4, '2023-07-08');
CALL add_guide('John Doe', 1, '2023-07-15');
CALL add_guide('Jane Doe', 2, '2023-07-15');
CALL add_guide('Larry Loe', 3, '2023-07-15');
CALL add_guide('Larry Loe', 4, '2023-07-15');
CALL add_guide('John Doe', 1, '2023-07-22');
CALL add_guide('Jane Doe', 2, '2023-07-22');
CALL add_guide('Larry Loe', 3, '2023-07-22');
CALL add_guide('John Doe', 4, '2023-07-22');
CALL add_guide('John Doe', 1, '2023-07-29');
CALL add_guide('Jane Doe', 2, '2023-07-29');
CALL add_guide('Larry Loe', 3, '2023-07-29');
CALL add_guide('Jane Doe', 4, '2023-07-29');

CALL add_guide('John Doe', 1, '2023-08-05');
CALL add_guide('Jane Doe', 2, '2023-08-05');
CALL add_guide('Larry Loe', 3, '2023-08-05');
CALL add_guide('John Doe', 4, '2023-08-05');
CALL add_guide('John Doe', 1, '2023-08-12');
CALL add_guide('Jane Doe', 2, '2023-08-12');
CALL add_guide('Larry Loe', 3, '2023-08-12');
CALL add_guide('Jane Doe', 4, '2023-08-12');
CALL add_guide('John Doe', 1, '2023-08-19');
CALL add_guide('Jane Doe', 2, '2023-08-19');
CALL add_guide('Larry Loe', 3, '2023-08-19');
CALL add_guide('Larry Loe', 4, '2023-08-19');
CALL add_guide('John Doe', 1, '2023-08-26');
CALL add_guide('Jane Doe', 2, '2023-08-26');
CALL add_guide('Larry Loe', 3, '2023-08-26');
CALL add_guide('John Doe', 4, '2023-08-26');

-- Stored procedure to Delete Guides
DROP PROCEDURE IF EXISTS delete_guide;
DELIMITER //
CREATE PROCEDURE delete_guide(
IN staff_name_value VARCHAR(45),
IN itinerary_id_value INT,
IN guide_date_value DATE
)
BEGIN
	
    DECLARE staff_id_value INT;
    
    SELECT staff_id
    INTO staff_id_value
    FROM staff
    WHERE staff_name = staff_name_value
    AND staff_role = "Guide";
    
    SET FOREIGN_KEY_CHECKS = 0;
    
    DELETE FROM guide
    WHERE staff_id = staff_id_value
    AND itinerary_id = itinerary_id_value
    AND guide_date = guide_date_value;
    
    SET FOREIGN_KEY_CHECKS = 1;
	
END//

-- Stored procedure to Add Caretakers
DROP PROCEDURE IF EXISTS add_caretaker;
DELIMITER //
CREATE PROCEDURE add_caretaker(
staff_name_value VARCHAR(45),
species_name_value VARCHAR(45),
caretaker_date_value DATE
)
BEGIN
	
    DECLARE staff_id_value INT;
    DECLARE species_id_value INT;
    
    SELECT staff_id
    INTO staff_id_value
    FROM staff
    WHERE staff_name = staff_name_value
    AND staff_role = "Caretaker";
    
	SELECT species_id
    INTO species_id_value
    FROM species
    WHERE common_name = species_name_value;
    
    INSERT INTO caretaker(staff_id, species_id, caretaker_date)
    VALUES (staff_id_value, species_id_value, caretaker_date_value);          

END//

-- Adding data to Caretaker table
CALL add_caretaker('Grace Goe', 'Rabbit', '2023-07-01');
CALL add_caretaker('Grace Goe', 'Duck', '2023-07-01');
CALL add_caretaker('Grace Goe', 'Guinea pig', '2023-07-01');
CALL add_caretaker('Harry Hoe', 'Giant panda', '2023-07-01');
CALL add_caretaker('Harry Hoe', 'Mexican wolf', '2023-07-01');
CALL add_caretaker('Harry Hoe', 'Teporingo', '2023-07-01');
CALL add_caretaker('Carla Coe', 'Rabbit', '2023-07-08');
CALL add_caretaker('Carla Coe', 'Duck', '2023-07-08');
CALL add_caretaker('Carla Coe', 'Guinea pig', '2023-07-08');
CALL add_caretaker('Harry Hoe', 'Giant panda', '2023-07-08');
CALL add_caretaker('Harry Hoe', 'Mexican wolf', '2023-07-08');
CALL add_caretaker('Harry Hoe', 'Teporingo', '2023-07-08');
CALL add_caretaker('Carla Coe', 'Rabbit', '2023-07-15');
CALL add_caretaker('Carla Coe', 'Duck', '2023-07-15');
CALL add_caretaker('Carla Coe', 'Guinea pig', '2023-07-15');
CALL add_caretaker('Grace Goe', 'Giant panda', '2023-07-15');
CALL add_caretaker('Grace Goe', 'Mexican wolf', '2023-07-15');
CALL add_caretaker('Grace Goe', 'Teporingo', '2023-07-15');
CALL add_caretaker('Carla Coe', 'Rabbit', '2023-07-22');
CALL add_caretaker('Carla Coe', 'Duck', '2023-07-22');
CALL add_caretaker('Carla Coe', 'Guinea pig', '2023-07-22');
CALL add_caretaker('Harry Hoe', 'Giant panda', '2023-07-22');
CALL add_caretaker('Harry Hoe', 'Mexican wolf', '2023-07-22');
CALL add_caretaker('Harry Hoe', 'Teporingo', '2023-07-22');
CALL add_caretaker('Grace Goe', 'Rabbit', '2023-07-29');
CALL add_caretaker('Grace Goe', 'Duck', '2023-07-29');
CALL add_caretaker('Grace Goe', 'Guinea pig', '2023-07-29');
CALL add_caretaker('Harry Hoe', 'Giant panda', '2023-07-29');
CALL add_caretaker('Harry Hoe', 'Mexican wolf', '2023-07-29');
CALL add_caretaker('Harry Hoe', 'Teporingo', '2023-07-29');

CALL add_caretaker('Grace Goe', 'Rabbit', '2023-08-05');
CALL add_caretaker('Grace Goe', 'Duck', '2023-08-05');
CALL add_caretaker('Grace Goe', 'Guinea pig', '2023-08-05');
CALL add_caretaker('Harry Hoe', 'Giant panda', '2023-08-05');
CALL add_caretaker('Harry Hoe', 'Mexican wolf', '2023-08-05');
CALL add_caretaker('Harry Hoe', 'Teporingo', '2023-08-05');
CALL add_caretaker('Carla Coe', 'Rabbit', '2023-08-12');
CALL add_caretaker('Carla Coe', 'Duck', '2023-08-12');
CALL add_caretaker('Carla Coe', 'Guinea pig', '2023-08-12');
CALL add_caretaker('Harry Hoe', 'Giant panda', '2023-08-12');
CALL add_caretaker('Harry Hoe', 'Mexican wolf', '2023-08-12');
CALL add_caretaker('Harry Hoe', 'Teporingo', '2023-08-12');
CALL add_caretaker('Carla Coe', 'Rabbit', '2023-08-19');
CALL add_caretaker('Carla Coe', 'Duck', '2023-08-19');
CALL add_caretaker('Carla Coe', 'Guinea pig', '2023-08-19');
CALL add_caretaker('Grace Goe', 'Giant panda', '2023-08-19');
CALL add_caretaker('Grace Goe', 'Mexican wolf', '2023-08-19');
CALL add_caretaker('Grace Goe', 'Teporingo', '2023-08-19');
CALL add_caretaker('Carla Coe', 'Rabbit', '2023-08-26');
CALL add_caretaker('Carla Coe', 'Duck', '2023-08-26');
CALL add_caretaker('Carla Coe', 'Guinea pig', '2023-08-26');
CALL add_caretaker('Harry Hoe', 'Giant panda', '2023-08-26');
CALL add_caretaker('Harry Hoe', 'Mexican wolf', '2023-08-26');
CALL add_caretaker('Harry Hoe', 'Teporingo', '2023-08-26');

-- Stored procedure to Delete Caretaker
DROP PROCEDURE IF EXISTS delete_caretaker;
DELIMITER //
CREATE PROCEDURE delete_caretaker(
staff_name_value VARCHAR(45),
species_name_value VARCHAR(45),
caretaker_date_value DATE
)
BEGIN
    DECLARE staff_id_value INT;
    DECLARE species_id_value INT;
    
    SELECT staff_id
    INTO staff_id_value
    FROM staff
    WHERE staff_name = staff_name_value
    AND staff_role = "Caretaker";
    
	SELECT species_id
    INTO species_id_value
    FROM species
    WHERE common_name = species_name_value;
    
    DELETE FROM caretaker
    WHERE staff_id = staff_id_value
    AND species_id = species_id_value
    AND caretaker_date = caretaker_date_value;

END//

-- Stored procedure to Add Salary
/*
DROP PROCEDURE IF EXISTS add_salary;
DELIMITER //
CREATE PROCEDURE add_salary(
IN staff_name_value VARCHAR(45),
IN staff_role_value VARCHAR(45),
IN salary_date_value DATE,
IN base_salary_value DECIMAL(10, 2),
IN extra_salary_value DECIMAL(10, 2)
)
BEGIN
	DECLARE staff_id_value INT;       
    DECLARE manager_extra_value DECIMAL(5,2);
    DECLARE total_salary_value DECIMAL(5,2);
          
    SELECT staff_id
    INTO staff_id_value
    FROM staff
    WHERE staff_name = staff_name_value AND 
    staff_role = staff_role_value;
    
    SET manager_extra_value = IF(staff_role_value = "Manager" OR staff_role_value = "Director", 1000, 0);
    
    SET total_salary_value = base_salary_value + extra_salary_value + manager_extra_value
    
    -- Each manager earns extra $1000 
    
    INSERT INTO salary(salary_date, base_salary, extra_salary, manager_extra, total_salary, staff_id)
    VALUES (salary_date_value, base_salary_value, extra_salary_value, manager_extra_value, total_salary_value, staff_id_value)
    
    SELECT CONCAT(staff_name_value, ' - ', salary_date_value, ' - ', total_salary_value) AS 'Added salary':
    
END//
*/