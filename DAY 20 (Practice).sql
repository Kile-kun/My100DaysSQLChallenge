
-- DAY 20 (Practice)

/*You're trying to find the mean number of items per order on Alibaba, rounded to 1 decimal place using 
tables which includes information on the count of items in each order (item_count table) and the 
corresponding number of orders for each item count (order_occurrences table).*/
SELECT ROUND(
SUM(ROUND(item_count,1)*order_occurrences)/
SUM(order_occurrences),1)AS mean
FROM items_per_order;

/* Assume you're given a table containing job postings from various companies on the LinkedIn platform. 
Write a query to retrieve the count of companies that have posted duplicate job listings.*/ 
SELECT COUNT(company_id) AS no_of_company
FROM (
SELECT company_id, COUNT(company_id) AS no_of_joblisting
FROM job_listings
GROUP BY company_id
HAVING COUNT(company_id) > 1)AS company_count;

/* For each video game player, find the latest date when they logged in.*/ 
SELECT player_id, MAX(login_date) AS latest_login
FROM players_logins
GROUP BY player_id;