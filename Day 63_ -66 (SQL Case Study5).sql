-- DAY 63-66 (CASE STUDY 5)
DROP DATABASE IF EXISTS data_mart;

CREATE DATABASE data_mart;

USE data_mart;

DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
	week_date VARCHAR(7),
	region VARCHAR(13),
	platform VARCHAR(7),
	segment VARCHAR(4),
	customer_type VARCHAR(8),
	transactions INTEGER,
	sales INTEGER
);

SET
	GLOBAL LOCAL_INFILE = true;

LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Day63-66 (SQL Case Study5)- weekly_sales.csv' INTO TABLE sales FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

SELECT
	*
FROM
	sales;

-- 1. Data Cleansing Steps
-- In a single query, perform the following operations and generate a new table in the data_mart schema named clean_sales:
-- 1a. Convert the week_date to a DATE format
DROP TABLE IF EXISTS clean_sales;

CREATE TABLE clean_sales AS
SELECT
	week_date,
	DATE_FORMAT(week_date, '%d/%m/%y') as new_date
FROM
	sales;

SELECT
	*,
	YEAR(new_date)
FROM
	clean_sales;

-- 1b. Add a week_number as the second column for each week_date value, for example any value from the 1st of January to 7th of January will be 1, 8th to 14th will be 2 etc
DROP TABLE IF EXISTS clean_sales;

CREATE TABLE clean_sales AS
SELECT
	DATE_FORMAT(week_date, '%d/%m/%y') as new_date,
	WEEK(DATE_FORMAT(week_date, '%d/%m/%y')) AS week_num
FROM
	sales;

SELECT
	*
FROM
	clean_sales
ORDER BY
	new_date;

-- 1c. Add a month_number with the calendar month for each week_date value as the 3rd column
DROP TABLE IF EXISTS clean_sales;

CREATE TABLE clean_sales AS
SELECT
	DATE_FORMAT(week_date, '%d/%m/%y') as new_date,
	WEEK(DATE_FORMAT(week_date, '%d/%m/%y')) AS week_num,
	MONTH(DATE_FORMAT(week_date, '%d/%m/%y')) AS month_num
FROM
	sales;

SELECT
	*
FROM
	clean_sales
ORDER BY
	new_date;

-- 1d. Add a calendar_year column as the 4th column containing either 2018, 2019 or 2020 values
DROP TABLE IF EXISTS clean_sales;

CREATE TABLE clean_sales AS
SELECT
	DATE_FORMAT(week_date, '%d/%m/%y') as new_date,
	WEEK(DATE_FORMAT(week_date, '%d/%m/%y')) AS week_num,
	MONTH(DATE_FORMAT(week_date, '%d/%m/%y')) AS month_num,
	YEAR(DATE_FORMAT(week_date, '%d/%m/%y')) AS calender_year
FROM
	sales;

SELECT
	*
FROM
	clean_sales
ORDER BY
	new_date;

-- 1e. Add a new column called age_band after the original segment column using the following mapping on the number inside the segment value
/*		1	Young Adults
 2	Middle Aged
 3 or 4	Retirees
 */
DROP TABLE IF EXISTS clean_sales;

CREATE TABLE clean_sales AS
SELECT
	DATE_FORMAT(week_date, '%d/%m/%y') as new_date,
	WEEK(DATE_FORMAT(week_date, '%d/%m/%y')) AS week_num,
	MONTH(DATE_FORMAT(week_date, '%d/%m/%y')) AS month_num,
	YEAR(DATE_FORMAT(week_date, '%d/%m/%y')) AS calender_year,
	segment,
	(
		CASE
			WHEN RIGHT(segment, 1) = '1' THEN 'Young Adults'
			WHEN RIGHT(segment, 1) = '2' THEN 'Middle Aged'
			WHEN RIGHT(segment, 1) IN ('3', '4') THEN 'Retirees'
			ELSE 'unknown'
		END
	) AS age_band
FROM
	sales;

SELECT
	*
FROM
	clean_sales
ORDER BY
	new_date;

-- 1f. Add a new demographic column using the following mapping for the first letter in the segment values:
/*		segment	demographic
 C	Couples
 F	Families
 Ensure all null string values with an "unknown" string value in the original segment column as well as the new age_band and demographic columns
 */
DROP TABLE IF EXISTS clean_sales;

CREATE TABLE clean_sales AS
SELECT
	DATE_FORMAT(week_date, '%d/%m/%y') as new_date,
	WEEK(DATE_FORMAT(week_date, '%d/%m/%y')) AS week_num,
	MONTH(DATE_FORMAT(week_date, '%d/%m/%y')) AS month_num,
	YEAR(DATE_FORMAT(week_date, '%d/%m/%y')) AS calender_year,
	segment,
	(
		CASE
			WHEN RIGHT(segment, 1) = '1' THEN 'Young Adults'
			WHEN RIGHT(segment, 1) = '2' THEN 'Middle Aged'
			WHEN RIGHT(segment, 1) IN ('3', '4') THEN 'Retirees'
			ELSE 'unknown'
		END
	) AS age_band,
	(
		CASE
			WHEN LEFT(segment, 1) = 'C' THEN 'Couples'
			WHEN LEFT(segment, 1) = 'F' THEN 'Families'
			ELSE 'unknown'
		END
	) AS demography
FROM
	sales;

SELECT
	*
FROM
	clean_sales
ORDER BY
	new_date;

SELECT
	*
FROM
	sales;

-- 1g. Generate a new avg_transaction column as the sales value divided by transactions rounded to 2 decimal places for each record
DROP TABLE IF EXISTS clean_sales;

CREATE TABLE clean_sales AS
SELECT
	DATE_FORMAT(week_date, '%d/%m/%y') as new_date,
	WEEK(DATE_FORMAT(week_date, '%d/%m/%y')) AS week_num,
	MONTH(DATE_FORMAT(week_date, '%d/%m/%y')) AS month_num,
	YEAR(DATE_FORMAT(week_date, '%d/%m/%y')) AS calender_year,
	(
		CASE
			WHEN RIGHT(segment, 1) = '1' THEN 'Young Adults'
			WHEN RIGHT(segment, 1) = '2' THEN 'Middle Aged'
			WHEN RIGHT(segment, 1) IN ('3', '4') THEN 'Retirees'
			ELSE 'unknown'
		END
	) AS age_band,
	(
		CASE
			WHEN LEFT(segment, 1) = 'C' THEN 'Couples'
			WHEN LEFT(segment, 1) = 'F' THEN 'Families'
			ELSE 'unknown'
		END
	) AS demography,
	region,
	platform,
	customer_type,
	transactions,
	sales,
	ROUND((sales / transactions), 2) AS avg_transactions
FROM
	sales;

SELECT
	*
FROM
	clean_sales
ORDER BY
	new_date;

-- 2. Data Exploration
-- 2a. What day of the week is used for each week_date value?
SELECT
	DISTINCT DAYNAME(new_date) AS day_of_week
FROM
	clean_sales
ORDER BY
	day_of_week;

-- 2b. What range of week numbers are missing from the dataset?
SELECT
	DISTINCT WEEKOFYEAR(
		DATE_FORMAT(ADDDATE('2018-1-1', @NUM := @NUM + 1), '%Y-%m-%d')
	) AS missing_weeks
FROM
	clean_sales,
	(
		SELECT
			@NUM := -1
	) num
WHERE
	WEEKOFYEAR(
		DATE_FORMAT(ADDDATE('2018-1-1', @NUM := @NUM + 1), '%Y-%m-%d')
	) NOT IN (
		SELECT
			DISTINCT WEEKOFYEAR(new_date)
		FROM
			clean_sales
	);

-- 2c. How many total transactions were there for each year in the dataset?
SELECT
	YEAR(new_date) AS sales_year,
	SUM(transactions) AS tot_txns
FROM
	clean_sales
GROUP BY
	YEAR(new_date)
ORDER BY
	sales_year;

-- 2d. What is the total sales for each region for each month?
SELECT
	region,
	sales_month,
	tot_sales
FROM
	(
		SELECT
			region,
			MONTH(new_date),
			MONTHNAME(new_date) AS sales_month,
			SUM(sales) AS tot_sales
		FROM
			clean_sales
		GROUP BY
			region,
			MONTH(new_date),
			MONTHNAME(new_date)
		ORDER BY
			MONTH(new_date) ASC,
			region ASC
	) AS raw_select;

-- 2e. What is the total count of transactions for each platform?
SELECT
	platform,
	COUNT(*) AS txn_count
FROM
	clean_sales
GROUP BY
	platform
ORDER BY
	txn_count;

-- 2f. What is the percentage of sales for Retail vs Shopify for each month?
SELECT
	MONTH(new_date) AS sales_month,
	SUM(sales) AS tot_sales,
	ROUND(
		100.00 * (
			SUM(
				CASE
					WHEN platform = 'Retail' THEN sales
					ELSE 0
				END
			) / SUM(sales)
		),
		2
	) AS retail_sales_percent,
	ROUND(
		100.00 * (
			SUM(
				CASE
					WHEN platform = 'Shopify' THEN sales
					ELSE 0
				END
			) / SUM(sales)
		),
		2
	) AS shopify_sales_percent
FROM
	clean_sales
GROUP BY
	MONTH(new_date)
ORDER BY
	sales_month;

-- 2g. What is the percentage of sales by demographic for each year in the dataset?
SELECT
	YEAR(new_date) AS sales_year,
	SUM(sales) AS tot_sales,
	ROUND(
		100.00 * (
			SUM(
				CASE
					WHEN demography = 'Families' THEN sales
					ELSE 0
				END
			) / SUM(sales)
		),
		2
	) AS families_sales_percent,
	ROUND(
		100.00 * (
			SUM(
				CASE
					WHEN demography = 'Couples' THEN sales
					ELSE 0
				END
			) / SUM(sales)
		),
		2
	) AS couples_sales_percent,
	ROUND(
		100.00 * (
			SUM(
				CASE
					WHEN demography = 'unknown' THEN sales
					ELSE 0
				END
			) / SUM(sales)
		),
		2
	) AS unknown_sales_percent
FROM
	clean_sales
GROUP BY
	YEAR(new_date)
ORDER BY
	YEAR(new_date);

-- 2h. Which age_band and demographic values contribute the most to Retail sales?
SELECT
	*
FROM
	clean_sales;

SELECT
	age_band,
	SUM(sales) AS tot_sales
FROM
	clean_sales
GROUP BY
	age_band
ORDER BY
	tot_sales;

SELECT
	demography,
	SUM(sales) AS tot_sales
FROM
	clean_sales
GROUP BY
	demography
ORDER BY
	tot_sales;

SELECT
	age_band,
	SUM(sales) AS tot_sales,
	SUM(
		CASE
			WHEN demography = 'Families' THEN sales
			ELSE 0
		END
	) AS families_sales,
	SUM(
		CASE
			WHEN demography = 'Couples' THEN sales
			ELSE 0
		END
	) AS couples_sales,
	SUM(
		CASE
			WHEN demography = 'unknown' THEN sales
			ELSE 0
		END
	) AS unknown_sales
FROM
	clean_sales
WHERE
	platform = 'Retail'
GROUP BY
	age_band
ORDER BY
	tot_sales DESC;

SELECT
	age_band,
	demography,
	SUM(sales) AS tot_sales
FROM
	clean_sales
WHERE
	platform = 'Retail'
GROUP BY
	age_band,
	demography
ORDER BY
	age_band DESC;

-- 2i. Can we use the avg_transaction column to find the average transaction size for each year for Retail vs Shopify? 
-- If not - how would you calculate it instead?
SELECT
	YEAR(new_date) AS sales_year,
	platform,
	ROUND(AVG(avg_transactions), 2) AS method1,
	ROUND((SUM(sales) / SUM(transactions)), 2) AS method2
FROM
	clean_sales
GROUP BY
	YEAR(new_date),
	platform
ORDER BY
	sales_year;

-- NO, WE CAN NOT GET THE AVERAGE OF avg_transaction by Averaging the avg_transaction column 
-- But By Dividing the Sum of Sales by the sum of the transactions for each platform
/*3. Before & After Analysis
 This technique is usually used when we inspect an important event and want to inspect the impact before and after a certain point in time.
 Taking the week_date value of 2020-06-15 as the baseline week where the Data Mart sustainable packaging changes came into effect.
 We would include all week_date values for 2020-06-15 as the start of the period after the change and the previous week_date values would be before*/
-- Using this analysis approach - answer the following questions:
-- 3a. What is the total sales for the 4 weeks before and after 2020-06-15? 
-- What is the growth or reduction rate in actual values and percentage of sales?
USE data_mart;

WITH 4_week_prior AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -4 WEEK
			),
			'%y/%m/%d'
		)
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -1 WEEK
			),
			'%y/%m/%d'
		)
),
4_week_after AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT('2020-06-15', '%y/%m/%d')
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL 3 WEEK
			),
			'%y/%m/%d'
		)
),
total_sales AS (
	SELECT
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						4_week_prior
				) THEN sales
			END
		) AS sales_4_week_prior,
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						4_week_after
				) THEN sales
			END
		) AS sales_4_week_after
	FROM
		clean_sales
)
SELECT
	*,
	(sales_4_week_after - sales_4_week_prior) AS variance,
	ROUND(
		100.00 * (
			(sales_4_week_after - sales_4_week_prior) / sales_4_week_prior
		),
		2
	) AS percent_change
FROM
	total_sales;

-- 3b. What about the entire 12 weeks before and after?
WITH 12_week_prior AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -12 WEEK
			),
			'%y/%m/%d'
		)
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -1 WEEK
			),
			'%y/%m/%d'
		)
),
12_week_after AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT('2020-06-15', '%y/%m/%d')
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL 11 WEEK
			),
			'%y/%m/%d'
		)
),
total_sales AS (
	SELECT
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						12_week_prior
				) THEN sales
			END
		) AS sales_12_week_prior,
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						12_week_after
				) THEN sales
			END
		) AS sales_12_week_after
	FROM
		clean_sales
)
SELECT
	*,
	(sales_12_week_after - sales_12_week_prior) AS variance,
	ROUND(
		100.00 * (
			(sales_12_week_after - sales_12_week_prior) / sales_12_week_prior
		),
		2
	) AS percent_change
FROM
	total_sales;

-- How do the sale metrics for these 2 periods before and after compare with the previous years in 2018 and 2019?
SELECT
	*
FROM
	clean_sales;

WITH week_num_cte AS (
	SELECT
		DISTINCT week_num
	FROM
		clean_sales
	WHERE
		new_date = DATE_FORMAT('2020-06-15', '%y/%m/%d')
),
4_weeks_prior AS (
	SELECT
		week_num
	FROM
		clean_sales
	WHERE
		week_num BETWEEN(
			SELECT
				week_num
			FROM
				week_num_cte
		) -4
		AND (
			SELECT
				week_num
			FROM
				week_num_cte
		) -1
),
4_weeks_after AS (
	SELECT
		week_num
	FROM
		clean_sales
	WHERE
		week_num BETWEEN(
			SELECT
				week_num
			FROM
				week_num_cte
		)
		AND (
			SELECT
				week_num
			FROM
				week_num_cte
		) + 3
),
total_sales AS (
	SELECT
		calender_year,
		SUM(
			CASE
				WHEN week_num IN (
					SELECT
						*
					FROM
						4_weeks_prior
				) THEN sales
			END
		) AS sales_4_weeks_prior,
		SUM(
			CASE
				WHEN week_num IN (
					SELECT
						*
					FROM
						4_weeks_after
				) THEN sales
			END
		) AS sales_4_weeks_after
	FROM
		clean_sales
	GROUP BY
		calender_year
	ORDER BY
		calender_year
)
SELECT
	*,
	(sales_4_weeks_after - sales_4_weeks_prior) AS variance,
	ROUND(
		100.00 *(
			(sales_4_weeks_after - sales_4_weeks_prior) / sales_4_weeks_prior
		),
		2
	) AS percent_change
FROM
	total_sales;

/*4. Bonus Question
 Which areas of the business have the highest negative impact in sales metrics performance in 2020 for the 12 week before and after period?
 -- region
 -- platform
 -- age_band
 -- demographic
 -- customer_type
 Do you have any further recommendations for Danny’s team at Data Mart or any interesting insights based off this analysis?*/
-- 4a. For Region
WITH 12_week_prior AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -12 WEEK
			),
			'%y/%m/%d'
		)
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -1 WEEK
			),
			'%y/%m/%d'
		)
),
12_week_after AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT('2020-06-15', '%y/%m/%d')
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL 11 WEEK
			),
			'%y/%m/%d'
		)
),
total_sales AS (
	SELECT
		region,
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						12_week_prior
				) THEN sales
			END
		) AS sales_12_week_prior,
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						12_week_after
				) THEN sales
			END
		) AS sales_12_week_after
	FROM
		clean_sales
	GROUP BY
		region
)
SELECT
	*,
	(sales_12_week_after - sales_12_week_prior) AS variance,
	ROUND(
		100.00 * (
			(sales_12_week_after - sales_12_week_prior) / sales_12_week_prior
		),
		2
	) AS percent_change
FROM
	total_sales
ORDER BY
	percent_change DESC;

-- 4b. For Platform
WITH 12_week_prior AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -12 WEEK
			),
			'%y/%m/%d'
		)
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -1 WEEK
			),
			'%y/%m/%d'
		)
),
12_week_after AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT('2020-06-15', '%y/%m/%d')
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL 11 WEEK
			),
			'%y/%m/%d'
		)
),
total_sales AS (
	SELECT
		platform,
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						12_week_prior
				) THEN sales
			END
		) AS sales_12_week_prior,
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						12_week_after
				) THEN sales
			END
		) AS sales_12_week_after
	FROM
		clean_sales
	GROUP BY
		platform
)
SELECT
	*,
	(sales_12_week_after - sales_12_week_prior) AS variance,
	ROUND(
		100.00 * (
			(sales_12_week_after - sales_12_week_prior) / sales_12_week_prior
		),
		2
	) AS percent_change
FROM
	total_sales
ORDER BY
	percent_change DESC;

-- 4c. For Age Band
WITH 12_week_prior AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -12 WEEK
			),
			'%y/%m/%d'
		)
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -1 WEEK
			),
			'%y/%m/%d'
		)
),
12_week_after AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT('2020-06-15', '%y/%m/%d')
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL 11 WEEK
			),
			'%y/%m/%d'
		)
),
total_sales AS (
	SELECT
		age_band,
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						12_week_prior
				) THEN sales
			END
		) AS sales_12_week_prior,
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						12_week_after
				) THEN sales
			END
		) AS sales_12_week_after
	FROM
		clean_sales
	GROUP BY
		age_band
)
SELECT
	*,
	(sales_12_week_after - sales_12_week_prior) AS variance,
	ROUND(
		100.00 * (
			(sales_12_week_after - sales_12_week_prior) / sales_12_week_prior
		),
		2
	) AS percent_change
FROM
	total_sales
ORDER BY
	percent_change DESC;

-- 4d. For Demography
WITH 12_week_prior AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -12 WEEK
			),
			'%y/%m/%d'
		)
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -1 WEEK
			),
			'%y/%m/%d'
		)
),
12_week_after AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT('2020-06-15', '%y/%m/%d')
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL 11 WEEK
			),
			'%y/%m/%d'
		)
),
total_sales AS (
	SELECT
		demography,
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						12_week_prior
				) THEN sales
			END
		) AS sales_12_week_prior,
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						12_week_after
				) THEN sales
			END
		) AS sales_12_week_after
	FROM
		clean_sales
	GROUP BY
		demography
)
SELECT
	*,
	(sales_12_week_after - sales_12_week_prior) AS variance,
	ROUND(
		(
			(sales_12_week_after - sales_12_week_prior) / sales_12_week_prior
		),
		4
	) AS percent_change
FROM
	total_sales
ORDER BY
	percent_change DESC;

-- 4e. For Customer Type
WITH 12_week_prior AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -12 WEEK
			),
			'%y/%m/%d'
		)
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL -1 WEEK
			),
			'%y/%m/%d'
		)
),
12_week_after AS (
	SELECT
		DISTINCT new_date
	FROM
		clean_sales
	WHERE
		new_date BETWEEN DATE_FORMAT('2020-06-15', '%y/%m/%d')
		AND DATE_FORMAT(
			DATE_ADD(
				DATE_FORMAT('2020-06-15', '%y/%m/%d'),
				INTERVAL 11 WEEK
			),
			'%y/%m/%d'
		)
),
total_sales AS (
	SELECT
		customer_type,
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						12_week_prior
				) THEN sales
			END
		) AS sales_12_week_prior,
		SUM(
			CASE
				WHEN new_date IN (
					SELECT
						*
					FROM
						12_week_after
				) THEN sales
			END
		) AS sales_12_week_after
	FROM
		clean_sales
	GROUP BY
		customer_type
)
SELECT
	*,
	(sales_12_week_after - sales_12_week_prior) AS variance,
	ROUND(
		100.00 * (
			(sales_12_week_after - sales_12_week_prior) / sales_12_week_prior
		),
		2
	) AS percent_change
FROM
	total_sales
ORDER BY
	percent_change DESC;