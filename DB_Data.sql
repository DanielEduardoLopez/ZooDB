/*
Database Data

Daniel Eduardo López
14/09/2023

*/

-- Use of the database
USE zoo;

-- Adding some data for the table species 
CALL add_species("Rabbit", "Oryctolagus cuniculus", "Small mammal in the family Leporidae.");
CALL add_species("Duck", "Anas platyrhynchos", "Dabbling duck with green head.");
CALL add_species("Guinea pig", "Cavia porcellus", "Rodent belonging to the genus Cavia in the family Caviidae.");
CALL add_species("Giant panda", "Ailuropoda melanoleuca", "Bear species endemic to China.");
CALL add_species("Mexican wolf", "Canis lupus baileyi", "Subspecies of gray wolf native to southeastern United States, and northern Mexico.");
CALL add_species("Teporingo", "Romerolagus diazi", "Small rabbit that resides in the mountains of Mexico.");

-- Adding data to the table habitat
CALL add_habitat("Grassland", "Cold semi-arid", "Hedgerows, scrub, and woodland");
CALL add_habitat("Cosmopolitan", "Variable", "Variable");
CALL add_habitat("Rocky Areas", "Tundra", "Coarse vegetation");
CALL add_habitat("Forest", "Humid sub-tropical", "Bamboo");
CALL add_habitat("Forest", "Sub-tropical highland", "Pine, oak");
CALL add_habitat("Grassland", "Sub-tropical highland", "Pine, alder, grass");

-- Adding data to the table species_habitat
CALL add_species_habitat("Oryctolagus cuniculus", 1);
CALL add_species_habitat("Anas platyrhynchos", 2);
CALL add_species_habitat("Cavia porcellus", 3);
CALL add_species_habitat("Ailuropoda melanoleuca", 4);
CALL add_species_habitat("Canis lupus baileyi", 5);
CALL add_species_habitat("Romerolagus diazi", 6);

-- Adding data to the table continent
CALL add_continent('America');
CALL add_continent('Europe');
CALL add_continent('Asia');
CALL add_continent('Africa');
CALL add_continent('Oceania');
CALL add_continent('Various');

-- Adding data to the table habitat_continent
CALL add_habitat_continent(1, 'Europe');
CALL add_habitat_continent(2, 'Various');
CALL add_habitat_continent(3, 'America');
CALL add_habitat_continent(4, 'Asia');
CALL add_habitat_continent(5, 'America');
CALL add_habitat_continent(6, 'America');

-- Adding data to the table zone
CALL add_zone('Tropical forest', 1.7);
CALL add_zone('Temperate forest', 1.7);
CALL add_zone('Coastal Line', 0.9);
CALL add_zone('Aviary', 0.2);
CALL add_zone('Grasslands', 1.5);
CALL add_zone('Desert', 2.0);

-- Adding data to the table cage
CALL add_cage('Oryctolagus cuniculus', 'Grasslands', 20);
CALL add_cage('Anas platyrhynchos', 'Aviary', 10);
CALL add_cage('Cavia porcellus', 'Temperate forest', 15);
CALL add_cage('Ailuropoda melanoleuca', 'Tropical forest', 2);
CALL add_cage('Canis lupus baileyi', 'Desert', 4);
CALL add_cage('Romerolagus diazi', 'Temperate forest', 30);

-- Adding data to the itinerary table
CALL add_itinerary(1.5, '10:00', '11:30', 2.0, 10, 15);
CALL add_itinerary(1.5, '12:00', '13:30', 2.0, 10, 15);
CALL add_itinerary(1.5, '14:00', '15:30', 2.0, 10, 15);
CALL add_itinerary(1.0, '16:00', '17:00', 1.5, 10, 10);

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

-- Adding data to the Salary table
CALL add_salary('John Doe', 'Guide', '2023-08-01', 7);
CALL add_salary('Jane Doe', 'Guide', '2023-08-01', 7);
CALL add_salary('Larry Loe', 'Guide', '2023-08-01', 7);
CALL add_salary('Grace Goe', 'Caretaker', '2023-08-01', 7);
CALL add_salary('Harry Hoe', 'Caretaker', '2023-08-01', 7);
CALL add_salary('Carla Coe', 'Caretaker', '2023-08-01', 7);
CALL add_salary('Rita Roe', 'Manager', '2023-08-01', 7);
CALL add_salary('Frank Foe', 'Manager', '2023-08-01', 7);
CALL add_salary('Sammy Soe', 'Director', '2023-08-01', 7);

CALL add_salary('John Doe', 'Guide', '2023-09-01', 8);
CALL add_salary('Jane Doe', 'Guide', '2023-09-01', 8);
CALL add_salary('Larry Loe', 'Guide', '2023-09-01', 8);
CALL add_salary('Grace Goe', 'Caretaker', '2023-09-01', 8);
CALL add_salary('Harry Hoe', 'Caretaker', '2023-09-01', 8);
CALL add_salary('Carla Coe', 'Caretaker', '2023-09-01', 8);
CALL add_salary('Rita Roe', 'Manager', '2023-09-01', 8);
CALL add_salary('Frank Foe', 'Manager', '2023-09-01', 8);
CALL add_salary('Sammy Soe', 'Director', '2023-09-01', 8);

