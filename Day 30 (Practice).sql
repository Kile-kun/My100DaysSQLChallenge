
-- DAY 30 (Practice)

/*PROBLEM STATEMENT: CVS Health wants to gain a clearer understanding of its pharmacy sales and the 
performance of various products.
Insight 1: Write a query to find the top 3 most profitable drugs sold, and how much profit they made. 
Assume that there are no ties in the profits. Display the result from the highest to the lowest total 
profit.*/
SELECT drug, (total_sales-cogs) AS profit
FROM pharmacy_sales
ORDER BY profit DESC
LIMIT 3;

/*Insight 2: Write a query to identify the manufacturers associated with the drugs that resulted in 
losses for CVS Health and calculate the total amount of losses incurred.
Output the manufacturer's name, the number of drugs associated with losses, and the total losses in 
absolute value. Display the results sorted in descending order with the highest losses displayed at the 
top.*/
SELECT manufacturer, COUNT(manufacturer), ABS(SUM(total_sales - cogs)) AS total_loss
FROM pharmacy_sales
WHERE (total_sales - cogs) < 0
GROUP BY manufacturer
ORDER BY total_loss DESC;

/*Insight 3: Write a query to calculate the total drug sales for each manufacturer. Round the answer to 
the nearest million and report your results in descending order of total sales. In case of any duplicates,
sort them alphabetically by the manufacturer name.
Since this data will be displayed on a dashboard viewed by business stakeholders, please format your 
results as follows: "$36 million".*/
SELECT manufacturer, CONCAT('$', ROUND(ROUND(SUM(total_sales),-6)/1000000,0), 'million') AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer ASC;
