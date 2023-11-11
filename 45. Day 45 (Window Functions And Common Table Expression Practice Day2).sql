-- DAY 45 (Window Functions And Common Table Expression Practice Day2)

/*PROBLEM 1: Identify projects that are at risk for going overbudget. A project is considered to be overbudget
 if the cost of all employees assigned to the project is greater than the budget of the project.
You'll need to prorate the cost of the employees to the duration of the project. For example, 
if the budget for a project that takes half a year to complete is $10K, then the total half-year salary of all 
employees assigned to the project should not exceed $10K. Salary is defined on a yearly basis, 
so be careful how to calculate salaries for the projects that last less or more than one year.
Output a list of projects that are overbudget with their project name, project budget, 
and prorated total employee expense (rounded to the next dollar amount).*/

WITH project_budget_cte  AS
            (SELECT  lp.title, lp.budget, 
                    DATEDIFF(lp.end_date,lp.start_date) AS project_days,
                    CEIL((DATEDIFF(lp.end_date,lp.start_date))*(SUM(le.salary))/365) AS total_emp_salary
            FROM linkedin_projects lp
            JOIN linkedin_emp_projects lep
                ON lp.id = lep.project_id
            JOIN linkedin_employees le
                ON lep.emp_id = le.id
            GROUP BY lp.title)
SELECT title, budget, total_emp_salary
FROM project_budget_cte
WHERE budget<total_emp_salary
ORDER BY title;

-- PROBLEM 2: Given SAT Output ids of students with a median score from the writing SAT.

WITH cte_1 AS
            (SELECT student_id, sat_writing,
                    RANK() OVER(ORDER BY sat_writing) AS sat_rank
            FROM sat_scores),
cte_2 AS
            (SELECT FLOOR((COUNT(*)/2)) AS median
            FROM cte_1)
SELECT cte_1.student_id
FROM cte_1
JOIN cte_2
ON cte_1.sat_rank = cte_2.median;