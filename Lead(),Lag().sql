CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_name VARCHAR(50),
    sale_date DATE,
    amount DECIMAL(10, 2),
    store_location VARCHAR(50)
);

INSERT INTO sales (sale_id, product_name, sale_date, amount, store_location)
VALUES
(1, 'Laptop', '2023-01-15', 1500.00, 'New York'),
(2, 'Headphones', '2023-02-03', 200.00, 'Chicago'),
(3, 'Laptop', '2023-03-10', 1600.00, 'San Francisco'),
(4, 'Phone', '2023-02-21', 800.00, 'New York'),
(5, 'Tablet', '2023-05-15', 600.00, 'Chicago'),
(6, 'Laptop', '2023-04-12', 1450.00, 'Chicago'),
(7, 'Phone', '2023-01-20', 850.00, 'San Francisco'),
(8, 'Headphones', '2023-03-18', 220.00, 'New York'),
(9, 'Tablet', '2023-04-25', 620.00, 'San Francisco'),
(10, 'Laptop', '2023-06-10', 1550.00, 'New York'),
(11, 'Phone', '2023-07-02', 790.00, 'Chicago'),
(12, 'Tablet', '2023-07-20', 640.00, 'New York'),
(13, 'Headphones', '2023-05-30', 210.00, 'San Francisco'),
(14, 'Laptop', '2023-08-15', 1620.00, 'Chicago'),
(15, 'Phone', '2023-09-01', 800.00, 'San Francisco'),
(16, 'Tablet', '2023-08-23', 650.00, 'New York'),
(17, 'Headphones', '2023-10-05', 230.00, 'Chicago'),
(18, 'Laptop', '2023-11-12', 1580.00, 'New York'),
(19, 'Phone', '2023-12-10', 815.00, 'Chicago'),
(20, 'Tablet', '2023-12-28', 680.00, 'San Francisco'),
(21, 'Laptop', '2023-11-22', 1650.00, 'San Francisco'),
(22, 'Headphones', '2023-11-30', 240.00, 'New York'),
(23, 'Phone', '2023-12-15', 820.00, 'New York'),
(24, 'Tablet', '2023-12-05', 670.00, 'Chicago'),
(25, 'Laptop', '2023-12-28', 1700.00, 'Chicago');



-- =======================================
-- Basic to Medium Problems
-- =======================================

-- 1. Calculate the difference in sales amount between consecutive sales
-- Use LAG(amount, 1) OVER (ORDER BY sale_date)
SELECT sale_id, product_name, sale_date, amount,
       amount - LAG(amount, 1) OVER (ORDER BY sale_date) AS sales_diff
FROM sales
ORDER BY sale_date;

-- 2. Find the sale amount for the next product sale
-- Use LEAD(amount, 1) OVER (ORDER BY sale_date)
SELECT sale_id, product_name, sale_date, amount,
       LEAD(amount, 1) OVER (ORDER BY sale_date) AS next_sale_amount
FROM sales
ORDER BY sale_date;

-- 3. For each product, calculate the difference between the current and previous sale amount
-- Use LAG(amount) OVER (PARTITION BY product_name ORDER BY sale_date)
SELECT sale_id, product_name, sale_date, amount,
       amount - LAG(amount) OVER (PARTITION BY product_name ORDER BY sale_date) AS sales_diff_per_product
FROM sales
ORDER BY product_name, sale_date;

-- 4. Show the next product sold for each store location
-- Use LEAD(product_name) OVER (PARTITION BY store_location ORDER BY sale_date)
SELECT sale_id, product_name, sale_date, store_location,
       LEAD(product_name) OVER (PARTITION BY store_location ORDER BY sale_date) AS next_product_sold
FROM sales
ORDER BY store_location, sale_date;

-- 5. Find the previous sale amount for each store location
-- Use LAG(amount) OVER (PARTITION BY store_location ORDER BY sale_date)
SELECT sale_id, product_name, sale_date, store_location, amount,
       LAG(amount) OVER (PARTITION BY store_location ORDER BY sale_date) AS previous_sale_amount
FROM sales
ORDER BY store_location, sale_date;

-- =======================================
-- Advanced Problems
-- =======================================

-- 6. Calculate the rolling difference between sales for each product
-- Use both LEAD and LAG for comparison
SELECT sale_id, product_name, sale_date, amount,
       LEAD(amount, 1) OVER (PARTITION BY product_name ORDER BY sale_date) - amount AS rolling_diff_lead,
       amount - LAG(amount, 1) OVER (PARTITION BY product_name ORDER BY sale_date) AS rolling_diff_lag
FROM sales
ORDER BY product_name, sale_date;

-- 7. Identify sales where the previous sale amount was higher than the current sale
-- Use LAG() and a conditional filter
SELECT sale_id, product_name, sale_date, amount,
       LAG(amount) OVER (PARTITION BY product_name ORDER BY sale_date) AS previous_sale_amount
FROM sales
WHERE LAG(amount) OVER (PARTITION BY product_name ORDER BY sale_date) > amount
ORDER BY product_name, sale_date;

-- 8. Show total sales for each month, with the amount sold in the previous month
-- Use SUM(amount) OVER (PARTITION BY MONTH(sale_date)) combined with LAG
SELECT EXTRACT(MONTH FROM sale_date) AS month,
       SUM(amount) OVER (PARTITION BY EXTRACT(MONTH FROM sale_date)) AS total_sales,
       LAG(SUM(amount) OVER (PARTITION BY EXTRACT(MONTH FROM sale_date)), 1) 
       OVER (PARTITION BY EXTRACT(MONTH FROM sale_date)) AS previous_month_sales
FROM sales
GROUP BY EXTRACT(MONTH FROM sale_date)
ORDER BY month;

-- 9. Determine the percentage increase or decrease in sales compared to the previous sale
-- Use (amount - LAG(amount) OVER (ORDER BY sale_date)) / LAG(amount)
SELECT sale_id, product_name, sale_date, amount,
       (amount - LAG(amount) OVER (ORDER BY sale_date)) / LAG(amount) * 100 AS percentage_change
FROM sales
ORDER BY sale_date;

-- 10. List all sales where the amount is greater than the average sales amount for that product
-- Combine window functions with a subquery to find the average
SELECT sale_id, product_name, sale_date, amount
FROM sales
WHERE amount > (
    SELECT AVG(amount) FROM sales AS avg_sales
    WHERE avg_sales.product_name = sales.product_name
)
ORDER BY product_name, sale_date;
