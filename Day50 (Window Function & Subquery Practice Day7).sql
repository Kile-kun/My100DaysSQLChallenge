-- Day 50 (Window Function & Subquery Practice Day7)

-- CASE 1: Year On Year Product Launch Count
/*You are given a table of product launches by company by year. Write a query to count the net difference 
between the number of products companies launched in 2020 with the number of products companies launched 
in the previous year. Output the name of the companies and a net difference of net products released for 
2020 compared to the previous year.*/

WITH yoy_cte AS (SELECT year, company_name, (COUNT(product_name)) -
                         (LAG(COUNT(product_name)) 
                         OVER(PARTITION BY company_name ORDER BY year)) AS yoy_tpl
                FROM car_launches
                GROUP BY year, company_name)
SELECT company_name, yoy_tpl
FROM yoy_cte
WHERE year = 2020;


-- CASE 2: Top Fraud Claim
/*ABC Corp is a mid-sized insurer in the US and in the recent past their fraudulent claims have 
increased significantly for their personal auto insurance portfolio. They have developed a ML based 
predictive model to identify propensity of fraudulent claims. Now, they assign highly experienced claim 
adjusters for top 5 percentile of claims identified by the model. Your objective is to identify the
top 5 percentile of claims from each state. Your output should be policy number, state, claim cost, and fraud score.*/

WITH pctl_cte AS
                    (SELECT *, 
                        PERCENT_RANK() 
                        OVER(PARTITION BY state 
                        ORDER BY fraud_score DESC) AS claim_pctl 
                    FROM fraud_score)
SELECT policy_num, state, claim_cost, fraud_score
FROM pctl_cte
WHERE claim_pctl <= 0.05
ORDER BY state, fraud_score DESC;