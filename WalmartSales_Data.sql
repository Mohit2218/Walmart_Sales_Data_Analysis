CREATE DATABASE IF NOT EXISTS WalmartSales;

CREATE TABLE IF NOT EXISTS sales(
		invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
        branch VARCHAR(5) NOT NULL,
        city VARCHAR(30) NOT NULL,
        customer_type VARCHAR(30) NOT NULL,
        gender VARCHAR(10) NOT NULL,
        product_line VARCHAR(100) NOT NULL,
        unit_price DECIMAL(10,2) NOT NULL,
        quantity INT NOT NULL,
        VAT FLOAT(6,4) NOT NULL,
        total DECIMAL(12,4) NOT NULL,
        date DATETIME NOT NULL,
        time TIME NOT NULL,
        payment_method VARCHAR(15) NOT NULL,
        cogs DECIMAL(10,2) NOT NULL,
        gross_margin_percentage FLOAT(11,9),
        gross_income DECIMAL(12,4) NOT NULL,
        rating FLOAT(2,1)
);

-- ----------------------------------------------------------------Feature Engineering----------------------------------------------------------------

-- time_of_day

SELECT 
	time,
    (CASE
		WHEN TIME(time) BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN TIME(time) BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
    ) AS time_of_day
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(25); 

UPDATE sales
SET time_of_day=(
	CASE
		WHEN TIME(time) BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
        WHEN TIME(time) BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
        ELSE "Evening"
	END
);


-- day_name
SELECT 
	date,
    DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name=(
DAYNAME(date)
);


-- month_name
SELECT 
	date,
    MONTHNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(15);

UPDATE sales
SET month_name=(
MONTHNAME(DATE)
);

-- ----------------------------------------------------------GENERIC--------------------------------------------------------------------------
-- How many unique cities does the data have?
SELECT
	DISTINCT city
FROM sales;

SELECT 
	DISTINCT branch
FROM sales;

-- IN WHICH CITY IS EACH BRANCH?
SELECT 
	DISTINCT city,
    branch
FROM sales;

-- ------------------------------------------------------PRODUCT--------------------------------------------------------------

-- HOW MANY UNQIUE PRODUCT LINES DOES DATA HAVE?
SELECT
	COUNT(DISTINCT product_line)
FROM sales;


-- WHAT IS THE MOST COMMON PAYMENT METHOD?
SELECT 
	payment_method,
    COUNT(payment_method) AS cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- WHAT IS MOST SELLING PRODUCT LINE?
SELECT 
	product_line,
    COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- WHAT IS TOTAL REVENUE BY MONTH?
SELECT
	month_name AS month,
    SUM(total) AS total_sales
FROM sales
GROUP BY month_name
ORDER BY total_sales DESC;

-- WHAT MONTH HAD THE LARGEST COGS?
SELECT
	month_name AS month,
    SUM(cogs) AS COGS
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;

-- WHAT PRODUCT LINE HAD THE LARGEST REVENUE
SELECT
	product_line,
    SUM(total) AS product_revenue
FROM sales
GROUP BY product_line
ORDER BY product_revenue DESC;

-- WHICH CITY HAD THE LARGEST REVENUE
SELECT
	branch,
	city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city,branch
ORDER BY total_revenue DESC;

-- WHAT PRODUCT LINE HAD THE LARGEST VAT?
SELECT
	product_line,
    AVG(VAT) as vat
FROM sales
GROUP BY product_line
ORDER BY vat DESC;

-- WHICH BRANCH SOLD MORE PRODUCTS THAN AVG PRODUCT SOLD?
SELECT
	branch,
    SUM(quantity) as qnt
FROM sales
GROUP BY branch
HAVING SUM(quantity)>(SELECT AVG(quantity) FROM sales);

-- WHAT IS MOST COMMON PRODUCT LINE BY GENDER
SELECT
	product_line,
    gender,
    COUNT(product_line) AS cnt
FROM sales
GROUP BY gender,product_line
ORDER BY cnt DESC;

-- WHAT IS AVG RATING OF EACH PRODUCT LINE?
SELECT
	product_line,
    ROUND(AVG(rating),2) AS avg_rating
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- -------------------------------------------------------------------SALES--------------------------------------------------------------------------

-- NUMBER OF SALES MADE IN EACH TIME OF DAY PER WEEKDAY
SELECT 
	time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name="Monday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- WHICH OF THE CUSTOMER TYPE BRINGS THE MOST REVENUE
SELECT
	customer_type,
    SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- WHICH CITY HAS LARGEST TAX PERCENTAGE/VAT
SELECT
	city,
    AVG(VAT) AS vat
FROM sales
GROUP BY CITY
ORDER BY vat DESC;

-- WHICH CUSTOMER PAYS THE MOST IN VAT
SELECT
	customer_type,
    AVG(VAT) as tax_paid
FROM sales
GROUP BY customer_type
ORDER BY tax_paid DESC;

-- ------------------------------------------------------------------CUSTOMER--------------------------------------------------------------------------------

-- HOW MANY TYPES OF CUSTOMER DOES DATA HAVE
SELECT
	COUNT(DISTINCT(customer_type)) AS unique_customers
FROM sales;


-- HOW MANY UNQIUE PAYMENT METHODS DOES THE DATA HAVE
SELECT
	COUNT(DISTINCT(payment_method)) AS unique_payment_methods
FROM sales;

-- WHICH IS THE MOST COMMON CUSTOMER TYPE
SELECT
	customer_type,
    COUNT(customer_type) AS cnt
FROM sales
GROUP BY customer_type
ORDER BY cnt DESC;

-- WHICH CUSTOMER TYPE BUYS THE MOST
SELECT
	customer_type,
    COUNT(*) AS times_bought
FROM sales
GROUP BY customer_type
ORDER BY times_bought DESC;

-- WHAT IS THE GENDER OF MOST CUSTOMERS
SELECT
	gender,
    COUNT(*) AS gender_cnt
FROM sales
GROUP BY gender;

-- GENDER DISTRIBUTION PER BRANCH
SELECT
	gender,
    COUNT(*) AS gender_cnt
FROM sales
WHERE branch="B"
GROUP BY gender;

-- WHICH TIME OF THE DAY CUSTOMERS GIVE MOST RATINGS
SELECT
	time_of_day,
    ROUND(AVG(rating),2) as avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- WHICH TIME OF THE DAY DO CUSTOMERS GIVE MOST RATING PER BRANCH
SELECT
	time_of_day,
    ROUND(AVG(rating),2) as avg_rating
FROM sales
WHERE branch="A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- WHICH DAY OF THE WEEK HAS BEST AVG RATING
SELECT
	day_name,
    ROUND(AVG(rating),2) as avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- WHICH DAY OF THE WEEK HAS THE BEST AVERAGE RATING PER BRANCH
SELECT
	day_name,
    ROUND(AVG(rating),2) as avg_rating
FROM sales
WHERE branch="C"
GROUP BY day_name
ORDER BY avg_rating DESC;





