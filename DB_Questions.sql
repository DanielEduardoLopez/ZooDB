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
SELECT influx_date AS "Date", itinerary_id AS "Itinerary", SUM(no_visitors) AS "Visitors Number", SUM(revenue) AS "Revenue" 
FROM influx 
GROUP BY influx_date, itinerary_id
ORDER BY influx_date DESC;

-- 3. Salary paid to each guide, showing the date, and amount earned per itinerary.
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
ORDER BY "Guide name";

-- 4. Salary paid to each caretaker, showing the date, amount earned per itinerary that corresponds to their area
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
ORDER BY "Caretaker name";
