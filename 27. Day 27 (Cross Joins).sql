
-- DAY 27 (CROSS JOIN)

/* The English Premier League in the preparation for 2023/2024 season tasked you as the Junior Data 
Analyst to generate all match fixtures for the season */
USE epl_db;

SELECT CONCAT(h.team_name, ' VS ', a.team_name) AS fixtures
FROM home_team h
CROSS JOIN away_team a
WHERE h.team_name != a.team_name;

/* A company looking to post different employees to head different department in turns, 
write a query that return different combination of employees and department they are to manage*/
SELECT CONCAT(e.first_name, ' ', e.last_name) AS manager_name, d.dept_name
FROM employees e
INNER JOIN dept_manager dm
ON e.emp_no = dm.emp_no
CROSS JOIN departments d
ORDER BY manager_name;
