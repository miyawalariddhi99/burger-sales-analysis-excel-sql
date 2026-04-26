Use BurgerDb

select * from burger_sales; 

--KPI REQUIREMENTS 
--(1) Total revenue - The sum of the total price of all burger orders.
SELECT 
SUM(total_price) AS total_revenue
FROM burger_sales;

--(2)Average Order Value (AOV): The average amount spent per order, calculated by dividing the total revenue by the total number of orders.
SELECT 
    SUM(total_price) / COUNT(DISTINCT order_id) AS Avg_Order_Value
FROM burger_sales;

--(3) Total Burgers Sold: The sum of the quantities of all burgers sold.
SELECT 
    SUM(quantity) AS total_Burgers_sold
FROM burger_sales;

--(4)Total Orders: The total number of orders placed.
SELECT
    COUNT(DISTINCT order_id)AS total_orders
FROM burger_sales; 

--(5)Average Burgers Per Order: The average number of burgers sold per order, 
--calculated by dividing the total number of burgers sold by the total number of orders.

SELECT 
CAST(SUM(Quantity) AS DECIMAL(10,2)) /
CAST(COUNT(DISTINCT Order_id) AS decimal(10,2)) AS Avg_burgers_per_orders
FROM burger_sales;


--charts :

--1. Daily Trend for Total Orders:
SELECT DATENAME(DW,order_date) as order_day, COUNT(DISTINCT order_id) AS total_orders
FROM burger_sales
GROUP BY DATENAME(DW,order_date) ;

--2.Hourly Trend for Total Orders
SELECT
    DATEPART(HOUR,order_time)AS order_hours , COUNT(DISTINCT order_id) AS total_orders
    FROM burger_sales
    GROUP BY DATEPART(HOUR,order_time)
    ORDER BY DATEPART(HOUR,order_time);

--3. Percentage of sales by burger category :
SELECT
    burger_category,
    SUM(total_price) * 100 / 
    ( SELECT SUM(total_price) from burger_sales WHERE MONTH(order_date)=1 ) AS Pers_for_sales
    FROM burger_sales 
    WHERE MONTH(order_date)=1
    GROUP BY burger_category;

--4.percentage of sales by burger size :
SELECT
   burger_size,
    CAST(SUM(total_price) * 100 / 
    ( SELECT SUM(total_price) from burger_sales WHERE DATEPART(QUARTER , order_date)=1  )
                   AS DECIMAL (10,2))AS PCT
    FROM burger_sales
   WHERE DATEPART(QUARTER , order_date)=1    
    GROUP BY burger_size
    ORDER BY PCT DESC;

--5. Total burger sold by burger category:
SELECT
    burger_category,
    SUM(quantity) AS Total_burger_sold
FROM burger_Sales
GROUP BY burger_category;

--6 . Top 5 best sellers by Total burger sold :
SELECT TOP 5
    burger_name,
    SUM(quantity)AS total_burgers_sold
from burger_sales
GROUP BY burger_name
ORDER BY SUM(quantity)DESC ;

--7. Bottom 5 worst sellers by total burger sold 
SELECT TOP 5
    burger_name,
    SUM(quantity)AS total_burgers_sold
from burger_sales
WHERE MONTH(order_date)= 8
GROUP BY burger_name
ORDER BY SUM(quantity) ASC ; 
