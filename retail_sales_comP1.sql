--SQL Retail Sales Analysis - P1
CREATE DATABASE sql_project_p2;

--Create table
CREATE TABLE retail_sales(
     transactions_id INT PRIMARY KEY,
	 sale_date DATE,
	 sale_time TIME,
	 customer_id INT,
	 gender VARCHAR(15),
	 age INT,
	 category VARCHAR(15),
	 quantity INT,
	 price_per_unit FLOAT,
	 cogs FLOAT,
	 total_sale FLOAT
);

SELECT * FROM retail_sales
LIMIT 10

SELECT 
  COUNT(*)
FROM retail_sales

--data cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales 
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_sales
WHERE 
transactions_id IS NULL
OR 
sale_time IS NULL
OR
sale_date IS NULL
OR 
gender IS NULL
OR 
category IS NULL
OR 
quantity IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL;

DELETE FROM retail_sales
WHERE sale_time IS NULL
OR
transactions_id IS NULL
OR 
sale_date IS NULL
OR 
gender IS NULL
OR 
category IS NULL
OR 
quantity IS NULL
OR 
cogs IS NULL
OR 
total_sale IS NULL;


SELECT 
  COUNT(*)
FROM retail_sales

--Data Exploration

--How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

--How many unique customers we have?
SELECT COUNT (DISTINCT customer_id)FROM retail_sales

--How many unique category we have?
SELECT DISTINCT category FROM retail_sales

--DATA ANALYSIS AND BUSINESS KEY PROBLEMS AND ANSWERS
--------------------------------------------------------------------------------

--Ques1)Write SQL query to retrive all coloumn for sales made on '2022-11-05'

SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';

--Ques2)Write a SQL query to retrive all transactions where the category is clothing and the quantity sold is more than 10 in the month of Nov-2022

SELECT * FROM retail_sales 
WHERE category = 'Clothing'
AND quantity >= 4
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';

--Ques3) Write a SQL query to calculate the total sales for each category

SELECT category,
SUM(total_sale) as net_sale,
COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

--Ques4)Write a SQL query to find the average age of the customer who has purchased items from the 'beauty' category

SELECT AVG(age) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

--Ques5)Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000

(IMP)
--Ques6)Write a SQL query to find the total number of transactions made by each gender in each category

SELECT category,
       gender,
       COUNT(*) as total_trans
	   FROM retail_sales
	   GROUsssP BY category, gender
       
(MOST IMP(asked in interviews))
--Ques7) Write a SQL query to calculate the average sale for each month. find out best selling month in each year

SELECT
year,
month,
avg_sale
FROM
(
SELECT
EXTRACT(YEAR FROM sale_date) as year,
EXTRACT(MONTH FROM sale_date) as month,
AVG(total_sale) as avg_sale,
RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date)ORDER BY AVG(total_sale)DESC)
FROM retail_sales
GROUP BY 1,2
) as t1
WHERE rank = 1

--Ques8) Write a SQL query to find top 5 customers based on the highest total sales

SELECT 
customer_id,
SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Ques9) Write a SQL query to find the number of unique customers who purchased items from each category

SELECT category, COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY 1

--Ques10) Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening > 17)

WITH hourly_sale
AS 
(
SELECT *, 
case 
WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
WHEN EXTRACT (HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END as shift 
FROM retail_sales
)
SELECT 
shift, count(*) as total_orders
FROM hourly_sale
GROUP BY shift

--END
