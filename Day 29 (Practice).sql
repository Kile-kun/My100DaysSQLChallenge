
-- DAY 29 (Practice)

/*Assume you're given two tables containing data about Facebook Pages and their respective likes 
(as in "Like a Facebook Page"). Write a query to return the IDs of the Facebook pages that have zero 
likes. The output should be sorted in ascending order based on the page IDs.*/
SELECT pa.page_id
FROM pages pa
LEFT JOIN page_likes pl ON pa.page_id = pl.page_id WHERE pl.page_id IS NULL;

/*Given the reviews table, write a query to retrieve the average star rating for each product, grouped by
 month. The output should display the month as a numerical value, product ID, and average star rating 
 rounded to two decimal places. Sort the output first by month and then by product ID.*/
SELECT EXTRACT (MONTH FROM submit_date) AS month,
        product_id, ROUND(AVG(stars),2) AS avg_revw
FROM reviews
GROUP BY EXTRACT(MONTH FROM submit_date), product_id 
ORDER BY month, product_id;

/*Assume you're given tables with information about TikTok user sign-ups and confirmations through email
and text. New users on TikTok sign up using their email addresses, and upon sign-up, each user receives 
a text message confirmation to activate their account. Write a query to display the user IDs of those 
who did not confirm their sign-up on the first day, but confirmed on the second day.*/
SELECT e.user_id
FROM emails e
INNER JOIN texts t
ON e.email_id = t.email_id
WHERE t.signup_action = 'Confirmed' AND
        (EXTRACT(DAY FROM t.action_date))–(EXTRACT(DAY FROM e.signup_date)) =1;