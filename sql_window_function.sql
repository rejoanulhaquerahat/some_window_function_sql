
CREATE TABLE employees (
emp_id INTEGER,
emp_name CHARACTER VARYING(50),
dept_name CHARACTER VARYING(50),
salary INTEGER
);

INSERT INTO employees (emp_id, emp_name, dept_name, salary) VALUES
(101, 'Mohan', 'Admin', 4000),
(102, 'Rajkumar', 'HR', 3000),
(103, 'Akbar', 'IT', 4000),
(104, 'Dorvin', 'Finance', 6500),
(105, 'Rohit', 'HR', 3000),
(106, 'Rajesh', 'Finance', 5000),
(107, 'Preet', 'HR', 7000);

INSERT INTO employees (emp_id, emp_name, dept_name, salary) VALUES
(108, 'Sneha', 'Admin', 4500),
(109, 'Vikram', 'IT', 4800),
(110, 'Priya', 'Finance', 6200),
(111, 'Arjun', 'HR', 3200),
(112, 'Kiran', 'IT', 4600),
(113, 'Neha', 'Admin', 4100),
(114, 'Suresh', 'Finance', 5800),
(115, 'Anita', 'HR', 3400),
(116, 'Ravi', 'IT', 5000),
(117, 'Meera', 'Admin', 4300),
(118, 'Hari', 'Finance', 5900),
(119, 'Sunil', 'HR', 3600),
(120, 'Lakshmi', 'IT', 4700),
(121, 'Deepak', 'Admin', 4200),
(122, 'Shalini', 'Finance', 6300),
(123, 'Vijay', 'HR', 3800),
(124, 'Pooja', 'IT', 4900);


SELECT *

FROM employees;



-- FIND  MAX salary in each dept

SELECT dept_name,MAX(salary) as max_salary from employees
group by dept_name;



-- we get error,,in above query we don't find emp_id id and another column



SELECT dept_name,dept_id,MAX(salary) as max_salary from employees
group by dept_name; -- ERROR!!!





-- 	In this situtaion we use window function/ subquery/with function

SELECT e.*,
max(salary) over() as max_salary

FROM employees as e; -- general max salary ar column create korche sob row ar jonnei

-- FIND max salary in each dept using partiton by

SELECT e.*,

MAX(salary) OVER(partition by dept_name) as max_salary

FROM employees as e;



-- row_number



SELECT e.*,

row_number() over() as rn

FROM employees e;


-- salary অনুযায়ী সাজিয়ে নম্বর দেবে

SELECT e.*,
ROW_NUMBER() OVER(ORDER BY salary DESC) AS rn
FROM employees e;



SELECT *
FROM(

 SELECT e.*,
    ROW_NUMBER() OVER(ORDER BY salary DESC) AS rn
    FROM employees e

) as t

where t.rn<=3;



--



SELECT e.*,

row_number() over(partition by dept_name) as rn

FROM employees e;


-- Fetch thre first 2 employees from each department to join the company



SELECT *
FROM(
SELECT e.*,

row_number() over(partition by dept_name ORDER BY emp_id) as rn

FROM employees e) AS t

WHERE rn<=2;


-- Fetch the top 3 employees in each department earning the max salary

SELECT *

FROM(

SELECT e.*,

	RANK() OVER (partition by dept_name order by salary desc) as rank
	
	FROM employees as e) as x
	
WHERE rank<=3;
	


-- DENSE_RANK that  very similer to dense_rank,not skiping when comes duplicate value



SELECT e.*,

	
	RANK() OVER (partition by dept_name order by salary desc) as rank,
	
	DENSE_RANK() OVER (partition by dept_name order by salary desc) as dense_rank,

	ROW_NUMBER() OVER(partition by dept_name order by salary desc) as rn
	
	FROM employees as e;


-- LAG function



SELECT e.*,
 
LAG(salary) OVER(partition by dept_name order by emp_id) as prev_emp_salary


FROM employees as e;



-- 

SELECT e.*,
 
LAG(salary,2,0) OVER(partition by dept_name order by emp_id) as prev_emp_salary


FROM employees as e;



-- LEAD



SELECT e.*,
 
LEAD(salary) OVER(partition by dept_name order by emp_id) as next_emp_salary


FROM employees as e;




-- -- Fetch a query to display if the salary of an employee is higher ,lower or eual to the previous employee

SELECT e.*,

LAG(salary) OVER(partition by dept_name order by emp_id) as prev_emp_salary,

	CASE
		
		WHEN e.salary>LAG(salary) OVER(partition by dept_name order by emp_id) THEN 'Higher than previous employee'
		
		WHEN e.salary<LAG(salary) OVER(partition by dept_name order by emp_id) THEN 'Lower than previous employee'
		
		WHEN e.salary=LAG(salary) OVER(partition by dept_name order by emp_id) THEN 'Same as the  previous employee'


        END sal_range

FROM employees as e;

















