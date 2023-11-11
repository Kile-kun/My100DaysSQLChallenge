DROP DATABASE IF EXISTS clique_bait;

CREATE DATABASE clique_bait;

USE clique_bait;

-- event identifier table
CREATE TABLE event_identifier (
	event_type INTEGER,
	event_name VARCHAR(13)
);

-- Load data into table
SET
	GLOBAL LOCAL_INFILE = true;

LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Day67-69 (SQL Case Study6)- event_identifier.csv' INTO TABLE event_identifier FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- campaign identifier table
CREATE TABLE campaign_identifier (
	campaign_id INTEGER,
	products VARCHAR(3),
	campaign_name VARCHAR(33),
	start_date TIMESTAMP,
	end_date TIMESTAMP
);

-- Load data into table
SET
	GLOBAL LOCAL_INFILE = true;

LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Day67-69 (SQL Case Study6)- campaign_identifier.csv' INTO TABLE campaign_identifier FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- page hierarchy table
CREATE TABLE page_hierarchy (
	page_id INTEGER,
	page_name VARCHAR(14),
	product_category VARCHAR(9),
	product_id INTEGER
);

-- Load data into table
SET
	GLOBAL LOCAL_INFILE = true;

LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Day67-69 (SQL Case Study6)- page_hierarchy.csv' INTO TABLE page_hierarchy FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- users table
CREATE TABLE users (
	user_id INTEGER,
	cookie_id VARCHAR(6),
	start_date TIMESTAMP
);

-- Load data into table
SET
	GLOBAL LOCAL_INFILE = true;

LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Day67-69 (SQL Case Study6)- users.csv' INTO TABLE users FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- events table
CREATE TABLE events (
	visit_id VARCHAR(6),
	cookie_id VARCHAR(6),
	page_id INTEGER,
	event_type INTEGER,
	sequence_number INTEGER,
	event_time TIMESTAMP
);

-- Load data into table
SET
	GLOBAL LOCAL_INFILE = true;

LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Day67-69 (SQL Case Study6)- events.csv' INTO TABLE events FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- Digital Analysis
-- Using the available datasets - answer the following questions using a single query for each one:
-- 1a. How many users are there?
SELECT
	COUNT(DISTINCT user_id) AS num_of_users
FROM
	users;

-- 1b. How many cookies does each user have on average?
SELECT
	ROUND(AVG(num_of_cookies), 2) AS avg_cookies_count
FROM
	(
		SELECT
			u.user_id,
			COUNT(DISTINCT e.cookie_id) AS num_of_cookies
		FROM
			users u
			JOIN events e ON u.cookie_id = e.cookie_id
		GROUP BY
			u.user_id
		ORDER BY
			u.user_id
	) AS cookies_count;

-- 1c. What is the unique number of visits by all users per month?
SELECT
	MONTH(event_time) AS visit_month,
	MONTHNAME(event_time) AS month,
	COUNT(*) AS num_of_visits
FROM
	events
GROUP BY
	MONTH(event_time),
	MONTHNAME(event_time)
ORDER BY
	visit_month;

-- 1d. What is the number of events for each event type?
SELECT
	ei.event_name,
	COUNT(*) AS num_of_events
FROM
	event_identifier ei
	JOIN events ev ON ei.event_type = ev.event_type
GROUP BY
	ei.event_name;

-- 1e. What is the percentage of visits which have a purchase event?
SELECT
	(
		ROUND(
			100.00 * (
				SUM(
					CASE
						WHEN ei.event_name = "Purchase" THEN 1
						ELSE 0
					END
				) /(
					SELECT
						COUNT(*)
					FROM
						events
				)
			),
			2
		)
	) AS perc_purchase_event
FROM
	event_identifier ei
	JOIN events ev ON ei.event_type = ev.event_type;

-- 1f. What is the percentage of visits which view the checkout page but do not have a purchase event?
WITH visit_checkout_cte AS (
	SELECT
		*
	FROM
		(
			SELECT
				visit_id,
				page_id,
				event_time,
				LEAD(page_id) OVER(
					PARTITION BY visit_id
					ORDER BY
						visit_id,
						event_time
				) AS next_pagevisit
			FROM
				events
		) AS page_hierachy
	WHERE
		page_id = 12
		AND next_pagevisit = 13
)
SELECT
	COUNT(visit_id) AS converted_visit,
	(
		SELECT
			COUNT(DISTINCT visit_id)
		FROM
			events
	) AS overall_total_visit,
	ROUND(
		100.00 * (
			COUNT(visit_id) /(
				SELECT
					COUNT(DISTINCT visit_id)
				FROM
					events
			)
		),
		2
	) AS perc_conversion,
	ROUND(
		100.00 * (
			1 - (
				COUNT(visit_id) /(
					SELECT
						COUNT(DISTINCT visit_id)
					FROM
						events
				)
			)
		),
		2
	) AS perc_abandonment
FROM
	visit_checkout_cte;

-- 1g. What are the top 3 pages by number of views?
SELECT
	ph.page_name,
	COUNT(*) AS view_count
FROM
	page_hierarchy ph
	JOIN events ev ON ph.page_id = ev.page_id
	JOIN event_identifier ei ON ev.event_type = ei.event_type
GROUP BY
	ph.page_name
ORDER BY
	view_count DESC;

-- 1h. What is the number of views and cart adds for each product category?
SELECT
	ph.product_category,
	COUNT(
		CASE
			WHEN ei.event_name = 'Page View' THEN ev.visit_id
		END
	) AS view_counts,
	COUNT(
		CASE
			WHEN ei.event_name = 'Add to Cart' THEN ev.visit_id
		END
	) AS cart_counts
FROM
	page_hierarchy ph
	JOIN events ev ON ph.page_id = ev.page_id
	JOIN event_identifier ei ON ev.event_type = ei.event_type
WHERE
	ph.product_category IS NOT NULL
GROUP BY
	ph.product_category
ORDER BY
	ph.product_category;

-- 1i. What are the top 3 products by purchases?
WITH purchase_cte AS (
	SELECT
		DISTINCT visit_id
	FROM
		events
	WHERE
		event_type = 3
),
prod_cte AS (
	SELECT
		ph.page_name,
		ph.page_id,
		e.visit_id
	FROM
		events e
		LEFT JOIN page_hierarchy ph ON e.page_id = ph.page_id
	WHERE
		event_type = 2
	ORDER BY
		e.visit_id
)
SELECT
	page_name AS product,
	COUNT(*) AS total_purchase
FROM
	purchase_cte pu
	LEFT JOIN prod_cte pr ON pu.visit_id = pr.visit_id
GROUP BY
	page_name
ORDER BY
	total_purchase DESC
LIMIT
	3;

-- 2. Product Funnel Analysis
-- 2a. Using a single SQL query - create a new output table which has the following details:
-- 2ai. How many times was each product viewed?
DROP TABLE IF EXISTS product_output;

CREATE TABLE product_output AS WITH cte AS (
	SELECT
		e.visit_id,
		e.cookie_id,
		e.event_type,
		ph.page_id,
		ph.page_name,
		ph.product_category,
		ph.product_id
	FROM
		events e
		JOIN page_hierarchy ph ON ph.page_id = e.page_id
),
cte2 AS (
	SELECT
		page_name,
		CASE
			WHEN event_type = 1 THEN visit_id
		END AS viewed
	FROM
		cte
	WHERE
		product_id IS NOT NULL
)
SELECT
	page_name,
	COUNT(viewed) AS view_count
FROM
	cte2
GROUP BY
	page_name
ORDER BY
	page_name;

SELECT
	*
FROM
	product_output;

-- 2aii. How many times was each product added to cart?
DROP TABLE IF EXISTS product_output;

CREATE TABLE product_output AS WITH cte AS (
	SELECT
		e.visit_id,
		e.cookie_id,
		e.event_type,
		ph.page_id,
		ph.page_name,
		ph.product_category,
		ph.product_id
	FROM
		events e
		JOIN page_hierarchy ph ON ph.page_id = e.page_id
),
cte2 AS (
	SELECT
		page_name,
		CASE
			WHEN event_type = 2 THEN visit_id
		END AS cart_id,
		CASE
			WHEN event_type = 1 THEN visit_id
		END AS viewed
	FROM
		cte
	WHERE
		product_id IS NOT NULL
)
SELECT
	page_name,
	COUNT(viewed) AS view_count,
	COUNT(cart_id) AS cart_count
FROM
	cte2
GROUP BY
	page_name
ORDER BY
	page_name;

SELECT
	*
FROM
	product_output;

-- 2aiii. How many times was each product purchased?
DROP TABLE IF EXISTS product_output;

CREATE TABLE product_output AS WITH cte AS (
	SELECT
		e.visit_id,
		e.cookie_id,
		e.event_type,
		ph.page_id,
		ph.page_name,
		ph.product_category,
		ph.product_id
	FROM
		events e
		JOIN page_hierarchy ph ON ph.page_id = e.page_id
),
cte2 AS (
	SELECT
		page_name,
		CASE
			WHEN event_type = 2 THEN visit_id
		END AS cart_id,
		CASE
			WHEN event_type = 1 THEN visit_id
		END AS viewed
	FROM
		cte
	WHERE
		product_id IS NOT NULL
),
cte3 AS (
	SELECT
		visit_id AS purchase_id
	FROM
		events
	WHERE
		event_type = 3
)
SELECT
	page_name,
	COUNT(viewed) AS view_count,
	COUNT(cart_id) AS cart_count,
	COUNT(purchase_id) AS purchase_count
FROM
	cte2
	LEFT JOIN cte3 ON purchase_id = cart_id
GROUP BY
	page_name
ORDER BY
	COUNT(purchase_id) DESC;

SELECT
	*
FROM
	product_output;

-- 2aiv. How many times was each product added to a cart but not purchased (abandoned)?
DROP TABLE IF EXISTS product_output;

CREATE TABLE product_output AS WITH cte AS (
	SELECT
		e.visit_id,
		e.cookie_id,
		e.event_type,
		ph.page_id,
		ph.page_name,
		ph.product_category,
		ph.product_id
	FROM
		events e
		JOIN page_hierarchy ph ON ph.page_id = e.page_id
),
cte2 AS (
	SELECT
		page_name AS product,
		CASE
			WHEN event_type = 2 THEN visit_id
		END AS cart_id,
		CASE
			WHEN event_type = 1 THEN visit_id
		END AS viewed
	FROM
		cte
	WHERE
		product_id IS NOT NULL
),
cte3 AS (
	SELECT
		visit_id AS purchase_id
	FROM
		events
	WHERE
		event_type = 3
)
SELECT
	product,
	COUNT(viewed) AS view_count,
	COUNT(cart_id) AS cart_count,
	COUNT(purchase_id) AS purchase_count,
	COUNT(cart_id) - COUNT(purchase_id) AS abandon_count
FROM
	cte2
	LEFT JOIN cte3 ON purchase_id = cart_id
GROUP BY
	product
ORDER BY
	COUNT(purchase_id) DESC;

SELECT
	*
FROM
	product_output;

-- 2b Additionally, create another table which further aggregates the data for the above points but this time for each product category instead of individual products.
DROP TABLE IF EXISTS productcategory_output;

CREATE TABLE productcategory_output AS WITH cte AS (
	SELECT
		e.visit_id,
		e.cookie_id,
		e.event_type,
		ph.page_id,
		ph.page_name,
		ph.product_category,
		ph.product_id
	FROM
		events e
		JOIN page_hierarchy ph ON ph.page_id = e.page_id
),
cte2 AS (
	SELECT
		product_category,
		CASE
			WHEN event_type = 2 THEN visit_id
		END AS cart_id,
		CASE
			WHEN event_type = 1 THEN visit_id
		END AS viewed
	FROM
		cte
	WHERE
		product_category IS NOT NULL
),
cte3 AS (
	SELECT
		visit_id AS purchase_id
	FROM
		events
	WHERE
		event_type = 3
)
SELECT
	product_category,
	COUNT(viewed) AS view_count,
	COUNT(cart_id) AS cart_count,
	COUNT(purchase_id) AS purchase_count,
	COUNT(cart_id) - COUNT(purchase_id) AS abandon_count
FROM
	cte2
	LEFT JOIN cte3 ON purchase_id = cart_id
GROUP BY
	product_category
ORDER BY
	product_category DESC;

SELECT
	*
FROM
	productcategory_output;

-- 2c. Use your 2 new output tables - answer the following questions:
-- 2ci. Which product had the most views, cart adds and purchases?
WITH top_product_cte AS (
	SELECT
		"Top_Product_Viewed",
		product,
		view_count
	FROM
		product_output
	WHERE
		view_count = (
			SELECT
				MAX(view_count)
			FROM
				product_output
		)
	UNION
	SELECT
		"Top Product Carted",
		product,
		cart_count
	FROM
		product_output
	WHERE
		cart_count = (
			SELECT
				MAX(cart_count)
			FROM
				product_output
		)
	UNION
	SELECT
		"Top Product Purchased",
		product,
		purchase_count
	FROM
		product_output
	WHERE
		purchase_count = (
			SELECT
				MAX(purchase_count)
			FROM
				product_output
		)
)
SELECT
	Top_Product_Viewed AS top,
	product,
	view_count AS value
FROM
	top_product_cte;

-- 2cii. Which product was most likely to be abandoned?
SELECT
	product,
	abandon_count
FROM
	product_output
WHERE
	abandon_count = (
		SELECT
			MAX(abandon_count)
		FROM
			product_output
	);

-- 2ciii. Which product had the highest view to purchase percentage?
SELECT
	product,
	ROUND(100.00 *(purchase_count / view_count), 2) AS view_to_purchase_percent
FROM
	product_output
ORDER BY
	view_to_purchase_percent DESC
LIMIT
	1;

-- 2civ. What is the average conversion rate from view to cart add?
SELECT
	ROUND(100.00 * (SUM(cart_count) / SUM(view_count)), 2) AS average_conversion
FROM
	product_output;

-- 2cv. What is the average conversion rate from cart add to purchase?
SELECT
	ROUND(100.00 * (SUM(purchase_count) / SUM(cart_count)), 2) AS average_prod_purchase_conversion
FROM
	product_output;

/*Generate a table that has 1 single row for every unique visit_id record and has the following columns:
 -- user_id
 -- visit_id
 -- visit_start_time: the earliest event_time for each visit
 -- page_views: count of page views for each visit
 -- cart_adds: count of product cart add events for each visit
 -- purchase: 1/0 flag if a purchase event exists for each visit
 -- campaign_name: map the visit to a campaign if the visit_start_time falls between the start_date and end_date
 -- impression: count of ad impressions for each visit
 -- click: count of ad clicks for each visit
 -- (Optional column) cart_products: a comma separated text value with products added to the cart sorted by the order
 they were added to the cart (hint: use the sequence_number)*/
USE clique_bait;

DROP TABLE IF EXISTS campaign_performance;

CREATE TABLE campaign_performance AS (
	SELECT
		u.user_id,
		e.visit_id,
		MIN(e.event_time) AS visit_start_time,
		COUNT(
			CASE
				WHEN e.event_type = 1 THEN e.visit_id
			END
		) AS page_view_no,
		COUNT(
			CASE
				WHEN e.event_type = 2 THEN e.visit_id
			END
		) AS cart_add_no,
		(
			CASE
				WHEN e.event_type = 3 THEN 1
				ELSE 0
			END
		) AS purchase_option,
		(
			CASE
				WHEN e.event_time BETWEEN c.start_date
				AND c.end_date THEN c.campaign_name
			END
		) AS campaign_name,
		COUNT(
			CASE
				WHEN e.event_type = 4 THEN e.visit_id
			END
		) AS ad_impression_no,
		COUNT(
			CASE
				WHEN e.event_type = 5 THEN e.visit_id
			END
		) AS ad_clicks_no,
		GROUP_CONCAT(
			CASE
				WHEN event_type = 2
				AND ph.product_id IS NOT NULL THEN page_name
				ELSE NULL
			END,
			''
			ORDER BY
				e.sequence_number
		) AS product_carted
	FROM
		users u
		JOIN events e ON u.cookie_id = e.cookie_id
		JOIN campaign_identifier c ON e.event_time BETWEEN c.start_date
		AND c.end_date
		JOIN page_hierarchy ph ON e.page_id = ph.page_id
	GROUP BY
		u.user_id,
		e.visit_id,
		(
			CASE
				WHEN e.event_type = 3 THEN 1
				ELSE 0
			END
		),
		(
			CASE
				WHEN e.event_time BETWEEN c.start_date
				AND c.end_date THEN c.campaign_name
			END
		)
	ORDER BY
		e.visit_id
);

SELECT
	*
FROM
	campaign_performance;