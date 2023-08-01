-- DAY 47 (Window Function and Common Table Expression Practice Day4)
-- StrataScratch Interview Question

/*Find the customer with the highest daily total order cost between 2019-02-01 to 2019-05-01. 
If customer had more than one order on a certain day, sum the order costs on daily basis. 
Output customer's first name, total cost of their items, and the date.*/

WITH top_cust_cte AS
                (SELECT c.first_name, o.order_date, SUM(o.total_order_cost) AS tot_order_cost,
                        RANK() OVER(PARTITION BY o.order_date ORDER BY SUM(o.total_order_cost) DESC, 							
                        o.order_date ASC) AS order_cost_ranking
                FROM customers c
                JOIN orders o
                ON c.id = o.cust_id
                WHERE o.order_date BETWEEN '2019-02-01' AND '2019-05-01'
                GROUP BY c.first_name, o.order_date)
SELECT first_name, order_date, tot_order_cost
FROM top_cust_cte
WHERE tot_order_cost = (SELECT MAX(tot_order_cost) FROM top_cust_cte);

/*Given a table of purchases by date, calculate the month-over-month percentage change in revenue. 
The output should include the year-month date (YYYY-MM) and percentage change, rounded to the 2nd decimal point, 
and sorted from the beginning of the year to the end of the year.*/

WITH mom_cte AS
            (SELECT DATE_FORMAT(STR_TO_DATE(created_at,'%Y-%m-%d'),'%Y-%m') AS order_year_month, 				
					SUM(value) AS total_value,
					LAG(SUM(value)) OVER(ORDER BY DATE_FORMAT(STR_TO_DATE(created_at,'%Y-%m-%d'),'%Y-%m') ASC) 					
							AS previous_day_value
            FROM sf_transactions
            GROUP BY DATE_FORMAT(STR_TO_DATE(created_at,'%Y-%m-%d'),'%Y-%m'))
SELECT order_year_month,
		ROUND((100.00*((total_value/previous_day_value)-1)),2) AS mom_change
FROM mom_cte;

/*Given the list of a companys employee and their details, find the list of employees
 that earn the second highest salary in the organization.*/

WITH emp_sal_rank_cte AS 
            (SELECT CONCAT(first_name, ' ', last_name) AS full_name, 
            SUM(salary) AS salary,
                     DENSE_RANK() OVER (ORDER BY SUM(salary) DESC) AS salary_ranking
            FROM employee
            GROUP BY CONCAT(first_name, ' ', last_name))
SELECT salary
FROM emp_sal_rank_cte
WHERE salary_ranking = 2;