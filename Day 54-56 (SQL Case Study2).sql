-- DAY 54-56 (SQL Case Study2) Database Setup
-- Create Database
DROP DATABASE IF EXISTS pizza_runner;
CREATE DATABASE  pizza_runner;
USE pizza_runner;

-- Create Table For the database
-- Runners Table
CREATE TABLE runners (
					runner_id INTEGER,
					registration_date DATE
);
-- Customer Order Table
CREATE TABLE customer_orders (
					order_id INTEGER,
					customer_id INTEGER,
					pizza_id INTEGER,
					exclusions VARCHAR(4),
					extras VARCHAR(4),
					order_time TIMESTAMP
);
-- Runner Order Table
CREATE TABLE runner_orders (
					order_id INTEGER,
					runner_id INTEGER,
					pickup_time VARCHAR(19),
					distance VARCHAR(7),
					duration VARCHAR(10),
					cancellation VARCHAR(23)
);
-- Pizza Names Table;
CREATE TABLE pizza_names (
					pizza_id INTEGER,
					pizza_name TEXT
);
-- Pizza Recipes Table
CREATE TABLE pizza_recipes (
					pizza_id INTEGER,
					toppings TEXT
);
-- Pizza Toppings Table;
CREATE TABLE pizza_toppings (
					topping_id INTEGER,
					topping_name TEXT
);

-- Insert Datas into the created table
-- Runner Table
INSERT INTO runners
VALUES
					(1, '2021-01-01'),
					(2, '2021-01-03'),
					(3, '2021-01-08'),
					(4, '2021-01-15');
-- Customer Orders Table;
INSERT INTO customer_orders
VALUES
					('1', '101', '1', '', '', '2020-01-01 18:05:02'),
					('2', '101', '1', '', '', '2020-01-01 19:00:52'),
					('3', '102', '1', '', '', '2020-01-02 23:51:23'),
					('3', '102', '2', '', NULL, '2020-01-02 23:51:23'),
					('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
					('4', '103', '1', '4', '', '2020-01-04 13:23:46'),
					('4', '103', '2', '4', '', '2020-01-04 13:23:46'),
					('5', '104', '1', 'null', '1', '2020-01-08 21:00:29'),
					('6', '101', '2', 'null', 'null', '2020-01-08 21:03:13'),
					('7', '105', '2', 'null', '1', '2020-01-08 21:20:29'),
					('8', '102', '1', 'null', 'null', '2020-01-09 23:54:33'),
					('9', '103', '1', '4', '1, 5', '2020-01-10 11:22:59'),
					('10', '104', '1', 'null', 'null', '2020-01-11 18:34:49'),
					('10', '104', '1', '2, 6', '1, 4', '2020-01-11 18:34:49');
-- Runner Orders Table
INSERT INTO runner_orders
VALUES
					('1', '1', '2020-01-01 18:15:34', '20km', '32 minutes', ''),
					('2', '1', '2020-01-01 19:10:54', '20km', '27 minutes', ''),
					('3', '1', '2020-01-03 00:12:37', '13.4km', '20 mins', NULL),
					('4', '2', '2020-01-04 13:53:03', '23.4', '40', NULL),
					('5', '3', '2020-01-08 21:10:57', '10', '15', NULL),
					('6', '3', 'null', 'null', 'null', 'Restaurant Cancellation'),
					('7', '2', '2020-01-08 21:30:45', '25km', '25mins', 'null'),
					('8', '2', '2020-01-10 00:15:02', '23.4 km', '15 minute', 'null'),
					('9', '2', 'null', 'null', 'null', 'Customer Cancellation'),
					('10', '1', '2020-01-11 18:50:20', '10km', '10minutes', 'null');
-- Pizza Names Table
INSERT INTO pizza_names
VALUES
					(1, 'Meatlovers'),
					(2, 'Vegetarian');
-- Pizza Recipes Table
INSERT INTO pizza_recipes
VALUES
					(1, '1, 2, 3, 4, 5, 6, 8, 10'),
					(2, '4, 6, 7, 9, 11, 12');
-- Pizza Toppings Table
INSERT INTO pizza_toppings
VALUES
					(1, 'Bacon'),
					(2, 'BBQ Sauce'),
					(3, 'Beef'),
					(4, 'Cheese'),
					(5, 'Chicken'),
					(6, 'Mushrooms'),
					(7, 'Onions'),
					(8, 'Pepperoni'),
					(9, 'Peppers'),
					(10, 'Salami'),
					(11, 'Tomatoes'),
					(12, 'Tomato Sauce');

-- INSIGHTS
-- 1. How many pizzas were ORdered?
SELECT pn.pizza_name, COUNT(co.ORder_id) AS no_of_orders
FROM pizza_names pn
JOIN customer_orders co
ON pn.pizza_id = co.pizza_id
GROUP BY pn.pizza_name;

-- 2. How many unique customer orders were made?
SELECT COUNT(DISTINCT ORder_id) AS unique_orders
FROM customer_orders;

-- 3. How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(ORder_id) AS succ_del_count
FROM runner_orders
WHERE cancellation NOT LIKE "%Cancellation&"
GROUP BY runner_id
ORDER BY runner_id;

-- 4. How many of each type of pizza was delivered?
SELECT pn.pizza_name, COUNT(ro.ORder_id) AS total_delivered
FROM pizza_names pn
JOIN customer_orders co
ON pn.pizza_id = co.pizza_id
JOIN runner_orders ro
ON co.ORder_id = ro.ORder_id
WHERE ro.cancellation NOT LIKE "%Cancellation&"
GROUP BY pn.pizza_name;

-- 5. How many Vegetarian AND Meatlovers were ORdered by each customer?
SELECT co.customer_id, 
		SUM(CASE WHEN pn.pizza_name = 'Meatlovers' THEN 1 ELSE 0 END) AS meat_lovers,
		SUM(CASE WHEN pn.pizza_name = 'Vegetarian' THEN 1 ELSE 0 END) AS vegetarian
FROM customer_orders co
JOIN pizza_names pn
ON co.pizza_id = pn.pizza_id
GROUP BY co.customer_id;

-- 6. What was the maximum number of pizzas delivered in a single ORder?
WITH top_ORder_cte AS 
					(SELECT ORder_id, COUNT(ORder_id) AS no_of_pizzas
					FROM customer_orders
					GROUP BY ORder_id)
SELECT MAX(no_of_pizzas) AS highest_single_ORder
FROM top_ORder_cte;

-- 7. How many pizzas were delivered that had both exclusions AND extras?
SELECT COUNT(ro.ORder_id) AS tot_del_with_extra
FROM customer_orders co
RIGHT JOIN runner_orders ro
ON co.ORder_id = ro.ORder_id
WHERE co.exclusions NOT IN ('null', '') AND 
		co.extras NOT IN ('null', '') AND 
        ro.cancellation NOT LIKE "%Cancellation";

-- 8. What was the total volume of pizzas ORdered fOR each hour of the day?
SELECT HOUR(ORder_time) AS ORder_hour, COUNT(*) AS hourly_orders
FROM customer_orders
GROUP BY HOUR(ORder_time)
ORDER BY ORder_hour ASC;

-- 9. What was the volume of orders fOR each day of the week?
SELECT DAY(ORder_time) AS ORder_day, COUNT(*) AS daily_orders
FROM customer_orders
GROUP BY DAY(ORder_time)
ORDER BY ORder_day ASC;

-- 10. How many runners signed up fOR each 1 week period? (i.e. week starts 2021-01-01)
SELECT WEEK(registration_date) AS reg_week, COUNT(runner_id) AS tot_reg
FROM runners
GROUP BY WEEK(registration_date)
ORDER BY reg_week;

-- 11. What was the average time in minutes it took fOR each runner to arrive at the Pizza Runner HQ to pickup the ORder?
SELECT ro.runner_id, ABS(ROUND(AVG(MINUTE(co.ORder_time) - MINUTE(ro.pickup_time)),2)) AS average_pickup_time
FROM runner_orders ro
JOIN customer_orders co
ON ro.ORder_id = co.ORder_id
GROUP BY ro.runner_id
ORDER BY ro.runner_id;

-- 12. Is there any relationship between the number of pizzas AND how long the ORder takes to prepare?
WITH ORder_per_time_cte AS (SELECT co.ORder_time, 
									COUNT(co.ORder_time) AS num_of_orders, 
									ABS(ROUND(AVG(MINUTE(co.ORder_time) - MINUTE(ro.pickup_time)),2)) AS average_prep_time
							FROM customer_orders co
							RIGHT JOIN runner_orders ro
							ON co.ORder_id = ro.ORder_id
							GROUP BY co.ORder_time)
SELECT num_of_orders, ROUND(AVG(average_prep_time),2) AS avg_prep_time
FROM ORder_per_time_cte
GROUP BY num_of_orders
HAVING AVG(average_prep_time) IS NOT NULL;

-- 13. What was the average distance travelled fOR each customer?
SELECT co.customer_id, ROUND(AVG(ro.distance),2) AS avg_distance
FROM customer_orders co
RIGHT JOIN runner_orders ro
ON co.ORder_id = ro.ORder_id
GROUP BY co.customer_id;

-- 14. What was the difference between the longest AND shORtest delivery times fOR all orders?
SELECT MAX(duration), MIN(duration), (MAX(duration)-MIN(duration)) AS distance_range
FROM runner_orders
WHERE distance != 'null';

-- 15. What was the average speed fOR each runner fOR each delivery AND do you notice any trend fOR these values?
SELECT runner_id, ORder_id, distance, duration, ROUND((distance/(duration/60)),2) AS speed_in_kph
FROM runner_orders
WHERE distance != 'null' AND distance != 'null'
ORDER BY runner_id, ORder_id;

-- 16. What is the successful delivery percentage fOR each runner?
SELECT runner_id, ROUND(100.00 * ((SUM(CASE WHEN pickup_time != 'null' THEN 1 ELSE 0 END))/COUNT(*)),2) perc_del_success
FROM runner_orders
GROUP BY runner_id;

-- 17. What are the stANDard ingredients fOR each pizza?
DROP TABLE IF EXISTS pizza_recipes;
CREATE TABLE pizza_recipes (pizza_id INT, toppings INT);
INSERT INTO pizza_recipes VALUES (1,1),(1,2),(1,3),(1,4),(1,5),(1,6),(1,8),(1,10),(2,4),(2,6),(2,7),(2,9),(2,11),(2,12);
SELECT pizza_name, GROUP_CONCAT(topping_name) AS ingredients 
FROM pizza_names pn
JOIN pizza_recipes pr
ON pn.pizza_id = pr.pizza_id
JOIN pizza_toppings pt
ON pr.toppings = pt.topping_id
GROUP BY pizza_name;

-- 18. What was the most commonly added extra?
DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers (
  num INT PRIMARY KEY
);
INSERT INTO numbers VALUES
( 1 ), ( 2 ), ( 3 ), ( 4 ), ( 5 ), ( 6 ), ( 7 ), ( 8 ), ( 9 ), ( 10 ),( 11 ), ( 12 ), ( 13 ), ( 14 );
WITH cte AS (SELECT n.num, SUBSTRING_INDEX(SUBSTRING_INDEX(all_tags, ',', num), ',', -1) AS one_tag
			FROM (
					SELECT GROUP_CONCAT(extras SEPARATOR ',') AS all_tags,
							LENGTH(GROUP_CONCAT(extras SEPARATOR ',')) - LENGTH(REPLACE(GROUP_CONCAT(extras SEPARATOR ','), ',', '')) + 1 AS count_tags
					FROM customer_orders
					) t
			JOIN numbers n
			ON n.num <= t.count_tags)
SELECT one_tag AS Extras,
		pz.topping_name AS ExtraTopping, 
        count(one_tag) AS Occurrencecount
FROM cte
INNER JOIN pizza_toppings pz
ON pz.topping_id = cte.one_tag
WHERE one_tag != 0
GROUP BY one_tag, pz.topping_name;

-- 19. What was the most common exclusion?
DROP TABLE IF EXISTS numbers;
CREATE TABLE numbers (
  num INT PRIMARY KEY
);
INSERT INTO numbers VALUES
    ( 1 ), ( 2 ), ( 3 ), ( 4 ), ( 5 ), ( 6 ), ( 7 ), ( 8 ), ( 9 ), ( 10 ),( 11 ), ( 12 ), ( 13 ), ( 14 );
WITH cte AS (SELECT n.num, SUBSTRING_INDEX(SUBSTRING_INDEX(all_tags, ',', num), ',', -1) as one_tag
			FROM (
					SELECT
							GROUP_CONCAT(exclusions SEPARATOR ',') AS all_tags,
							LENGTH(GROUP_CONCAT(exclusions SEPARATOR ',')) - 
                            LENGTH(REPLACE(GROUP_CONCAT(exclusions SEPARATOR ','), ',', '')) + 1 AS count_tags
					FROM customer_orders
					) t
			JOIN numbers n
			ON n.num <= t.count_tags)
SELECT one_tag as Exclusions,
		pz.topping_name as ExclusionTopping, 
        COUNT(one_tag) as Occurrencecount
FROM cte
INNER JOIN pizza_toppings pz
ON pz.topping_id = cte.one_tag
WHERE one_tag != 0
GROUP BY one_tag, pz.topping_name
ORDER BY Occurrencecount ASC;

-- 20. If a Meat Lovers pizza costs $12 AND Vegetarian costs $10 AND there were no charges fOR changes - 
	-- how much money has Pizza Runner made so far if there are no delivery fees?
WITH order_count_cte AS (SELECT pn.pizza_name, COUNT(*) AS tot_orders
						FROM pizza_names pn
						JOIN customer_orders co
						ON pn.pizza_id = co.pizza_id
						JOIN runner_orders ro
						ON co.order_id = ro.order_id
						WHERE ro.pickup_time != 'null'
						GROUP BY pn.pizza_name)
SELECT SUM(CASE WHEN pizza_name = 'Meatlovers' THEN tot_orders * 12 ELSE tot_orders * 10 END) AS revenue
FROM  order_count_cte;