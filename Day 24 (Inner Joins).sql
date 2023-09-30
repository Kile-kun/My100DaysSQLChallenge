
-- DAY 24 (INNER JOIN)
/*Given a Transaction and Customer Table, Write a Query to return the total number of Product Purchased 
by each customer.*/
SELECT t.NumOfProducts, COUNT(t.NumOfProducts) AS NoOfCustomers
FROM transaction t
INNER JOIN customer c ON t.CustomerId = c.CustomerId
GROUP BY NumOfProducts
ORDER BY NoOfCustomers;

/*A retail store which has outlets across france, germany and spain is trying to Ascertain the 
performance of each country. Write a query that return total sales recorded for each region for year 
2022*/
SELECT g.Country, SUM(t.NumOfProducts) AS TotProdSales
FROM geography g
INNER JOIN transaction t
ON g.GeoId = t.GeoId
WHERE YEAR(t.Date) = 2022
GROUP BY g.Country
ORDER BY g.Country;