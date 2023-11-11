
DAY 34 (CASE STUDY)

/* PROBLEM STATEMENT: A Business is looking to Migrate its data from a the traditional single table 
microsoft Excel to an Encompassing Database system, and also need a little bit of insight into how its 
business have fared over the months since inception.*/
/* DATA MIGRATION SOLUTION: On Accessing the Parent Data, The Table was divided into 3 different tables 
which include; Customer, Transactions and Geography table.*/
/*INSIGHTS
What is the Age distribution of the business patronage from the customers? The Age should be grouped 
into teens, 20s, 30s and so on*/

SELECT(CASE
            WHEN Age BETWEEN 10 AND 19 THEN 'Teenages'
            WHEN Age BETWEEN 20 AND 29 THEN '20s' 
            WHEN Age BETWEEN 30 AND 39 THEN '30s' 
            WHEN Age BETWEEN 40 AND 49 THEN '40s' 
            WHEN Age BETWEEN 50 AND 59 THEN '50s' 
            WHEN Age BETWEEN 60 AND 69 THEN '60s'
            ELSE '70+'END) AS AgeGrp,
    COUNT(*) NoOfCust
FROM customer
GROUP BY AgeGrp
ORDER BY AgeGrp * 1, AgeGrp DESC

/*Which Customer Age of which business branch has the highest Average Credit Score?*/
SELECT c. Age,  AVG(CASE
                        WHEN g.Country LIKE '%France%%' THEN c.CreditScore ELSE NULL END) AS France,
                AVG(CASE
                        WHEN g.Country LIKE '%Germany%' THEN c.CreditScore ELSE NULL END) AS Germany,
                AVG(CASE
                        WHEN g.Country LIKE '%Spain%' THEN c.CreditScore ELSE NULL END) AS Spain,
        AVG(c.CreditScore) AS AvgCrdScore
FROM customer c
INNER JOIN transaction t ON c.CustomerId = t.CustomerId
INNER JOIN geography g ON t.GeoId = g.GeoId
GROUP BY c.Age
ORDER BY c.Age;