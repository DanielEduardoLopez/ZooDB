/*
Zoo Questions

Daniel Eduardo López
07/09/2023

*/

-- Use of the database
USE zoo;

-- QUESTIONS

-- 1. It is desired to know how many species are by zone in the zoo
SELECT z.zone_name, COUNT(s.species_id) AS "Number of Species"
FROM zone z
INNER JOIN cage c
ON z.zone_id = c.zone_id
INNER JOIN species s
ON  c.species_id = s.species_id
GROUP BY z.zone_name;

-- 2. Visitors per specific day, itinerary and revenue by itinerary
SELECT SUM(no_visitors) AS "Visitors Number", SUM(revenue) AS "Revenue" 
FROM influx 
GROUP BY influx_date, itinerary_id
ORDER BY influx_date DESC;
