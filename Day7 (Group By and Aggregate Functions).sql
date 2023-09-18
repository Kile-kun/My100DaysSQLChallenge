-- DAY 7: (Group By and Aggregate Functions)
USE sales_db;
-- Get the total revenue, total number of product and number of transaction, highest and lowest transaction revenue recorded for each month

SELECT MONTH(order_date) AS sales_month, SUM(revenue) AS total_rev,
		SUM(order_quantity) AS tot_qtty, COUNT(order_date) AS num_of_transactions,
        MAX(revenue) AS highest_rev, MIN(revenue) AS lowest_rev
FROM sales
GROUP BY MONTH(order_date);

-- Get the total amount spent and total number of adverts done under each agency
SELECT agency, COUNT(agency) AS num_of_ad, SUM(spend) AS tot_adspend
FROM adverts
GROUP BY agency;