select * from blinkit_data

select count(*) from blinkit_data

select distinct(Item_Fat_Content)
from blinkit_data

update blinkit_data
set Item_Fat_Content =
case when Item_Fat_Content in ('LF', 'low fat') then 'Low Fat'
	when Item_Fat_Content = 'reg' then 'Regular'
	else Item_Fat_Content
End

--Total Sales
select concat(round(sum(sales) / 1000000, 2) , ' ', 'Million') as total_sales_millions
from blinkit_data

--Avg Sales
select cast(avg(sales) as decimal(10,1)) as avg_sales
from blinkit_data

--Number of items
select count(*) as noofitems
from blinkit_data

--Avg rating
select round(avg(rating), 2) as avg_rating
from blinkit_data

--total sales by fat content
select Item_Fat_Content,
	concat(round(sum(sales)/1000, 2),' ', 'K') as total_sales_thousands,
	cast(avg(sales) as decimal(10,1)) as avg_sales,
	count(*) as no_of_items,
	round(avg(rating), 2) as avg_rating
from blinkit_data
where Outlet_Establishment_Year = 2022
group by Item_Fat_Content
order by total_sales_thousands

-- Total sales by item type
select top 5 Item_Type,
	round(sum(sales), 2) as total_sales,
	cast(avg(sales) as decimal(10,1)) as avg_sales,
	count(*) as no_of_items,
	round(avg(rating), 2) as avg_rating
from blinkit_data
--where Outlet_Establishment_Year = 2022
group by Item_Type
order by total_sales desc


-- Fat content by outlet for totalsales
SELECT
    Outlet_Location_Type,
    ROUND(SUM(CASE WHEN Item_Fat_Content = 'Low Fat' THEN Sales ELSE 0 END), 2) AS Low_Fat_Sales,
    ROUND(SUM(CASE WHEN Item_Fat_Content = 'Regular' THEN Sales ELSE 0 END), 2) AS Regular_Sales,
    ROUND(SUM(Sales), 2) AS Total_Sales
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales

SELECT Outlet_Location_Type,
	ISNULL([Low Fat], 0) AS Low_Fat,
	ISNULL([Regular], 0) AS Regular
FROM
(
	SELECT Outlet_Location_Type, Item_Fat_Content,
	CAST(SUM(Sales) AS DECIMAL(10,2)) AS Total_Sales
	FROM blinkit_data
	GROUP BY Outlet_Location_Type, Item_Fat_Content
)AS SourceTable
PIVOT
(
	SUM(Total_Sales)
	FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


-- total sales by outlet establishment

select outlet_establishment_year,
	round(sum(sales), 2) as total_sales,
	cast(avg(sales) as decimal(10,1)) as avg_sales,
	count(*) as no_of_items,
	round(avg(rating), 2) as avg_rating
from blinkit_data
--where Outlet_Establishment_Year = 2022
group by Outlet_Establishment_Year
order by Outlet_Establishment_Year

--Percentage of sales by outlet size
select Outlet_Size,
	round(sum(sales), 2) as total_sales,
	round(sum(sales) * 100 / sum(sum(sales)) over(), 2) as sales_percent
from blinkit_data
group by Outlet_Size

-- sales by outlet location
select Outlet_Location_Type,
	sum(sales) as total_sales
from blinkit_data
group by Outlet_Location_Type

select Outlet_Location_Type,
	round(sum(sales), 2) as total_sales_thousands,
	round(sum(sales) * 100 / sum(sum(sales)) over(), 2) as sales_percent,
	cast(avg(sales) as decimal(10,1)) as avg_sales,
	count(*) as no_of_items,
	round(avg(rating), 2) as avg_rating
from blinkit_data
group by Outlet_Location_Type
order by total_sales_thousands

--all metric by outlet type
select Outlet_Type,
	round(sum(sales), 2) as total_sales,
	round(sum(sales) * 100 / sum(sum(sales)) over(), 2) as sales_percent,
	cast(avg(sales) as decimal(10,1)) as avg_sales,
	count(*) as no_of_items,
	round(avg(rating), 2) as avg_rating
from blinkit_data
group by Outlet_Type
order by total_sales