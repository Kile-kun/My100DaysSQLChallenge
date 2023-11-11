
-- DAY 21 (UNION AND HAVING STATEMENT)

/*Write a query that returns movies with the highest and the lowest budget attache their review score too.*/
SELECT title, budget, review_score
FROM movies
ORDER BY budget DESC
UNION
SELECT title, budget, review_score
FROM movies
ORDER BY budget;

/* Assume you're given a table containing job postings from various companies on the LinkedIn platform. 
Write a query to retrieve companies that have posted multiple job listings.*/
SELECT company_id, COUNT(company_id) AS no_of_joblisting
FROM job_listings
GROUP BY company_id
HAVING COUNT(company_id) > 1)AS company_count;