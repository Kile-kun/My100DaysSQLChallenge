
-- DAY 22 (SQL JOINS)

/*Given the CITY and COUNTRY tables, query the sum of the populations of
all cities where the CONTINENT is 'Asia'.
Note: CITY.CountryCode and COUNTRY.Code are matching key columns.*/
SELECT SUM(ci.POPULATION) AS TOTALPOPULATION
FROM CITY ci
JOIN COUNTRY co
ON ci.COUNTRYCODE = co.CODE
WHERE CO.CONTINENT = 'Asia';

/*You were provided with 11 tables of dataset pertaining to the startup ecosystem, 
Write a query that returns the top ten african startup in history.*/
SELECT ob.name, co.name AS country, ob.funding_total_usd
FROM objects ob
JOIN countries co ON ob.country_code
WHERE co.region = 'Africa'
ORDER BY ob.funding_total_usd DESC
LIMIT 10;