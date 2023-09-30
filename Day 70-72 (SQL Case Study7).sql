DROP DATABASE IF EXISTS balanced_tree;
CREATE DATABASE balanced_tree;
USE balanced_tree;

-- product hierarchy table
CREATE TABLE product_hierarchy (
								id INTEGER,
								parent_id INTEGER,
								level_text VARCHAR(19),
								level_name VARCHAR(8)
								);
-- Load data into table
SET GLOBAL LOCAL_INFILE = true;
LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Day70-72 (SQL Case Study7)- product_hierarchy.csv'
INTO TABLE product_hierarchy
FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES
TERMINATED BY '\n'
IGNORE 1 ROWS;

-- product prices table
CREATE TABLE product_prices (
								id INTEGER,
								product_id VARCHAR(6),
								price INTEGER
							);
-- Load data into table
SET GLOBAL LOCAL_INFILE = true;
LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Day70-72 (SQL Case Study7)- product_prices.csv'
INTO TABLE product_prices
FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES
TERMINATED BY '\n'
IGNORE 1 ROWS;

-- product details table
CREATE TABLE product_details (
								product_id VARCHAR(6),
								price INTEGER,
								product_name VARCHAR(32),
								category_id INTEGER,
								segment_id INTEGER,
								style_id INTEGER,
								category_name VARCHAR(6),
								segment_name VARCHAR(6),
								style_name VARCHAR(19)
							);
-- Load data into table
SET GLOBAL LOCAL_INFILE = true;
LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Day70-72 (SQL Case Study7)- product_details.csv'
INTO TABLE product_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES
TERMINATED BY '\n'
IGNORE 1 ROWS;

-- sales table
CREATE TABLE sales (
								prod_id VARCHAR(6),
								qty INTEGER,
								price INTEGER,
								discount INTEGER,
								member ENUM('t', 'f'),
								txn_id VARCHAR(6),
								start_txn_time TIMESTAMP
					);
-- Load data into table
SET GLOBAL LOCAL_INFILE = true;
LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Day70-72 (SQL Case Study7)- sales.csv'
INTO TABLE sales
FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES
TERMINATED BY '\n'
IGNORE 1 ROWS;

-- 1. High Level Sales Analysis
-- 1a. What was the total quantity sold for all products?
SELECT SUM(qty) AS total_quantity_sold
FROM sales;

-- 1b. What is the total generated revenue for all products before discounts?
SELECT SUM(qty * price) AS revenue_before_discount
FROM sales;

-- 1c. What was the total discount amount for all products?
SELECT SUM(discount) AS total_discount
FROM sales;

-- 2. Transaction Analysis
SELECT * FROM product_details;
SELECT * FROM product_hierarchy;
SELECT * FROM product_prices;
SELECT * FROM sales;
-- 2a. How many unique transactions were there?
SELECT COUNT(DISTINCT txn_id) AS total_txns
FROM sales;

-- 2b. What is the average unique products purchased in each transaction?
WITH txn_per_product AS (SELECT txn_id, COUNT(DISTINCT prod_id) AS num_of_products
						FROM sales
						GROUP BY txn_id)
SELECT AVG(num_of_products) AS avg_uniq_prod_per_txn
FROM txn_per_product;
-- 2c. What are the 25th, 50th and 75th percentile values for the revenue per transaction?
WITH rev_per_txn AS (SELECT txn_id, (SUM(qty * price) - SUM(discount)) AS total_revenue
					FROM sales
					GROUP BY txn_id)
SELECT DISTINCT total_revenue, 100.00 * (PERCENT_RANK() OVER(ORDER BY total_revenue)) as percentile
FROM rev_per_txn;
-- 2d. What is the average discount value per transaction?
-- 2e. What is the percentage split of all transactions for members vs non-members?
-- 2f. What is the average revenue for member transactions and non-member transactions?
/*Product Analysis
What are the top 3 products by total revenue before discount?
What is the total quantity, revenue and discount for each segment?
What is the top selling product for each segment?
What is the total quantity, revenue and discount for each category?
What is the top selling product for each category?
What is the percentage split of revenue by product for each segment?
What is the percentage split of revenue by segment for each category?
What is the percentage split of total revenue by category?
What is the total transaction “penetration” for each product? (hint: penetration = number of transactions where at least 1 quantity of a product was purchased divided by total number of transactions)
What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
Reporting Challenge
Write a single SQL script that combines all of the previous questions into a scheduled report that the Balanced Tree team can run at the beginning of each month to calculate the previous month’s values.

Imagine that the Chief Financial Officer (which is also Danny) has asked for all of these questions at the end of every month.

He first wants you to generate the data for January only - but then he also wants you to demonstrate that you can easily run the samne analysis for February without many changes (if at all).

Feel free to split up your final outputs into as many tables as you need - but be sure to explicitly reference which table outputs relate to which question for full marks :)

Bonus Challenge
Use a single SQL query to transform the product_hierarchy and product_prices datasets to the product_details table.

Hint: you may want to consider using a recursive CTE to solve this problem!*/