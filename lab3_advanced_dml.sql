CREATE TABLE employees (
    emp_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50) DEFAULT NULL,
    salary INTEGER DEFAULT 40000,
    hire_date DATE DEFAULT CURRENT_DATE,
    status VARCHAR(20) DEFAULT 'Active'
);

CREATE TABLE departments (
    dept_id SERIAL PRIMARY KEY,
    dept_name VARCHAR(50),
    budget INTEGER,
    manager_id INTEGER
);

CREATE TABLE projects (
    project_id SERIAL PRIMARY KEY,
    project_name VARCHAR(100),
    dept_id INTEGER,
    start_date DATE,
    end_date DATE,
    budget INTEGER
);

-- Part B: Advanced INSERT Operations

-- 2. Insert specifying only certain columns
INSERT INTO employees (emp_id, first_name, last_name, department)
VALUES (DEFAULT, 'John', 'Doe', 'IT');

-- 3. Insert with DEFAULT values
INSERT INTO employees (first_name, last_name, department)
VALUES ('Jane','Smith','HR');

-- 4. Insert multiple rows in single statement
INSERT INTO departments (dept_name, budget, manager_id)
VALUES 
 ('IT',120000,1),
 ('HR',80000,2),
 ('Sales',150000,3);

-- 5. Insert with expressions
INSERT INTO employees (first_name,last_name,department,salary,hire_date)
VALUES ('Alex','Brown','Finance',50000*1.1,CURRENT_DATE);

-- 6. Insert from SELECT
CREATE TEMP TABLE temp_employees AS
SELECT * FROM employees WHERE department='IT';

-- Part C: Complex UPDATE Operations

-- 7. Increase all employee salaries by 10%
UPDATE employees SET salary = salary*1.10;

-- 8. Update employee status with multiple conditions
UPDATE employees SET status='Senior'
WHERE salary>60000 AND hire_date<'2020-01-01';

-- 9. Update department using CASE
UPDATE employees
SET department=CASE 
    WHEN salary>80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND 80000 THEN 'Senior'
    ELSE 'Junior' END;

-- 10. UPDATE with DEFAULT
UPDATE employees SET department=DEFAULT WHERE status='Inactive';

-- 11. UPDATE department budget using subquery
UPDATE departments d
SET budget=(SELECT AVG(salary)*1.20 FROM employees e WHERE e.department=d.dept_name);

-- 12. UPDATE multiple columns
UPDATE employees SET salary=salary*1.15, status='Promoted' WHERE department='Sales';

-- Part D: Advanced DELETE Operations

-- 13. DELETE simple
DELETE FROM employees WHERE status='Terminated';

-- 14. DELETE complex
DELETE FROM employees WHERE salary<40000 AND hire_date>'2023-01-01' AND department IS NULL;

-- 15. DELETE with subquery
DELETE FROM departments 
WHERE dept_id NOT IN (SELECT DISTINCT dept_id FROM projects);

-- 16. DELETE with RETURNING
DELETE FROM projects WHERE end_date<'2023-01-01' RETURNING *;

-- Part E: Operations with NULL Values

-- 17. INSERT with NULL values
INSERT INTO employees (first_name,last_name,salary,department)
VALUES ('Null','Case',NULL,NULL);

-- 18. UPDATE NULL handling
UPDATE employees SET department='Unassigned' WHERE department IS NULL;

-- 19. DELETE with NULL conditions
DELETE FROM employees WHERE salary IS NULL OR department IS NULL;

-- Part F: RETURNING Clause Operations

-- 20. INSERT with RETURNING
INSERT INTO employees (first_name,last_name,department)
VALUES ('Chris','Evans','Marketing')
RETURNING emp_id, first_name||' '||last_name AS full_name;

-- 21. UPDATE with RETURNING
UPDATE employees SET salary=salary+5000 
WHERE department='IT'
RETURNING emp_id, salary-5000 AS old_salary, salary AS new_salary;

-- 22. DELETE with RETURNING
DELETE FROM employees WHERE hire_date<'2020-01-01' RETURNING *;

-- Part G: Advanced DML Patterns

-- 23. Conditional INSERT
INSERT INTO employees (first_name,last_name,department)
SELECT 'Liam','Neeson','Security'
WHERE NOT EXISTS (SELECT 1 FROM employees WHERE first_name='Liam' AND last_name='Neeson');

-- 24. UPDATE with JOIN logic using subqueries
UPDATE employees e
SET salary=salary*CASE WHEN (SELECT budget FROM departments d WHERE d.dept_name=e.department)>100000 THEN 1.10 ELSE 1.05 END;

-- 25. Bulk operations
INSERT INTO employees (first_name,last_name,department,salary)
VALUES
 ('Emp1','Test','IT',50000),
 ('Emp2','Test','IT',50000),
 ('Emp3','Test','IT',50000),
 ('Emp4','Test','IT',50000),
 ('Emp5','Test','IT',50000);
UPDATE employees SET salary=salary*1.10 WHERE last_name='Test';

-- 26. Data migration simulation
CREATE TABLE employee_archive (LIKE employees INCLUDING ALL);
INSERT INTO employee_archive SELECT * FROM employees WHERE status='Inactive';
DELETE FROM employees WHERE status='Inactive';

-- 27. Complex business logic
UPDATE projects p
SET end_date=end_date+INTERVAL '30 days'
WHERE budget>50000 AND (SELECT COUNT(*) FROM employees e WHERE e.department=(SELECT dept_name FROM departments d WHERE d.dept_id=p.dept_id))>3;
""")
