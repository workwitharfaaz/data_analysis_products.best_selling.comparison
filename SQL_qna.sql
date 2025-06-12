CREATE TABLE df_orders(
order_id int primary key
,order_date date
,cost_price decimal (7,2)
,list_price decimal (7,2)
,ship_mode varchar(20)
,segment varchar(20)
,country varchar(20)
,city varchar(20)
,state varchar(20)
,postal_code varchar(20)
,region varchar(20)
,category varchar(20)
,sub_category varchar(20)
,product_id varchar(20)
,quantity int
,discount decimal (7,2)
,discount_percent decimal (7,2)
,sale_price decimal (7,2)
,profit decimal (7,2)
)


SELECT * FROM df_orders
limit 1;


#Questions & Answers

#1 find top 10 highest revenue generating products

SELECT product_id, SUM(sale_price) as revenue from df_orders
group by product_id 
ORDER BY revenue desc
limit 10;

#2  find top 5 highest selling product in each region

WITH cte AS (
  SELECT region, product_id, SUM(quantity) AS quantity
  FROM df_orders
  GROUP BY region, product_id
) SELECT * FROM (
SELECT *,
  ROW_NUMBER() OVER (PARTITION BY region ORDER BY quantity DESC) AS rn
FROM cte) A
WHERE RN <=5;

#3 find month over month growth comparison for 2022 and 2023 sales example : jan 2022 vs jan 2023

with cte as (
select year(order_date) as order_year,month(order_date) as order_month,
sum(sale_price) as revenue
from df_orders
group by year(order_date),month(order_date)
order by year(order_date),month(order_date)
	)
select order_month
, sum(case when order_year=2022 then revenue else 0 end) as revenue_2022
, sum(case when order_year=2023 then revenue else 0 end) as revenue_2023
from cte 
group by order_month
order by order_month;