-- First step is to create database
Create Database Sales_Analysis;

-- Create Table
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
select * from retail_sales;

-- Count Number of Rows
select Count(*) from retail_sales;

-- Count Number of customers
select count(distinct customer_id) from retail_sales;

-- Unique Category of Products
Select distinct category from retail_sales;

-- Data Cleaning

-- Check Null Values
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Delete Null Values
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
    
-- Data Exploration

-- how many sales we have?
select count(*) as total_sales from retail_sales;
    
 -- how many unique customers we have?
 select count(distinct customer_id) as total_customers from retail_sales;
 
 -- how many category we have?
  select distinct category as total_category from retail_sales;
  
-- Data Analysis(Bussiness Key Problems)
  
-- Q1. write sql query to retrieve all columns for sales made on '2022-11-05'
	select * from retail_sales where sale_date='2022-11-05';
  
-- Q2. Write a SQL query to retrieve all transactions where the category is 'Clothing' 
-- and the quantity sold is more than 4 in the month of Nov-2022
	select * from retail_sales where category='Clothing' AND quantity > 2
	AND  DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';
    
-- Q3. Write a SQL query to calculate the total sales (total sale) for each category.
	select category,sum(total_sale) from retail_sales group by category;
    
-- Q4. Write a SQL query to find the average age of customers who purchased items 
-- from the 'Beauty' category.
	select round(avg(age),2) from retail_sales where category='Beauty';

-- Q5. Write a SQL query to find all transactions where the total sale is greater 
--  than 1000.
	select * from retail_sales where total_sale>1000;

-- Q6. Write a SQL query to find the total number of transactions (transaction_id) 
-- Made by each gender in each category. 
	select category,gender,count(*) as total_trans from retail_sales
    group by category,gender order by 1;

-- Q7. Write a SQL query to calculate the average sale for each month. Find out best 
-- selling month in each year
	SELECT year, month, avg_sale
	FROM 
    (
		SELECT 
			YEAR(sale_date) AS year,
			MONTH(sale_date) AS month,
			AVG(total_sale) AS avg_sale,
			RANK() OVER (PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_per_year
		FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
	) ranked_sales
	WHERE rank_per_year = 1;


-- Q8. Write a SQL query to find the top 5 customers based on the highest total sales
	select  
		customer_id,
        sum(total_sale) as total_sales
    from retail_sales 
    group by customer_id 
    order by total_sales desc
    limit 5;
		
-- Q9. Write a SQL query to find the number of unique customers who purchased items 
-- from each category.
	select  
		count(distinct customer_id) as unique_customers,
        category
    from retail_sales
    group by category; 
   

-- Q10. write a SQL query to create each shift and number of orders (Example Morning <=12,
-- Afternoon Between 12 & 17, Evening >17)
	with hourly_sale
    as
    (
    select *,
		case
			when hour(sale_time) < 12 then 'Morning'
            when hour(sale_time) between 12 and 17  then 'Afternoon'
            else 'Evening'
		end as shift
    from retail_sales
	)
	select 
		shift,
		count(*) as total_orders
    from hourly_sale
    group by shift;
    
    -- END