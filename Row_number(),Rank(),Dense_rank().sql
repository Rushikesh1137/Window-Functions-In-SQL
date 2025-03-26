-- =======================================
-- Create the employees table
-- =======================================
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    department VARCHAR(50),
    salary DECIMAL(10, 2),
    hire_date DATE
);

-- =======================================
-- Insert sample data into the employees table
-- =======================================
INSERT INTO employees (emp_id, emp_name, department, salary, hire_date)
VALUES
(1, 'Alice', 'HR', 55000, '2018-01-15'),
(2, 'Bob', 'IT', 75000, '2017-05-23'),
(3, 'Charlie', 'Finance', 82000, '2019-03-12'),
(4, 'Diana', 'IT', 60000, '2020-07-19'),
(5, 'Eve', 'HR', 52000, '2021-11-05'),
(6, 'Frank', 'Finance', 72000, '2020-08-10'),
(7, 'Grace', 'HR', 61000, '2016-12-20'),
(8, 'Hank', 'IT', 69000, '2019-01-11'),
(9, 'Ivy', 'Finance', 73000, '2018-09-30'),
(10, 'Jack', 'HR', 54000, '2017-10-15'),
(11, 'Kate', 'IT', 78000, '2016-06-01'),
(12, 'Leo', 'HR', 59000, '2019-02-21'),
(13, 'Mia', 'Finance', 76000, '2019-04-10'),
(14, 'Nick', 'IT', 65000, '2018-12-05'),
(15, 'Olivia', 'HR', 53000, '2020-09-29'),
(16, 'Paul', 'Finance', 70000, '2021-03-22'),
(17, 'Quincy', 'IT', 72000, '2020-01-07'),
(18, 'Rita', 'HR', 60000, '2020-05-15'),
(19, 'Steve', 'Finance', 78000, '2019-08-18'),
(20, 'Tom', 'IT', 81000, '2018-07-23'),
(21, 'Uma', 'HR', 58000, '2020-02-17'),
(22, 'Victor', 'Finance', 75000, '2021-05-10'),
(23, 'Wendy', 'IT', 70000, '2020-10-05'),
(24, 'Xander', 'HR', 62000, '2017-11-22'),
(25, 'Yara', 'Finance', 82000, '2021-06-30');




--BASIC QUESTIONS

-- =======================================
-- Query 1: Find the row number of each employee ordered by salary
-- =======================================
SELECT emp_id, emp_name, salary,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num_by_salary
FROM employees;

-- =======================================
-- Query 2: Rank employees based on their salaries
-- =======================================
SELECT emp_id, emp_name, salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank
FROM employees;

-- =======================================
-- Query 3: Dense rank employees within each department based on salary
-- =======================================
SELECT emp_id, emp_name, department, salary,
       DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank_by_dept
FROM employees;

-- =======================================
-- Query 4: Rank employees by hire date
-- =======================================
SELECT emp_id, emp_name, hire_date,
       RANK() OVER (ORDER BY hire_date ASC) AS hire_date_rank
FROM employees;

-- =======================================
-- Query 5: Find the row number of each employee within their department based on hire date
-- =======================================
SELECT emp_id, emp_name, department, hire_date,
       ROW_NUMBER() OVER (PARTITION BY department ORDER BY hire_date) AS row_num_by_hire_date
FROM employees;




--Adavance Questions

-- =======================================
-- Query 1: Show the employee name and salary of the highest-paid employee in each department
-- Use RANK() and filter for WHERE rank = 1.
-- =======================================
SELECT emp_id, emp_name, department, salary
FROM (
    SELECT emp_id, emp_name, department, salary,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_by_salary
    FROM employees
) AS ranked_employees
WHERE rank_by_salary = 1;

-- =======================================
-- Query 2: Calculate the rank difference between employees with the same salary across departments
-- Combine RANK() with a self-join.
-- =======================================
SELECT e1.emp_id AS emp1_id, e1.emp_name AS emp1_name, e1.salary AS emp1_salary,
       e2.emp_id AS emp2_id, e2.emp_name AS emp2_name, e2.salary AS emp2_salary,
       ABS(e1.rank_by_salary - e2.rank_by_salary) AS rank_difference
FROM (
    SELECT emp_id, emp_name, salary, 
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_by_salary
    FROM employees
) AS e1
JOIN (
    SELECT emp_id, emp_name, salary, 
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_by_salary
    FROM employees
) AS e2
ON e1.salary = e2.salary AND e1.emp_id != e2.emp_id
ORDER BY rank_difference;

-- =======================================
-- Query 3: Get the 2nd highest salary in each department, showing the employee name
-- Use RANK() and filter for WHERE rank = 2.
-- =======================================
SELECT emp_id, emp_name, department, salary
FROM (
    SELECT emp_id, emp_name, department, salary,
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_by_salary
    FROM employees
) AS ranked_employees
WHERE rank_by_salary = 2;

-- =======================================
-- Query 4: Find the average salary of the top 3 highest-paid employees in each department
-- Use ROW_NUMBER() with a PARTITION BY department.
-- =======================================
SELECT department, AVG(salary) AS avg_salary_top_3
FROM (
    SELECT emp_id, department, salary,
           ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) AS row_num
    FROM employees
) AS ranked_employees
WHERE row_num <= 3
GROUP BY department;

-- =======================================
-- Query 5: Assign a dense rank to employees based on their hire date, resetting at each department change
-- Combine DENSE_RANK() with PARTITION BY department ORDER BY hire_date.
-- =======================================
SELECT emp_id, emp_name, department, hire_date,
       DENSE_RANK() OVER (PARTITION BY department ORDER BY hire_date) AS hire_date_rank
FROM employees
ORDER BY department, hire_date;

