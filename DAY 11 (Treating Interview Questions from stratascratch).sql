
--DAY 11 (Treating Interview Questions from stratascratch)

/* 1. We have a table with employees and their salaries, however, some of the records are old and 
contain outdated salary information. Find the current salary of each employee assuming that salaries 
increase each year. Output their id, first name, last name, department ID, and current salary. 
Order your list by employee ID in ascending order.*/
SELECT id, first_name, last_name, MAX(salary) AS current_salary, department_id
FROM ms_employee_salary
GROUP BY first_name
ORDER BY id;

/*2. Order all countries by the year they first participated in the Olympics.Output the National Olympics 
Committee (NOC) name along with the desired year.Sort records by the year and the NOC in ascending order.*/
SELECT noc, MIN(year) AS year_first_participated
FROM olympics_athletes_events
GROUP BY noc
ORDER BY year, noc;

/*3. Find the total number of housing units completed for each year. Output the year along with the total 
number of housings. Order the result by year in ascending order.
- Note: Number of housing units in thousands.*/
SELECT year, SUM(south+west+midwest-northeast) AS total_housing
FROM housing_units_completed_us
GROUP BY year
ORDER BY year;