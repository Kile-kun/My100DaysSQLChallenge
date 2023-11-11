
-- DAY 31 (JOIN PRACTICE)

/* Given the facebook_reactions and facebook_posts table, Find all posts which were reacted to with a 
heart. For such posts output all columns from facebook_posts table.*/
SELECT DISTINCT fp.*
FROM facebook_reactions fr RIGHT JOIN facebook_posts fp ON fp.post_id = fr.post_id 
WHERE fr.reaction = 'heart';

/*Meta/Facebook has developed a new programing language called Hack.To measure the popularity of Hack 
they ran a survey with their employees. The survey included data on previous programing familiarity as 
well as the number of years of experience, age, gender and most importantly satisfaction with Hack. 
Due to an error location data was not collected, but your supervisor demands a report showing average
popularity of Hack by office location. Luckily the user IDs of employees completing the surveys were 
stored. Based on the above, find the average popularity of the Hack per office location.
Output the location along with the average popularity.*/
SELECT e.location, AVG(h.popularity) AS avg_pop
FROM facebook_employees e
JOIN facebook_hack_survey h
ON e.id = h.employee_id
GROUP BY e.location;

/*Write a query that calculates the difference between the highest salaries found in the marketing and 
engineering departments. Output just the absolute difference in salaries.*/
SELECT ABS (MAX(CASE WHEN d.department = 'marketing' THEN e.salary ELSE 0 END) -
            MAX(CASE WHEN d.department = 'engineering' THEN e.salary ELSE 0 END)) AS salary_diff
FROM db_employee e
JOIN db_dept d
ON e.department_id = d.id;