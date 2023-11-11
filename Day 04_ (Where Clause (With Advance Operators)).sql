-- DAY 4: WHERE CLAUSE (With Advance Operators)
USE sales_db;
-- LIKE Operator
-- Select all customers whose names has "a" as their second letter
SELECT * 
FROM customers
WHERE customers_name LIKE '_a%';

-- IN Operator
-- Select all advert handled by Ogly and Zion Agencies
SELECT *
FROM adverts
WHERE agency IN ("Ogly","Zion");

-- BETWEEN Operator
-- Select all sales beteen february and june 2017
SELECT *
FROM sales
WHERE order_date BETWEEN '2017-02-01' AND '2017-06-30';