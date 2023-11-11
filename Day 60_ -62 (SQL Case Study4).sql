USE databank;
SELECT *
FROM regions r
JOIN customers c ON r.region_id = c.region_id
JOIN transactions t ON c.customer_id = t.customer_id;


-- 1. CUSTOMER NODES EXPLORATION

-- 1a. How many unique nodes are there on the Data Bank system?
SELECT COUNT(DISTINCT node_id) AS uniq_node_count 
FROM customers;

-- 1b. What is the number of nodes per region?
SELECT r.region_name, COUNT(DISTINCT node_id) AS node_count
FROM regions r
JOIN customers c ON r.region_id = c.region_id
GROUP BY r.region_name
ORDER BY node_count;

-- 1c. How many customers are allocated to each region?
SELECT r.region_name, COUNT(DISTINCT c.customer_id) AS customer_count
FROM regions r
JOIN customers c ON r.region_id = c.region_id
GROUP BY r.region_name
ORDER BY customer_count;

-- 1d. How many days on average are customers reallocated to a different node?
WITH next_node_cte AS (
						SELECT customer_id, 
								node_id, LEAD(node_id) OVER (PARTITION BY customer_id ORDER BY customer_id) AS next_node,
								start_date, LEAD(start_date) OVER (PARTITION BY customer_id ORDER BY customer_id) AS next_node_date
						FROM customers),
days2nodeswitch_cte AS (
						SELECT customer_id, ABS(DATEDIFF(DAY,start_date, next_node_date)) AS day_for_node_switch
						FROM next_node_cte
						WHERE node_id <> next_node)
SELECT AVG(day_for_node_switch) AS avg_day_for_node_switch
FROM days2nodeswitch_cte;

--1e. What is the median, 80th and 95th percentile for this same reallocation days metric for each region?
WITH next_node_cte AS (
						SELECT r.region_name, 
								c.node_id, LEAD(c.node_id) OVER (PARTITION BY r.region_name ORDER BY r.region_name) AS next_node,
								c.start_date, LEAD(c.start_date) OVER (PARTITION BY r.region_name ORDER BY r.region_name) AS next_node_date
						FROM regions r
						JOIN customers c on r.region_id = c.region_id),
days2nodeswitch_cte AS (SELECT region_name, 
								ABS(DATEDIFF(DAY,start_date, next_node_date)) AS day_for_node_switch
						FROM next_node_cte
						WHERE node_id <> next_node)
SELECT DISTINCT region_name,
		PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY day_for_node_switch) OVER(PARTITION BY region_name)AS median_day,
		PERCENTILE_CONT(0.8) WITHIN GROUP(ORDER BY day_for_node_switch) OVER(PARTITION BY region_name)AS eightiethpercentile_day,
		PERCENTILE_CONT(0.95) WITHIN GROUP(ORDER BY day_for_node_switch) OVER(PARTITION BY region_name)AS ninetyfifthpercentile_day
FROM days2nodeswitch_cte
ORDER BY region_name;

-- 2. CUSTOMER TRANSACTIONS
USE databank;

-- 2a. What is the unique count and total amount for each transaction type?
SELECT txn_type, 
		COUNT(txn_type) AS txn_count, 
		SUM(txn_amount) AS tot_amount
FROM transactions
GROUP BY txn_type;

-- 2b. What is the average total historical deposit counts and amounts for all customers?
SELECT customer_id, 
		COUNT(customer_id) AS tot_deposit, 
		AVG(txn_amount) AS avg_deposit_value
FROM transactions
WHERE txn_type = 'deposit'
GROUP BY customer_id
ORDER BY customer_id;

-- 2c. For each month - how many Data Bank customers make more than 1 deposit and either 1 purchase or 1 withdrawal in a single month?
WITH dep_pur_with_cte AS (
							SELECT customer_id, MONTH(txn_date) AS txn_month,
									SUM (CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) AS dep_count,
									SUM (CASE WHEN txn_type IN('purchase', 'withdrawal') THEN 1 ELSE 0 END) AS pur_withd_count
							FROM transactions
							GROUP BY customer_id, MONTH(txn_date)
							)
SELECT txn_month, COUNT(*) AS total_customers
FROM dep_pur_with_cte
WHERE dep_count > 1 AND pur_withd_count > 1
GROUP BY txn_month
ORDER BY txn_month;

SELECT txn_month, COUNT(*) AS total_customers
FROM (
							SELECT customer_id, MONTH(txn_date) AS txn_month,
									SUM (CASE WHEN txn_type = 'deposit' THEN 1 ELSE 0 END) AS dep_count,
									SUM (CASE WHEN txn_type IN('purchase', 'withdrawal') THEN 1 ELSE 0 END) AS pur_withd_count
							FROM transactions
							GROUP BY customer_id, MONTH(txn_date)
							) AS dep_pur_with_cte
WHERE dep_count > 1 AND pur_withd_count > 1
GROUP BY txn_month
ORDER BY txn_month;


-- 2d. What is the closing balance for each customer at the end of the month?
USE databank;
WITH tot_dep_pur_withd_cte AS (
							SELECT EOMONTH(txn_date) AS month_end,
									customer_id, 
									SUM (CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE 0 END) AS dep_value,
									SUM (CASE WHEN txn_type IN('purchase', 'withdrawal') THEN txn_amount ELSE 0 END) AS pur_withd_value
							FROM transactions
							GROUP BY customer_id, EOMONTH(txn_date)
							)
SELECT month_end, 
		customer_id, 
		(dep_value - pur_withd_value) AS closing_balance
FROM tot_dep_pur_withd_cte
ORDER BY month_end, customer_id;

-- 2e. What is the percentage of customers who increase their closing balance by more than 5%?
WITH new_txn_amount_cte AS (SELECT customer_id, txn_date, (CASE WHEN txn_type = 'deposit' THEN txn_amount 
									ELSE (-1*txn_amount) END) AS new_txn_amount
							FROM transactions
							),
running_sum_cte AS			(SELECT *, SUM(new_txn_amount) OVER(PARTITION BY customer_id ORDER BY txn_date) AS running_sum
							FROM new_txn_amount_cte
							),
open_close_bal_cte AS		(SELECT DISTINCT customer_id, 
											FIRST_VALUE(running_sum) OVER(PARTITION BY customer_id ORDER BY txn_date
																	RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS opening_balance,
											LAST_VALUE(running_sum) OVER(PARTITION BY customer_id ORDER BY txn_date 
																	RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS closing_balance
							FROM running_sum_cte
							),
final_cte AS (SELECT  COUNT (*) AS total_customers, 
						(SELECT COUNT(*)
						FROM open_close_bal_cte
						WHERE opening_balance < closing_balance AND (1.05*opening_balance < closing_balance)) AS elite_customers		
				FROM open_close_bal_cte)
SELECT *, ROUND(((elite_customers)/(total_customers*1.00)),3) AS percent_elite
FROM final_cte;



-- 3. Data Allocation Challenge
/*To test out a few different hypotheses - the Data Bank team wants to run an experiment where different groups of customers 
would be allocated data using 3 different options:
Option 1: data is allocated based off the amount of money at the end of the previous month
Option 2: data is allocated on the average amount of money kept in the account in the previous 30 days
Option 3: data is updated real-time
For this multi-part challenge question - you have been requested to generate the following data elements to help the 
Data Bank team estimate how much data will need to be provisioned for each option:
-- running customer balance column that includes the impact each transaction customer balance at the end of each month
-- minimum, average and maximum values of the running balance for each customer
Using all of the data available - how much data would have been required for each option on a monthly basis?*/

-- 3a. Customer RUnning Balance At the End of the Month
USE databank;
WITH txn_amount_cte AS (
						SELECT customer_id,txn_date, MONTH(txn_date) AS txn_month, txn_amount, 
								(CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE (-1*txn_amount) END) AS real_txn_amount
						FROM transactions
						),
running_sum_cte AS		(
						SELECT customer_id,txn_date, txn_month, real_txn_amount,
								SUM(real_txn_amount) OVER(PARTITION BY customer_id, txn_month ORDER BY txn_date ASC) AS running_sum_txn_amount
						FROM txn_amount_cte
						)
SELECT DISTINCT customer_id, EOMONTH(txn_date) AS closing_month, 
				LAST_VALUE(running_sum_txn_amount) OVER(PARTITION BY customer_id ORDER BY txn_month
																	) AS closing_balance
FROM running_sum_cte
ORDER BY closing_month;

-- Minimum, Average and Maximum Closing Balance for each customer
WITH txn_amount_cte AS (
						SELECT customer_id,txn_date, MONTH(txn_date) AS txn_month, txn_amount, 
								(CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE (-1*txn_amount) END) AS real_txn_amount
						FROM transactions
						),
running_sum_cte AS		(
						SELECT customer_id,txn_date, txn_month, real_txn_amount,
								SUM(real_txn_amount) OVER(PARTITION BY customer_id, txn_month ORDER BY txn_date ASC) AS running_sum_txn_amount
						FROM txn_amount_cte
						),
closing_balance_cte AS	(
						SELECT DISTINCT customer_id, EOMONTH(txn_date) AS closing_month, 
										LAST_VALUE(running_sum_txn_amount) OVER(PARTITION BY customer_id ORDER BY txn_month
																	) AS closing_balance
						FROM running_sum_cte
						)
SELECT customer_id, 
		MIN(closing_balance) AS min_closn_bal,
		MAX(closing_balance) AS max_closn_bal,
		AVG(closing_balance) AS avg_closn_bal
FROM closing_balance_cte
GROUP BY customer_id
ORDER BY customer_id;

-- Monthly Data Need based on Option 1 (Based on the amount of money at the end of the previous month)
WITH real_txn_amount_cte AS (
							SELECT txn_date, 
									(CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE (-1*txn_amount) END) AS real_txn_amount 
							FROM transactions
							)
SELECT EOMONTH(txn_date) AS end_of_month, SUM(real_txn_amount) AS net_txn, 
		LAG(SUM(real_txn_amount)) OVER(ORDER BY EOMONTH(txn_date)) AS prev_net_txn
FROM real_txn_amount_cte
GROUP BY EOMONTH(txn_date)
ORDER BY end_of_month;


-- Data Allocated Based on Option 2 (Based on average amount of money kept in the account in the previous 30 days)
USE databank;
WITH total_deposit_cte AS (
							SELECT txn_date, AVG(txn_amount) AS tot_dep
							FROM transactions
							WHERE txn_type = 'deposit'
							GROUP BY txn_date
							)
SELECT txn_date,tot_dep, AVG(tot_dep) OVER(ORDER BY txn_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS thirty_days_rolling
FROM total_deposit_cte;

-- Data Allocated Based on Option 3: (Based on Real Time Transactions)
SELECT txn_date, 
		(CASE WHEN txn_type = 'deposit' THEN txn_amount ELSE (-1*txn_amount) END) AS real_txn_amount 
FROM transactions
ORDER BY txn_date;