-- Lab Work 5: Database Constraints (PostgreSQL)

-- ============================================================
-- PART 1: CHECK Constraints
-- ============================================================

-- Task 1.1: Basic CHECK Constraint
CREATE TABLE employees (
    employee_id INTEGER,
    first_name TEXT,
    last_name TEXT,
    age INTEGER CHECK (age BETWEEN 18 AND 65),
    salary NUMERIC CHECK (salary > 0)
);
INSERT INTO employees VALUES (1, 'John', 'Doe', 30, 50000);
INSERT INTO employees VALUES (2, 'Jane', 'Smith', 45, 70000);

-- Task 1.2: Named CHECK Constraint
CREATE TABLE products_catalog (
    product_id INTEGER,
    product_name TEXT,
    regular_price NUMERIC,
    discount_price NUMERIC,
    CONSTRAINT valid_discount CHECK (
        regular_price > 0 AND discount_price > 0 AND discount_price < regular_price
    )
);
INSERT INTO products_catalog VALUES (1, 'Laptop', 1000, 900);
INSERT INTO products_catalog VALUES (2, 'Mouse', 50, 40);

-- Task 1.3: Multiple Column CHECK
CREATE TABLE bookings (
    booking_id INTEGER,
    check_in_date DATE,
    check_out_date DATE,
    num_guests INTEGER CHECK (num_guests BETWEEN 1 AND 10),
    CHECK (check_out_date > check_in_date)
);
INSERT INTO bookings VALUES (1, '2025-06-01', '2025-06-05', 2);
INSERT INTO bookings VALUES (2, '2025-07-10', '2025-07-15', 4);

-- ============================================================
-- PART 2: NOT NULL Constraints
-- ============================================================

-- Task 2.1: NOT NULL Implementation
CREATE TABLE customers (
    customer_id INTEGER NOT NULL,
    email TEXT NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);
INSERT INTO customers VALUES (1, 'a@example.com', '123456', '2025-01-01');
INSERT INTO customers VALUES (2, 'b@example.com', NULL, '2025-02-01');

-- Task 2.2: Combining Constraints
CREATE TABLE inventory (
    item_id INTEGER NOT NULL,
    item_name TEXT NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity >= 0),
    unit_price NUMERIC NOT NULL CHECK (unit_price > 0),
    last_updated TIMESTAMP NOT NULL
);
INSERT INTO inventory VALUES (1, 'Phone', 10, 500, NOW());
INSERT INTO inventory VALUES (2, 'Tablet', 5, 800, NOW());

-- ============================================================
-- PART 3: UNIQUE Constraints
-- ============================================================

-- Task 3.1: Single Column UNIQUE
CREATE TABLE users (
    user_id INTEGER,
    username TEXT UNIQUE,
    email TEXT UNIQUE,
    created_at TIMESTAMP
);
INSERT INTO users VALUES (1, 'user1', 'u1@mail.com', NOW());
INSERT INTO users VALUES (2, 'user2', 'u2@mail.com', NOW());

-- Task 3.2: Multi-Column UNIQUE
CREATE TABLE course_enrollments (
    enrollment_id INTEGER,
    student_id INTEGER,
    course_code TEXT,
    semester TEXT,
    CONSTRAINT unique_enrollment UNIQUE (student_id, course_code, semester)
);
INSERT INTO course_enrollments VALUES (1, 101, 'CS101', 'Fall2025');
INSERT INTO course_enrollments VALUES (2, 101, 'CS102', 'Fall2025');

-- Task 3.3: Named UNIQUE Constraints
ALTER TABLE users
ADD CONSTRAINT unique_username UNIQUE (username),
ADD CONSTRAINT unique_email UNIQUE (email);

-- ============================================================
-- PART 4: PRIMARY KEY Constraints
-- ============================================================

-- Task 4.1: Single Column Primary Key
CREATE TABLE departments (
    dept_id INTEGER PRIMARY KEY,
    dept_name TEXT NOT NULL,
    location TEXT
);
INSERT INTO departments VALUES (1, 'IT', 'New York');
INSERT INTO departments VALUES (2, 'HR', 'Boston');
INSERT INTO departments VALUES (3, 'Sales', 'Chicago');

-- Task 4.2: Composite Primary Key
CREATE TABLE student_courses (
    student_id INTEGER,
    course_id INTEGER,
    enrollment_date DATE,
    grade TEXT,
    PRIMARY KEY (student_id, course_id)
);
INSERT INTO student_courses VALUES (1, 10, '2025-01-10', 'A');
INSERT INTO student_courses VALUES (1, 11, '2025-02-10', 'B');

-- Task 4.3: Comparison Exercise
-- UNIQUE allows NULLs; PRIMARY KEY does not.
-- One table = one PRIMARY KEY, but multiple UNIQUE possible.
-- Use composite PK when identifying a record needs multiple columns.

-- ============================================================
-- PART 5: FOREIGN KEY Constraints
-- ============================================================

-- Task 5.1: Basic Foreign Key
CREATE TABLE employees_dept (
    emp_id INTEGER PRIMARY KEY,
    emp_name TEXT NOT NULL,
    dept_id INTEGER REFERENCES departments(dept_id),
    hire_date DATE
);
INSERT INTO employees_dept VALUES (1, 'Mark', 1, '2025-01-10');

-- Task 5.2: Multiple Foreign Keys (Library System)
CREATE TABLE authors (
    author_id INTEGER PRIMARY KEY,
    author_name TEXT NOT NULL,
    country TEXT
);
CREATE TABLE publishers (
    publisher_id INTEGER PRIMARY KEY,
    publisher_name TEXT NOT NULL,
    city TEXT
);
CREATE TABLE books (
    book_id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author_id INTEGER REFERENCES authors(author_id),
    publisher_id INTEGER REFERENCES publishers(publisher_id),
    publication_year INTEGER,
    isbn TEXT UNIQUE
);
INSERT INTO authors VALUES (1, 'J.K. Rowling', 'UK');
INSERT INTO publishers VALUES (1, 'Bloomsbury', 'London');
INSERT INTO books VALUES (1, 'Harry Potter', 1, 1, 1997, '9780747532743');

-- Task 5.3: ON DELETE Options
CREATE TABLE categories (
    category_id INTEGER PRIMARY KEY,
    category_name TEXT NOT NULL
);
CREATE TABLE products_fk (
    product_id INTEGER PRIMARY KEY,
    product_name TEXT NOT NULL,
    category_id INTEGER REFERENCES categories(category_id) ON DELETE RESTRICT
);
CREATE TABLE orders (
    order_id INTEGER PRIMARY KEY,
    order_date DATE NOT NULL
);
CREATE TABLE order_items (
    item_id INTEGER PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES products_fk(product_id),
    quantity INTEGER CHECK (quantity > 0)
);

-- ============================================================
-- PART 6: Practical Application — E-commerce Database
-- ============================================================

-- Task 6.1: Complete E-commerce Schema
CREATE TABLE ecommerce_customers (
    customer_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT UNIQUE NOT NULL,
    phone TEXT,
    registration_date DATE NOT NULL
);
CREATE TABLE ecommerce_products (
    product_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC CHECK (price >= 0),
    stock_quantity INTEGER CHECK (stock_quantity >= 0)
);
CREATE TABLE ecommerce_orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES ecommerce_customers(customer_id) ON DELETE CASCADE,
    order_date DATE NOT NULL,
    total_amount NUMERIC,
    status TEXT CHECK (status IN ('pending','processing','shipped','delivered','cancelled'))
);
CREATE TABLE ecommerce_order_details (
    order_detail_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES ecommerce_orders(order_id) ON DELETE CASCADE,
    product_id INTEGER REFERENCES ecommerce_products(product_id),
    quantity INTEGER CHECK (quantity > 0),
    unit_price NUMERIC CHECK (unit_price > 0)
);

-- Sample Inserts
INSERT INTO ecommerce_customers (name, email, phone, registration_date) VALUES
('Alice', 'alice@mail.com', '111-222', '2025-01-10'),
('Bob', 'bob@mail.com', '333-444', '2025-02-15'),
('Charlie', 'charlie@mail.com', '555-666', '2025-03-20');

INSERT INTO ecommerce_products (name, description, price, stock_quantity) VALUES
('Laptop', 'Gaming Laptop', 1500, 5),
('Phone', 'Smartphone', 800, 10),
('Headphones', 'Wireless', 100, 50);

INSERT INTO ecommerce_orders (customer_id, order_date, total_amount, status) VALUES
(1, '2025-04-01', 1600, 'pending'),
(2, '2025-04-05', 900, 'processing');

INSERT INTO ecommerce_order_details (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1500),
(1, 3, 1, 100),
(2, 2, 1, 800);
