
-- DAY 19 (Practice)
/*UnitedHealth has a program called Advocate4Me, which allows members to call an advocate and receive 
support for their health care needs I whether that's behavioural, clinical, well-being, health care
financing, benefits, claims or pharmacy help.
Write a query to find how many UHG members made 3 or more calls. case_id column uniquely identifies each 
call made.*/
SELECT COUNT (policy_holder_id) as total_members
FROM (SELECT
policy_holder_id, COUNT(case_id)
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id)>=3) AS call_count;

/*From the description above, Write a query to find the percentage of calls that cannot be categorised. 
Round your answer to 1 decimal place.*/
SELECT ROUND(100.0 ✶ SUM(CASE WHEN _call_category IS NULL OR call_category THEN 1 ELSE 0 END)/
                        COUNT(case_id),1) AS uncat_percent
FROM callers;