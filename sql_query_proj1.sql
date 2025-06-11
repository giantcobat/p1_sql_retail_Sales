-- Create Database
CREATE DATABASE sql_project_p1;

-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE table retail_sales 
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,
				sale_time TIME,	
				customer_id INT,
				gender VARCHAR(15),	
				age	INT,
				category VARCHAR(15),	
				quantiy	 INT,
				price_per_unit FLOAT,
				cogs FLOAT,
				total_sale FLOAT
			)

SELECT * FROM retail_sales
LIMIT 10;

SELECT 
	COUNT(*)
FROM retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id	IS NULL
	OR
    gender IS NULL
	OR
	age	IS NULL
	OR
    category IS NULL
	OR	
	quantiy IS NULL
	OR	
	price_per_unit IS NULL
	OR	
	cogs IS NULL
	OR	
	total_sale IS NULL;
    
SET SQL_SAFE_UPDATES = 0;
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	customer_id	IS NULL
	OR
    gender IS NULL
	OR
	age	IS NULL
	OR
    category IS NULL
	OR	
	quantiy IS NULL
	OR	
	price_per_unit IS NULL
	OR	
	cogs IS NULL
	OR	
	total_sale IS NULL;
    

-- Data Exploration
-- Number of Sales
SELECT COUNT(*) as total_sale FROM retail_sales;

-- Unique Customers
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales;

-- Number of Categories and Name of Categories
SELECT COUNT(DISTINCT category) as total_sale FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

-- ALL COLUMNS OF SALES MADE ON "2022-11-05"
SELECT * 
FROM retail_sales
WHERE sale_date = 2022-11-05;

-- Retrieve all transactions where category is 'clothing'and the quantity sold is more than 4 in the month of Nov-2022
SELECT
*
FROM retail_sales
WHERE
category = 'Clothing'
AND
DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
AND 
quantiy >= 2;

-- Calculate total sale for each category
SELECT 
category,
SUM(total_sale) as net_sale,
COUNT(*) as total_order
FROM retail_sales
group by 1;

-- Calculate the average age of customers who purchased items from the 'beauty' category
SELECT 
	ROUND(AVG(age), 2) as avg_age
From retail_sales
WHERE
category = 'beauty';

-- Find all transactions where total_sale is greater than 1000
SELECT * FROM retail_sales 
WHERE total_Sale > 1000;

-- Find the total number of transactions made by each gender in each category.
SELECT
	category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
group by
	category,
    gender
Order by 1;

-- Calculate average sale each month, find out best selling month in a year
SELECT
	year,
    month,
    avg_sale
FROM
(
SELECT 
YEAR(sale_date) AS year,
MONTH(sale_date) AS month,
ROUND(AVG(total_sale), 2) as avg_sale,
RANK() OVER( PARTITION BY YEAR(sale_date) ORDER BY ROUND(AVG(total_sale), 2) DESC) AS rnk
from retail_sales
group by 1, 2 
ORDER BY 1, 3 DESC
) AS t1
WHERE rnk = 1;

-- Find the top 6 customers based on the highest total sales
SELECT 
	customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Find the number of unique customers who purchased items from each category
SELECT 
	category,
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP By 1;

-- Create each shift and number of orders (Example morning <-12, Afternoon between 12 & 17, Evening > 17)
with hourly_sale
AS
(
SELECT *,
	CASE
		WHEN HOUR(sale_time) < 12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
	End AS shift
From retail_Sales
)
select 
	shift,
	COUNT(*) as total_orders
From hourly_sale
GROUP BY shift

-- End of Project