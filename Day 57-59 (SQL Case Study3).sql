-- DAY 54-56 (SQL Case Study2) Database Setup
-- DATABASE SETUP
-- CREATE DATABASE
DROP DATABASE IF EXISTS listr_musicdb;
CREATE DATABASE listr_musicdb;
USE listr_musicdb;

-- CREATE TABLE
-- Plans Table
CREATE TABLE plans (
  plan_id INTEGER,
  plan_name VARCHAR(13),
  price DECIMAL(5,2)
);
-- Subscription Table
CREATE TABLE subscriptions (
  customer_id INTEGER,
  plan_id INTEGER,
  start_date DATE
);

-- LOAD DATA INTO TABLE
-- Into Plan Table
SET GLOBAL LOCAL_INFILE = true;
LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Day57-59 (SQL Case Study3)- plan.csv'
INTO TABLE plans
FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES
TERMINATED BY '\n'
IGNORE 1 ROWS;
-- Into Subscription Table
SET GLOBAL LOCAL_INFILE = true;
LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Day57-59 (SQL Case Study3)- subscriptions.csv'
INTO TABLE subscriptions
FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES
TERMINATED BY '\n'
IGNORE 1 ROWS;


-- QUESTION
-- 1. How many subscribers has listr ever had?
SELECT 
    COUNT(DISTINCT customer_id) AS total_subscribers
FROM
    subscriptions;

-- 2. What is the monthly distribution of trial plan start_date values for our dataset - use the start of the month as the group by value
SELECT 
    MONTH(start_date), MONTHNAME(start_date) AS sub_month,  COUNT(*) AS mnthly_dist
FROM
    subscriptions
WHERE
    plan_id = 0
GROUP BY MONTH(start_date), MONTHNAME(start_date)
ORDER BY MONTH(start_date);

-- 3. What plan start_date values occur after the year 2020 for our dataset? Show the breakdown by count of events for each plan_name
SELECT 
    p.plan_name, COUNT(p.plan_name) AS total_subs
FROM
    plans p
        JOIN
    subscriptions s ON p.plan_id = s.plan_id
WHERE
    YEAR(start_date) > 2020
GROUP BY p.plan_name
ORDER BY total_subs;

-- 4. What is the subscriber count and percentage of subscribers who have churned rounded to 1 decimal place?
WITH churn_cte AS (SELECT COUNT(*) AS churn_subscribers,
						(SELECT COUNT(DISTINCT customer_id) FROM subscriptions) AS tot_subscribers
						FROM subscriptions
						WHERE plan_id = 4)
SELECT churn_subscribers,tot_subscribers, ROUND(100.00 * ((churn_subscribers/tot_subscribers)),2) AS churn_perc
FROM churn_cte;
    
-- 5. How many subscribers have churned straight after their initial free trial -
	-- what percentage is this rounded to the nearest whole number?
	-- What is the number and percentage of subscriber plans after their initial free trial?
WITH next_sub_cte AS (SELECT customer_id, plan_id, 
							LEAD(plan_id) OVER(PARTITION BY customer_id ORDER BY customer_id) next_sub
						FROM subscriptions)
SELECT SUM(CASE WHEN plan_id = 0 AND next_sub = 4 THEN 1 ELSE 0 END) AS churn_from_trial, 
		COUNT(DISTINCT customer_id) AS total_subscribers,
        ROUND(100.00 * (SUM(CASE WHEN plan_id = 0 AND next_sub = 4 THEN 1 ELSE 0 END)/
				COUNT(DISTINCT customer_id)),0) AS perc_churn_from_trial
FROM next_sub_cte;

-- 6. What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?
WITH last_sub_cte AS (SELECT s.customer_id, p.plan_name, s.start_date,
							LEAD(s.start_date) OVER(PARTITION BY s.customer_id ORDER BY s.start_date ASC) AS next_sub_date
					FROM plans p
					INNER JOIN subscriptions s ON p.plan_id = s.plan_id
					WHERE s.start_date <= '2020-12-31'),
plan_sub_cte AS 	(SELECT plan_name, COUNT(DISTINCT customer_id) AS tot_subs
					FROM last_sub_cte 
					WHERE next_sub_date IS NULL
					GROUP BY plan_name)
SELECT plan_name, tot_subs, ROUND(100.00 * (tot_subs/ (SELECT SUM(tot_subs) FROM plan_sub_cte)),2) AS sub_perc
FROM plan_sub_cte
GROUP BY plan_name
ORDER BY tot_subs;

-- 7. How many customers have upgraded to an annual plan in 2020 and From which Plan?
WITH next_plan_cte AS (
					SELECT s.customer_id, p.plan_name, 
							LEAD(p.plan_name) OVER(PARTITION BY s.customer_id ORDER BY s.customer_id ASC) AS next_plan
					FROM subscriptions s
                    JOIN plans p ON s.plan_id = p.plan_id
                    WHERE YEAR(s.start_date) = 2020)
SELECT plan_name, COUNT(DISTINCT customer_id) AS subscriber_count 
FROM next_plan_cte 
WHERE next_plan = 'pro annual'
GROUP BY plan_name
ORDER BY subscriber_count;

-- 8. How many days on average does it take for a customer to an annual plan from the day they join Foodie-Fi?
-- 
 WITH start_cte AS 
				(SELECT customer_id, start_date AS trial_date 
                FROM subscriptions 
                WHERE plan_id = 0),
 premium_cte AS 
				(SELECT customer_id, start_date AS annual_plan_date 
                FROM subscriptions 
                WHERE plan_id = 3),
 day_to_premium_cte AS 
				(SELECT s.customer_id, s.trial_date, p.annual_plan_date, ABS(DATEDIFF(s.trial_date, p.annual_plan_date)) AS day_to_premium
				FROM start_cte s
				JOIN premium_cte p ON s.customer_id = p.customer_id)
 SELECT 
		COUNT(day_to_premium) AS tot_subscribers, 
        ROUND(AVG(day_to_premium),0) AS avg_day_to_premium
 FROM day_to_premium_cte;
 
 -- Can you further breakdown this average value into Monthly periods (i.e. First Month, Second Month till after Six Month etc)
 WITH start_cte AS 
				(SELECT customer_id, start_date AS trial_date 
                FROM subscriptions 
                WHERE plan_id = 0),
 premium_cte AS 
				(SELECT customer_id, start_date AS annual_plan_date 
                FROM subscriptions 
                WHERE plan_id = 3),
 day_to_premium_cte AS 
				(SELECT s.customer_id, s.trial_date, p.annual_plan_date, ABS(DATEDIFF(s.trial_date, p.annual_plan_date)) AS day_to_premium
				FROM start_cte s
				JOIN premium_cte p ON s.customer_id = p.customer_id)
 SELECT CASE
				WHEN day_to_premium BETWEEN 0 AND 30 THEN 'First Month'
                WHEN day_to_premium BETWEEN 31 AND 60 THEN 'Second Month'
                WHEN day_to_premium BETWEEN 61 AND 90 THEN 'Third Month'
                WHEN day_to_premium BETWEEN 91 AND 120 THEN 'Fourth Month'
                WHEN day_to_premium BETWEEN 121 AND 150 THEN 'Fifth Month'
                WHEN day_to_premium BETWEEN 151 AND 180 THEN 'Sixth month'
                ELSE 'After Six Month' END AS month_grp, 
		COUNT(day_to_premium) AS tot_subscribers, ROUND(AVG(day_to_premium),2) AS avg_day_to_premium
 FROM day_to_premium_cte
 GROUP BY month_grp
 ORDER BY FIELD(month_grp,'First Month','Second Month','Third Month','Fourth Month','Fifth Month','Sixth month','After Six Month');

-- 9. How many customers downgraded from a superior plan
WITH next_plan_cte AS (SELECT customer_id, plan_id, 
								LEAD(plan_id) OVER(PARTITION BY customer_id ORDER BY customer_id ASC) AS next_plan, start_date
						FROM subscriptions
						WHERE YEAR(start_date) = 2020)
SELECT COUNT(DISTINCT customer_id) AS downgraded_subscribers
FROM next_plan_cte
WHERE next_plan IS NOT NULL AND next_plan < plan_id;