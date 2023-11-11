-- DAY 3 (WHERE CLAUSE (With Basic Operators))

-- Select adverts that has over 10000 impressions
-- Greater Than Operators (>)
SELECT *
FROM adverts
WHERE impressions > 10000;

-- Select Sales that generated loss in revenue
-- Less Than Operator (<)
SELECT *
FROM sales
WHERE revenue < 0;

S-- Select sales with exactly 8 order quantities
-- Equals to Operators (=)
SELECT *
FROM sales
WHERE order_quantity = 8;