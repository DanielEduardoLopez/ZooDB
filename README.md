# Zoo Database
#### Daniel Eduardo López

<font size="-1"><a href="https://www.linkedin.com/in/daniel-eduardo-lopez">LinkedIn</a> | <a href="https://github.com/DanielEduardoLopez">GitHub </a></font>

**24/10/2023**

### **1. Project Description**
Database design and implementation for a zoo in MySQL. This project is based on the final project for the **Databases** subject at UNAM (México).

### **2. Requirements**
In a zoo, it is necessary to organize it with respect to the species it has, the employees and the different visiting itineraries it offers. The information available is the following:

**Species**: For the species we know the common name, the scientific name and a general description. It must be taken into account that a species can live in different natural habitats and that a habitat can be occupied by different species. The species are found in different areas of the park so that each species is in an area and in one area there are several species. Each species is located in a cage within an area, of which we know its cage number and number of occupants, these are repeated in each area.

**Habitats**: For the different natural habitats we have the name, the climate and the type of predominant vegetation, as well as the continent or continents on which they are found, for these we have a code and name.
Zones: the areas of the park in which the different species are found are defined by the name and the area they occupy.

**Itineraries**: The itineraries are carried out through different areas of the park, these include the itinerary code, the duration of the route, start time and end time, the length of the itinerary, the maximum number of authorized visitors and the number of different species you visit. It must be taken into account that an itinerary covers different areas of the park and that an area can be covered by different itineraries. To carry out the itineraries, a charge per visitor of $20 is made; a record must be kept of the number of visitors per day within each itinerary.

**Employees**: Each employee have a employee code, full name, address, telephone number and date of hiring at the zoo, all employees are in charge of a person in charge who is also an employee, among the employees we have guides and caretakers. It is important to know which guides carry which itineraries, taking into account that a guide can carry several itineraries and that an itinerary can be assigned to different guides at different times, these being an interesting fact; of the caregivers, it must be taken into account that they may be in charge of several species and that a species may be cared for by several caregivers, with the date on which a caregiver takes charge of a species being of interest.

Another requirements are:
* Admission to the zoo is $5 per person.
* Each itinerary can last from 1 to 1:30 hours, between each itinerary there is a minimum period of 30 minutes, the tour times are at 10:00, 12:00, 14:00 and 16:00 hrs.
* The zoo's hours are from 10:00 a.m. to 5:00 p.m., weekends only (Friday, Saturday and Sunday).
* There cannot be more than 10 visitors on each itinerary.
* Each employee receives a basic monthly salary of $4000.
* Each responsible employee receives an extra $1000.
* Each caretaker receives an additional 20% of the proceeds from each itinerary that includes the area where the species in their care are found.
* Each guide receives an additional 10% for each itinerary made.

It is also required to know:
* How many species are there in the zoo per area?
* Number of visitors per specified date, per itinerary and the total amount obtained for each itinerary
* Salary paid to each guide, showing the date, amount obtained per tour.
* Salary paid to each caregiver, showing the date, amount obtained per trip that corresponds to their area
* Average salary paid to employees according to their position
* Aguinaldo (Bonus) that must be paid for the current year to each employee, considering 5 days at the beginning and 2 days for each year worked.
* Visits made to each area per day (specific date)
* Information on each species also showing the name of the keeper in charge, the list of cages and number of occupants, and the areas where they are located.
* Information from each of the guides corresponding to the areas visited in each itinerary, how many people attended and on what date.

### **3. ER Diagram**

<p align="center">
	<img src="ER_Diagram.png?raw=true" width=80% height=80%>
</p>

### **4. Relational Model**

<p align="center">
	<img src="Schema.png?raw=true" width=80% height=80%>
</p>

### **5. Database Implementation**

All the SQL code to implement the database can be seen <a href="https://raw.githubusercontent.com/DanielEduardoLopez/ZooDB/main/DB_Implementation.sql">here</a>.

### **6. Description of files in repository**
File | Description 
--- | --- 
DB_Data.sql | SQL script to add data to the zoo DB
DB_Implementation.sql | SQL script to impletment the DB
DB_Questions.sql | SQL answer queries to the requirements
ER_Diagram.dia | ER diagram for the DB in the Chen notation created with DIA Diagram Editor
ER_Diagram.png | ER diagram for the DB in the Chen notation
Schema.mwb | Relational Diagram for the DB created with MySQL Workbench
Schema.png | Relational Diagram for the DB
Specifications.pdf | Document (in Spanish) with the requirements

