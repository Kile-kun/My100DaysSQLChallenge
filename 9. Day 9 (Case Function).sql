
-- DAY 9 CASE FUNCTION
-- Get total sales and revenue recorded for bulk purchases(above 5 items) and retail purchases (below 5 items)
SELECT CASE
WHEN order_quantity >= 5 THEN "Bulk Order" ELSE "Retail Order" END AS order_type, SUM(order_quantity) AS total_quant_order, SUM(revenue) AS revenue_generated
FROM sales
GROUP BY order_type;

-- Compare weekday and weekend bulk sales
SELECT CASE
WHEN DAY(order_date) <= 5 THEN "Weekday" ELSE "Weekend" END_day_type, AVG(order_quantity) AS avg_quant_order,
AVG(revenue) AS avg_revenue
FROM sales
WHERE order_quantity > 5
GROUP BY day_type;

-- Find the adverts performances within the periods of the day SELECT CASE
WHEN HOUR(hour_of_day) BETWEEN 6 AND 11 THEN "Morning" WHEN HOUR(hour_of_day) BETWEEN 12 AND 16 THEN "Afternoon" WHEN HOUR(hour_of_day) BETWEEN 17 AND 23 THEN "Evening" ELSE "Night" END AS period_of_day,
SUM(impressions) AS total_reach,
SUM(clicks) AS total_engagements,
SUM(spend) AS total_budgets,
SUM(spend)/SUM(clicks) AS budget_per_engagements
FROM adverts
GROUP BY period_of_day;

-- Find the Distribution of Customers According to their Age group USE dm_db; -- since it is a new database
SELECT
CASE
WHEN Age BETWEEN 10 AND 19 THEN 'Teenages'
WHEN Age BETWEEN 20 AND 29 THEN '20s'
WHEN Age BETWEEN 30 AND 39 THEN '30s' WHEN Age BETWEEN 40 AND 49 THEN '40s' WHEN Age BETWEEN 50 AND 59 THEN '50s' WHEN Age BETWEEN 60 AND 69 THEN '60s' ELSE '70+'
END AS AgeGrp,
COUNT(*) NoOfCust
FROM customer
GROUP BY AgeGrp
ORDER BY AgeGrp * 1, AgeGrp DESC;