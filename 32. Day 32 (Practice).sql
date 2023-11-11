
-- DAY 32 (Practice)

/*Compare each employee's salary with the average salary of the corresponding department. Output the 
department, first name, and salary of employees along with the average salary of that department.*/
SELECT department, first_name, salary,
        (SELECT AVG(salary)
        FROM employee empl GROUP BY department
        HAVING emp1.department = emp2.department) AS dept_avg
FROM employee emp2;

/*Find the details of each customer regardless of whether the customer made an order. Output the customer's 
first name, last name, and the city along with the order details. You may have duplicate rows in your 
results due to a customer ordering several of the same items. Sort records based on the customer's 
first name and the order details in ascending order.*/
SELECT c.first_name, c.last_name, c.city, o.order_details
FROM customers c
LEFT JOIN orders o
ON c.id = o.cust_id
ORDER BY c.first_name ASC, o.order_details ASC;