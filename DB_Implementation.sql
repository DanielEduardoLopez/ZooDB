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

-- Table Staff
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

-- STORED PROCEDURES
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
IN staff_name_value VARCHAR(45),
IN species_name_value VARCHAR(45),
IN caretaker_date_value DATE
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

-- Stored procedure to Delete Caretaker
DROP PROCEDURE IF EXISTS delete_caretaker;
DELIMITER //
CREATE PROCEDURE delete_caretaker(
IN staff_name_value VARCHAR(45),
IN species_name_value VARCHAR(45),
IN caretaker_date_value DATE
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
DROP PROCEDURE IF EXISTS add_salary;
DELIMITER //
CREATE PROCEDURE add_salary(
IN staff_name_value VARCHAR(45),
IN staff_role_value VARCHAR(45),
IN salary_date_value DATE,
IN month_value INT
)
BEGIN
	DECLARE staff_id_value INT;       
    DECLARE base_salary_value DECIMAL(10,2);
    DECLARE extra_salary_value DECIMAL(10,2);
	DECLARE manager_extra_value DECIMAL(10,2);
	DECLARE total_salary_value DECIMAL(10,2);
          
    SELECT staff_id
    INTO staff_id_value
    FROM staff
    WHERE staff_name = staff_name_value AND 
    staff_role = staff_role_value;
    
    -- Each employee has a base salary of $4000 
    SET base_salary_value = 4000;  
  
    -- Calculating extra salary for either a a guide or a caretaker
    IF staff_role_value = "Guide" THEN
		SELECT SUM(x.revenue) * 0.1 AS 'Extra Salary'
		INTO extra_salary_value
		FROM guide g
		INNER JOIN itinerary i
		ON g.itinerary_id = i.itinerary_id
		INNER JOIN influx x
		ON i.itinerary_id = x.itinerary_id
		AND g.guide_date = x.influx_date
		WHERE MONTH(g.guide_date) = month_value
		GROUP BY g.staff_id
		HAVING g.staff_id = staff_id_value;
    END IF;
    
    IF staff_role_value = "Caretaker" THEN   
		SELECT SUM(x.revenue) * 0.2 AS 'Extra Salary'
        INTO extra_salary_value
		FROM caretaker c
		INNER JOIN species s
		ON c.species_id = s.species_id
		INNER JOIN cage g
		ON s.species_id = g.species_id
		INNER JOIN zone z
		ON g.zone_id = z.zone_id
		INNER JOIN route r
		ON z.zone_id = r.zone_id
		INNER JOIN itinerary i
		ON r.itinerary_id = i.itinerary_id
		INNER JOIN influx x
		ON i.itinerary_id = x.itinerary_id
		AND c.caretaker_date = x.influx_date
		WHERE MONTH(c.caretaker_date) = month_value
		GROUP BY c.staff_id
		HAVING c.staff_id = staff_id_value;
    END IF;
    
    IF staff_role_value = "Manager" OR staff_role_value = "Director" THEN 
		SET extra_salary_value = 0;
	END IF;
    
    -- Each manager earns extra $1000 
    SET manager_extra_value = IF(staff_role_value = "Manager" OR staff_role_value = "Director", 1000, 0);
    
    -- Calculating total salary
    SET total_salary_value = base_salary_value + extra_salary_value + manager_extra_value;     
    
    -- Inserting values into the salary table
    INSERT INTO salary(salary_date, base_salary, extra_salary, manager_extra, total_salary, staff_id)
    VALUES (salary_date_value, base_salary_value, extra_salary_value, manager_extra_value, total_salary_value, staff_id_value);
    
    -- Displaying summary of results
    SELECT CONCAT(staff_name_value, ' - ', salary_date_value, ' - Extra Salary: ', extra_salary_value, ' - Total Salary: ', total_salary_value) AS 'Added salary';
    
END//

-- Stored procedure to Delete Salary
DROP PROCEDURE IF EXISTS delete_salary;
DELIMITER //
CREATE PROCEDURE delete_salary(
IN staff_name_value VARCHAR(45),
IN staff_role_value VARCHAR(45),
IN salary_date_value DATE
)
BEGIN

	DECLARE staff_id_value INT;
    
	SELECT staff_id
    INTO staff_id_value
    FROM staff
    WHERE staff_name = staff_name_value AND 
    staff_role = staff_role_value;
    
    DELETE FROM salary
    WHERE staff_id = staff_id_value
    AND salary_date = salary_date_value;
    
    SELECT CONCAT(staff_name_value, ' - ', salary_date_value) AS 'Deleted salary';

END//


-- FUNCTIONS

-- "Aguinaldo" (Bonus) that must be paid for the current year to each employe
DROP FUNCTION IF EXISTS calculate_aguinaldo;
DELIMITER //
CREATE FUNCTION calculate_aguinaldo(
staff_name_value VARCHAR(45),
staff_role_value VARCHAR(45)
)
RETURNS DECIMAL(10,2)
BEGIN
	
	DECLARE staff_id_value INT;
	DECLARE hiring_date_value DATE;
	DECLARE base_salary_value DECIMAL(10,2);
	DECLARE worked_years DECIMAL(10,2);
	DECLARE aguinaldo DECIMAL(10,2);
    
	SELECT staff_id
   INTO staff_id_value
   FROM staff
   WHERE staff_name = staff_name_value AND 
   staff_role = staff_role_value;
   
   SELECT hiring_date
   INTO hiring_date_value
   FROM staff
   WHERE staff_id = staff_id_value;
   
   SELECT base_salary
   INTO base_salary_value
   FROM (SELECT staff_id, MAX(salary_date), base_salary FROM salary GROUP BY staff_id) AS current_salaries
   WHERE staff_id = staff_id_value;
   
   SET worked_years = DATEDIFF(CURDATE(), hiring_date_value)/ 365;    
   
   SET aguinaldo = IF(
		DATEDIFF(DATE_ADD(MAKEDATE(YEAR(CURDATE()), 31), INTERVAL (12)-1 MONTH), hiring_date_value) / 365 < 1.0, 
		(DATEDIFF(DATE_ADD(MAKEDATE(YEAR(CURDATE()), 31), INTERVAL (12)-1 MONTH), hiring_date_value) / 365) * ( base_salary_value / 30 ) * 5,
		((DATEDIFF(DATE_ADD(MAKEDATE(YEAR(CURDATE()), 31), INTERVAL (12)-1 MONTH), hiring_date_value) DIV 365) * 2 + 5) * ( base_salary_value / 30 )
	);	
	
   RETURN aguinaldo;

END//


-- VIEWS
-- 1. Species by zone in the zoo
DROP VIEW IF EXISTS species_by_zone;
CREATE VIEW species_by_zone AS
SELECT z.zone_name, COUNT(s.species_id) AS "Number of Species"
FROM zone z
INNER JOIN cage c
ON z.zone_id = c.zone_id
INNER JOIN species s
ON  c.species_id = s.species_id
GROUP BY z.zone_name;

-- 2. Visitors per specific day, itinerary and revenue by itinerary
DROP VIEW IF EXISTS visitor_details;
CREATE VIEW visitor_details AS
SELECT influx_date AS "Date", itinerary_id AS "Itinerary", SUM(no_visitors) AS "Visitors Number", SUM(revenue) AS "Revenue" 
FROM influx 
GROUP BY influx_date, itinerary_id
ORDER BY influx_date DESC;

-- 3. Salary by guide showing the date, and amount earned per itinerary.
DROP VIEW IF EXISTS salary_by_guide;
CREATE VIEW salary_by_guide AS
SELECT DISTINCT
s.staff_name AS "Guide name", 
i.itinerary_id AS "Itinerary",
f.influx_date AS "Itinerary date",
f.revenue * 0.1 AS "Extra amount per itinerary"
FROM staff s
LEFT JOIN guide g
ON s.staff_id = g.staff_id
LEFT JOIN itinerary i
ON g.itinerary_id = i.itinerary_id
LEFT JOIN influx f
ON i.itinerary_id = f.itinerary_id
INNER JOIN salary l
ON s.staff_id = l.staff_id
WHERE s.staff_role = "Guide"
ORDER BY s.staff_name;

-- 4. Salary by caretaker showing the date, and amount earned per itinerary.
DROP VIEW IF EXISTS salary_by_caretaker;
CREATE VIEW salary_by_caretaker AS
SELECT DISTINCT
s.staff_name AS "Caretaker name", 
i.itinerary_id AS "Itinerary",
c.caretaker_date AS "Date",
f.revenue * 0.2 AS "Extra amount per itinerary and zone"
FROM staff s
INNER JOIN caretaker c
ON s.staff_id = c.staff_id
INNER JOIN species p
ON c.species_id = p.species_id
INNER JOIN cage g
ON p.species_id = g.species_id
INNER JOIN zone z
ON g.zone_id = z.zone_id
INNER JOIN route r
ON z.zone_id = r.zone_id
INNER JOIN itinerary i
ON r.itinerary_id = i.itinerary_id
INNER JOIN influx f
ON i.itinerary_id = f.itinerary_id
INNER JOIN salary l
ON s.staff_id = l.staff_id
WHERE s.staff_role = "Caretaker"
ORDER BY s.staff_name;

-- 5. Average salary by employee
DROP VIEW IF EXISTS salary_by_employee;
CREATE VIEW salary_by_employee AS 
SELECT s.staff_role AS "Position", AVG(l.total_salary) AS "Average Salary"
FROM staff s
INNER JOIN salary l
ON s.staff_id = l.staff_id
GROUP BY s.staff_role
ORDER BY AVG(l.total_salary) DESC;

-- 6. Aguinaldo by employee
DROP VIEW IF EXISTS aguinaldo_by_employee;
CREATE VIEW aguinaldo_by_employee AS
SELECT s.staff_name AS "Person", calculate_aguinaldo(s.staff_name, s.staff_role) AS "Aguinaldo"
FROM staff s;

-- 7. Visits by zone
DROP VIEW IF EXISTS visits_by_zone;
CREATE VIEW visits_by_zone AS
SELECT z.zone_name AS "Zone", f.influx_date AS "Date", SUM(f.no_visitors) AS "Visits"
FROM zone z
INNER JOIN route r
ON z.zone_id = r.zone_id
INNER JOIN itinerary i
ON r.itinerary_id = i.itinerary_id
INNER JOIN influx f
ON i.itinerary_id = f.itinerary_id
GROUP BY z.zone_name, f.influx_date;

-- 8. Species details
DROP VIEW IF EXISTS species_details;
CREATE VIEW species_details AS
SELECT DISTINCT
p.common_name AS "Name", 
p.scientific_name AS "Scientific Name",
p.general_description AS "Description",
s.staff_name AS "Caretaker",
g.cage_id AS "Cage Number",
g.occupants AS "Occupants",
z.zone_name AS "Zone"
FROM species p
INNER JOIN caretaker c
ON p.species_id = c.species_id
INNER JOIN staff s
ON c.staff_id = s.staff_id
INNER JOIN cage g
ON p.species_id = g.species_id
INNER JOIN zone z
ON g.zone_id = z.zone_id;