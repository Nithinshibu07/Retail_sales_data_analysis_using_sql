# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `retail_Sales_p1`

This project showcases the use of SQL skills and techniques commonly applied by data analysts to explore, clean, and analyze retail sales data. It involves creating a retail sales database, conducting exploratory data analysis (EDA), and solving targeted business questions using SQL queries. The project is well-suited for beginners in data analysis who want to strengthen their SQL foundations.
## Objectives

1.**Database Setup**: Build and load a retail sales database using the provided dataset.

2.**Data Preparation**: Detect and handle records with missing or null values.

3.**Exploratory Data Analysis (EDA)**: Conduct initial analysis to gain an overview of the dataset.

4.**Business Insights**: Apply SQL queries to address key business questions and extract actionable insights.
## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales_csv
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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
   SELECT *
			FROM retail_sales_csv
			WHERE category = 'clothing'
			  AND FORMAT(sale_date, 'yyyy-MM') = '2022-11';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select category,sum(total_sale) as total_sales from retail_sales_csv
group by category

```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select round(avg(age),2) as average_age from retail_sales_csv
where category='beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select * from retail_sales_csv
where total_sale>=1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select category,gender,count(*) as total_transactions
					from retail_sales_csv
					group by 
							category,gender
					order by
							category
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
select * from
(
			select 
				year(sale_date)as year,
				MONTH(sale_date) as month,
				avg(total_sale) as avg_sales,
				rank() over (partition by year(sale_date) order by avg(total_sale) desc) as rank
		from retail_sales_csv
		group by year(sale_date),MONTH(sale_date)
		) as t1
		where rank=1c
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
select top 5 * from
(
select customer_id,sum(total_Sale) as total_sales from retail_sales_csv
group by customer_id
) as t2
order by total_sales desc
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select 
	category,
	count(distinct customer_id)  as no_unique_customers
	from retail_sales_csv
	group by category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
with hourly_sales as
(
select *,
					case
						when datepart(hour,sale_time)<=12 then 'morning'
						when datepart(hour,sale_time) between 12 and 17 then 'Afternoon'
						else 'evening'
						end as shifts
						from retail_sales_csv
					)

					select 
					shifts,
					count(*) as total_orders
					from hourly_sales
					group by shifts
```

## Findings

🔹 **Customer Demographics**: Shoppers span across diverse age groups, with spending distributed across categories such as Clothing and Beauty.
🔹 **High-Value Transactions**: Several purchases crossed ₹1000 in total sales, reflecting premium buying behavior.
🔹 **Sales Trends**: Month-over-month analysis revealed sales fluctuations, helping identify peak seasons.
🔹 **Customer Insights**: The analysis spotlighted top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.

