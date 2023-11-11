
-- DAY 8 ORDER BY AND LIMIT CLAUSE
USE sales_db;

-- Write a query to return all rows from the customers table, sorted by the name column in ascending order.
SELECT *
FROM customers
ORDER BY customer_name ASC;

-- Write a query to return the bottom 5 orders of critical Order Priority in the sales table, sorted by the revenue generated in ascending order. 
SELECT order_id, product_id, order_date, order_priority,
        order_quantity, delivery_date, revenue
FROM sales
WHERE order_priority LIKE '%Critical%'
ORDER BY revenue ASC
LIMIT 5;

-- Write a query to return all rows from the orders table, sorted by the order_date in ascending order, and by the delivery_date in descending order.
SELECT *
FROM sales
ORDER BY order_date ASC, delivery_date DESC;