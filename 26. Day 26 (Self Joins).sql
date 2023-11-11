
-- DAY 26 (SELF JOIN)

/* Given an employee table whose manager_id are extracted from employee_id but in separate columns, 
Write a query to show count of employees under each manager in descending order*/
SELECT m.employee_id,
CONCAT(m.first_name, ' ', m.last_name) AS manager_name,
COUNT(m.employee_id) AS total_employees
FROM employees m
SELF JOIN employees e
ON m.employee_id = e.manager_id
GROUP BY m.employee_id;

/* From the question above, with an extra department table, Display the managers and the reporting
employees who work in different departments*/
SELECT CONCAT(m.first_name,
CONCAT(e.first_name, ' ', m.last_name) AS managers_name,
        e.last_name) AS rep_employees_name,
        d.department_name AS rep_employees_department
FROM employees m
JOIN employees e ON e.manager_id = m.employee_id
JOIN departments d ON e.department_id = d.department_id WHERE m.department_id != e.department_id
ORDER BY managers_name;