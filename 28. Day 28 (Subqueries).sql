
-- DAY 28 (Subqueries)

-- Find all athletes who were older than 40 years when they won either Bronze or Silver medals.
SELECT * 
FROM (SELECT name, age, medal
        FROM olympics_athletes_events
        WHERE medal IN ('Bronze', 'Silver')) AS winners
WHERE age > 40
ORDER BY name;


/* How Many Customers are qualify for a raffle draw ($5000 total order worth or over 20 different 
transactions) */
SELECT COUNT(customer_name) AS eligible_customers 
FROM (SELECT c.customer_name,
        SUM(s.revenue) AS total_revenue,
        COUNT(s.customer_id) AS total_transaction
    FROM customers c
    INNER JOIN sales s
    ON c.customer_id = s.customer_id
    GROUP BY c.customer_name
    ORDER BY c.customer_name) AS cust
WHERE total_revenue > 5000 OR total_transaction > 20;

/* from the advert table write a SQL query to return details of when we spent more than average budget 
for adverts*/
SELECT *
FROM adverts
WHERE spend > (SELECT AVG(spend)
                FROM adverts);