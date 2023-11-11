-- DAY 46 (Window Functions And Common Table Expression Practice Day3)
-- CUSTOMER CHURN
/*CASE STUDY: A Company Looking to understand the impact of churning users on their revenue, 
provided you with a customer sales data to generate twom important insights for them*/

/*Write a query that will identify churning customers and the last day they purchased from the business. 
A churning user is a user that has not made a second purchase within 7 days of any other of their purchase*/

WITH returning_cte AS
                    (SELECT user_id, item, created_at, revenue,
                            LEAD(created_at) OVER(PARTITION BY user_id ORDER BY created_at) AS nxt_pd_trxn
                    FROM amazon_transactions)
SELECT DISTINCT user_id 
FROM returning_cte
WHERE DATEDIFF(nxt_pd_trxn, created_at) < 7;

-- Return the Percentage of Revenue Churning users contributes to the total company revenue (Potential Loss due to churning)
WITH churn_val_cte 
                AS 
                (SELECT user_id, COUNT(user_id) AS frq_ptrg, (created_at) AS first_trnx, 
                 SUM(revenue) AS tot_rev
                FROM amazon_transactions
                GROUP BY user_id
                ORDER BY user_id)
SELECT SUM(CASE WHEN frq_ptrg = 1 THEN tot_rev ELSE 0 END) AS churn_rev,
        SUM(CASE WHEN frq_ptrg > 1 THEN tot_rev ELSE 0 END) AS ret_cust_val,
        ROUND(100.00 * (SUM(CASE WHEN frq_ptrg = 1 THEN tot_rev ELSE 0 END)/
        SUM(tot_rev)),2) AS chn_cust_rev_value
FROM churn_val_cte;