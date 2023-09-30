-- DAY 6 (String Operator and Functions)
-- Return all customers whose name start or end with vowels
SELECT *
FROM customers
WHERE LEFT(customer_name,1) IN ("A","E","I","O","U");

-- Create an extra colun which return the initials of each customers
SELECT customer_id,
		customer_name,
        CONCAT(LEFT(customer_name,1), '. ',
				MID(customer_name,
					(POSITION(' ' IN customer_name)), 2))
                    AS initials
FROM customers;