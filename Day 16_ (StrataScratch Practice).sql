
-- DAY 16 (StrataScratch Practice)

/*Find all Lyft drivers who earn either equal to or less than 30k USD or equal to or more than 70k USD.
Output all details related to retrieved records.*/
SELECT *
FROM lyft drivers
WHERE yearly_salary <= 30000 OR
yearly_salary >= 70000 ;

/*Find the number of rows for each review score earned by 'Hotel Arena'. Output the hotel name (which 
should be 'Hotel Arena'), review score along with the corresponding number of rows with that score for 
the specified hotel.*/
SELECT hotel_name, reviewer_score, count(reviewer_score) AS num_of_reviewer
FROM hotel_reviews
WHERE hotel_name LIKE "%Hotel Arena"
GROUP BY reviewer_score
ORDER BY reviewer_score DESC;

-- Find employees who started in June and have even-numbered employee IDs. 
SELECT *
FROM worker
WHERE MONTHNAME(joining_date) LIKE "%June%" AND 2 MOD (worker_id)= 0;