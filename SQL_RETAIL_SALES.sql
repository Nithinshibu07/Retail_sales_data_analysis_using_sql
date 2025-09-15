create database retail_Sales_p1

select * from [dbo].[retail_sales_csv]

SELECT TOP 10 *
FROM retail_sales_csv

select count(*) from retail_sales_csv

alter table retail_sales_csv
add constraint pk_transaction_id
primary key(transactions_id)


select * from retail_sales_csv
where transactions_id is null

select * from retail_sales_csv
where category is null

--another way

select * from retail_sales_csv
where 
		transactions_id is null 
			or
			sale_date is null
			or
			customer_id is null
			or
			gender is null
			or
			age is null
			or
			category is null
			or 
			quantity is null
			or
			price_per_unit is null
			or
			cogs is null 
			or
			total_sale is null 


----deleting rows with null values

delete from retail_sales_csv
where
		
		transactions_id is null 
			or
			sale_date is null
			or
			customer_id is null
			or
			gender is null
			or
			age is null
			or
			category is null
			or 
			quantity is null
			or
			price_per_unit is null
			or
			cogs is null 
			or
			total_sale is null 

select count(*) from retail_sales_csv

---data exploration

--count of how many sales we have
select count(*) as total_sale from retail_sales_csv

--how many unique customers we have?

select count(distinct customer_id) as total_customers from retail_sales_csv

--count of how many unique category we have?

select count(distinct category) as total_category from retail_sales_csv

--listing the distinct category
select distinct category as categories from retail_sales_csv

-----------------------------------------------------------------------------------------------------

---data analysis and business key problems and answers

--q1. write a sql query to retrieve all columns from sales made on '2022-11-05'

			select *  from retail_sales_csv where sale_date is '2022-11-05'--***mistake is we use 'is' for null checks
		--correct query
		select *  from retail_sales_csv where sale_date = '2022-11-05'

--q2 - write a sql query to retrieve all transaction where category is cothing and quantity sold is more than 
--      10 in month of nov-2022

		--a. Total sum of quantity sold for clothing category
				SELECT
			    category,	SUM(quantity) as total_quantity
				FROM
				retail_sales_csv
				WHERE
				category='clothing'
				group by  category

		--b. quantity sold for clothing category in the month of nov-2022
		   
		      SELECT *
					FROM retail_sales_csv
					WHERE category = 'clothing'
					  AND FORMAT(sale_date, 'yyyy-MM') = '2022-11';


		--c. write a sql query to retrieve all transaction where category is cothing and quantity sold is more than 
--      10 in month of nov-2022
		
						select * from retail_sales_csv
						WHERE
						category='clothing'
						AND FORMAT(sale_date,'yyyy-MM')='2022-11'----yyyy in small and MM in caps
						
						--OR

						SELECT *
							FROM retail_sales_csv
							WHERE category = 'clothing'
							  AND sale_date >= '2022-11-01'
							  AND sale_date < '2022-12-01'
							  AND quantity >= 4;
						--OR

						select * from retail_Sales_csv
						where
						category='clothing' 
						AND quantity>3 
						AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'

						/*FROM THE DATA WE HAVE DONE 17 SALES ON THE MONTH OF NOV-2022 FOR CLOTHING 
						CATEGORY WHERE THE QUANTITT >4 */

--Q3.write a sql query to calculate the total sales for each category
			select category,sum(total_sale) as total_sales from retail_sales_csv
			group by category

	--printing count of orders along with it 

				select category,sum(total_sale) as net_sale,count(*) as total_orders from retail_sales_csv
				group by category


--Q4. write an sql query to find the average age of customers who purchased items from 'beauty' category
				select avg(age) as average_age from retail_sales_csv
				where category='beauty'

		--if decimal number arises ,we need to round that 
				select round(avg(age),2) as average_age from retail_sales_csv
				where category='beauty'

--q5.write sql query to find all transaction where total sale is greater than 1000

				select * from retail_sales_csv
				select * from retail_sales_csv
				where total_sale>=1000

--Q6. write an sql query to find the total number of transaction (transaction_id) made
--    by each gender in each category

				select category,gender,count(*) as total_transactions
						from retail_sales_csv
						group by 
								category,gender
						order by
								category

--q7.write an sql query to calculate average sales for each month.find out best selling month in each year

			select  format(sale_date,'MM') as month,avg(total_sale) AS monthly_sales
				from retail_sales_csv
				group by format(sale_date,'MM')
				order by MONTH

	---OR
				SELECT 
					FORMAT(sale_date, 'yyyy-MM') AS month,
					AVG(total_sale) AS monthly_avg_sales
				FROM retail_sales_csv
				GROUP BY FORMAT(sale_date, 'yyyy-MM')
				ORDER BY month;

	--or

				select 
						year(sale_date)as year,
						MONTH(sale_date) as month,
						avg(total_sale) as avg_sales
				from retail_sales_csv
				group by year(sale_date),MONTH(sale_date)
				order by year, avg_sales desc


		--another way using windows function				
		
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
				where rank=1

--Q8. write sql query to find top 5 customers based on highest total sale
		select top 5 * from
		(
		select customer_id,sum(total_Sale) as total_sales from retail_sales_csv
		group by customer_id
		) as t2
		order by total_sales desc
	
--Q9. write the sql query to find the number of unique customers who purchased items from each category

		select 
			category,
			count(distinct customer_id)  as no_unique_customers
			from retail_sales_csv
			group by category

--Q10. write an sql query to create each shifts and number of orders (example morning<=12 , afternoon between 12 &17,evening >17)

					  SELECT 
				COUNT(CASE WHEN DATEPART(hour, sale_time) < 12 THEN 1 END) AS morning_count,
				COUNT(CASE WHEN DATEPART(hour, sale_time) BETWEEN 12 AND 17 THEN 1 END) AS afternoon_count,
				COUNT(CASE WHEN DATEPART(hour, sale_time) > 17 THEN 1 END) AS evening_count
			FROM retail_sales_csv;

	--OR

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



			
			

		




		
		
