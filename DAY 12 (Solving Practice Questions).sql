
--DAY 12 (Solving Practice Questions)

/*Given a table of candidates and their skills, you're tasked with finding the candidates best suited for
 an open Data Science job. You want to find candidates who are proficient in Python, Tableau, and 
 PostgreSQL. Write a query to list the candidates who possess all of the required skills for the job. Sort the output by candidate ID in ascending order.
--Assumption:There are no duplicates in the candidates table.*/
SELECT candidate_id
FROM candidates
WHERE skill IN ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(candidate_id) >=3
ORDER BY candidate_id;

/*Tesla is investigating production bottlenecks and they need your help to extract the relevant data. 
Write a query that determines which parts with the assembly steps have initiated the assembly process but
 remain unfinished.
Assumptions: parts_assembly table contains all parts currently in production, each at varying stages of 
the assembly process. An unfinished part is one that lacks a finish_date.*/
SELECT part, assembly_step
FROM parts_assembly
WHERE assembly_step > 0
AND finish_date IS NULL;

/*Assume you're given the table on user viewership categorised by device type where the three types are 
laptop, tablet, and phone. Write a query that calculates the total viewership for laptops and mobile 
devices where mobile is defined as the sum of tablet and phone viewership. Output the total viewership 
for laptops as laptop_reviews and the total viewership for mobile devices as mobile_views.*/
SELECT DISTINCT (
SELECT COUNT(*) FROM viewership
WHERE device_type IN ('laptop')) AS laptop_views,
(
SELECT COUNT(*)
FROM viewership
WHERE device_type NOT IN ('laptop')) AS mobile_views
FROM viewership;