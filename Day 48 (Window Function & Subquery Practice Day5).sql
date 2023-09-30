-- Day 48 (Window Function & Subquery Practice Day5)

-- CASE 1: Uber Third Ride Order 
/*Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user. 
Output the user id, spend and transaction date.*/

WITH trx_rnk_cte AS 
                (SELECT user_id, spend, transaction_date,
                        ROW_NUMBER() OVER(PARTITION BY user_id 
                                  ORDER BY transaction_date ASC) AS trx_rnk
                  FROM transactions)
SELECT user_id, spend, transaction_date
FROM trx_rnk_cte
WHERE trx_rnk = 3;

-- CASE 2: Snapchat Interaction Insight
/*Assume you're given tables with information on Snapchat users, including their ages and time spent sending and opening snaps.
Write a query to obtain a breakdown of the time spent sending vs. opening snaps and chatting as a percentage of total time 
spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.*/

WITH act_cte AS
        (SELECT ab.age_bucket, 
                SUM(CASE WHEN ac.activity_type = 'send' THEN time_spent ELSE 0 END) AS tss,
                SUM(CASE WHEN ac.activity_type = 'open' THEN time_spent ELSE 0 END)AS tso,
                SUM(CASE WHEN ac.activity_type = 'chat' THEN time_spent ELSE 0 END)AS tsc
        FROM activities ac
        JOIN age_breakdown ab
        ON ab.user_id = ac.user_id
        GROUP BY ab.age_bucket)
SELECT age_bucket, 
      ROUND((100.00 * (tss/(tss +tso+tsc))), 2)AS send_perc, 
      ROUND((100.00 * (tso/(tss +tso+tsc))), 2) AS open_perc,
      ROUND((100.00 * (tsc/(tss +tso+tsc))), 2) AS chat_perc
FROM act_cte;

-- CASE 3: Tridaily Rolling Average Tweets
/*Given a table of tweet data over a specified time period, calculate the 3-day rolling average of tweets for each user. 
Output the user ID, tweet date, and rolling averages rounded to 2 decimal places.*/

WITH roln_avg_cte AS 
                (SELECT user_id, tweet_date,
                        AVG(tweet_count) OVER(PARTITION BY user_id 
                                        ORDER BY tweet_date
                                ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
                              AS roln_avg_tweets
                FROM tweets)
SELECT user_id, tweet_date, 
      ROUND(roln_avg_tweets,2) AS tridaily_roln_avg
FROM roln_avg_cte;