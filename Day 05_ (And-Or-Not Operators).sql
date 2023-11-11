-- DAY 5 (AND-OR-NOT Operators)
-- AND Operator
-- Return the Best Performing Adverts (Minimum of $100 ad spend and Minimum of 10000 impressions)
SELECT * 
FROM adverts
WHERE spend<=100 AND impressions >= 10000;

-- OR Operator
-- Return Sales with Critical Order Priority or Lower Order Quantity (Maximum of 2 Items Order)
SELECT *
FROM sales 
WHERE order_priority LIKE '%Critical%' OR order_quantity <= 2;

-- NOT Operator
-- Return Customer Details whose name start with "A" and are from all region BUT Nunavut or West
SELECT *
FROM customers
WHERE customer_name LIKE 'A%' AND region NOT IN ('Nunavut', 'West');