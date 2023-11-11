USE raji;
SELECT * FROM employees;
-- ROW NUMBER
SELECT CONCAT(first_name, ' ', last_name) AS full_name,
		job_id,
        salary,
        ROW_NUMBER() OVER(ORDER BY salary DESC, CONCAT(first_name, ' ', last_name) ASC) AS salary_rank
FROM employees;

-- RANK
SELECT CONCAT(first_name, ' ', last_name) AS full_name,
		job_id,
        salary,
        RANK() OVER(ORDER BY salary DESC) AS salary_rank
FROM employees;

-- DENSE RANK
SELECT CONCAT(first_name, ' ', last_name) AS full_name,
		job_id,
        salary,
        DENSE_RANK() OVER(ORDER BY salary DESC) AS salary_rank
FROM employees;

-- N-TILE
SELECT CONCAT(first_name, ' ', last_name) AS full_name,
		job_id,
        salary,
        ROW_NUMBER() OVER(ORDER BY salary DESC) AS salary_rank
FROM employees;
