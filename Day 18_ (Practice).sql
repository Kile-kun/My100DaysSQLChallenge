
-- DAY 18 (Practice)

/*Write a query that outputs the name of each credit card and the difference in issued amount between the
month with the most cards issued, and the least cards issued. Order the results according to the biggest 
difference.*/
SELECT card_name, (MAX(issued_amount)-MIN(issued_amount)) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY difference DESC;

/*You have been asked to get a list of all the sign up IDs with transaction start dates in either April 
or May. Since a sign up ID can be used for multiple transactions only output the unique ID.
Your output should contain a list of non duplicated sign-up IDs.*/
SELECT signup_id, MIN(transaction_start_date) AS signup_date
FROM transactions
WHERE MONTHNAME(transaction_start_date) IN ('April', 'May')
GROUP BY signup_id;

/*You have been asked to find the number of employees hired between the months of January and July in the
 year 2022 inclusive.Your output should contain the number of employees hired in this given time frame.*/
SELECT COUNT(id) num_of_hires
FROM employees
WHERE joining_date BETWEEN '2022-01-01' AND '2022-07-31';