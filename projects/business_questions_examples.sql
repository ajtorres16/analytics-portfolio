1. select
    'Q' + cast(datepart(quarter, [Order Date]) as varchar(1))+' '+cast(datepart(year,[Order Date]) as Varchar(4))as Quarter_year, sum(Sales) as total_sales
from Sales.train_v5
where datepart(year, [Order Date]) = '2017'
and datepart(quarter, [Order Date])= '3'
group by datepart(year, [Order Date]), datepart(quarter, [Order Date])

  
2. Select cast (Category as varchar(max)) as category_clean, SUM(Sales) as total_sales
from Sales.train_v5
group by cast (Category as varchar(max))
order by Sum(sales) desc

3. select top 10
  cast(Category as VARCHAR(MAX)) as category_clean, 'Q' + cast(datepart(quarter, [Order Date]) as varchar(1))+' '+cast(datepart(year,[Order Date]) as Varchar(4))as Quarter_year,
    count(cast([Order ID] as varchar(max))) as Order_Count
from Sales.train_v5
where cast(Category as VARCHAR(MAX)) = 'furniture'
group by cast(Category as VARCHAR(MAX)), datepart(year, [Order Date]), datepart(quarter, [Order Date])
order by Order_Count desc

4. select
  cast(Category as VARCHAR(MAX)) as category_clean, 'Q' + cast(datepart(quarter, [Order Date]) as varchar(1))+' '+cast(datepart(year,[Order Date]) as Varchar(4))as Quarter_year,
    count(cast([Order ID] as varchar(max))) as Order_Count,
    cast(count(cast([Order ID] as varchar(max))) *100/ sum(count(cast([Order ID] as varchar(max))))over () as decimal(18,2)) as percentage_of_total_Sales,
ROUND(SUM(COUNT(CAST([Order ID] AS VARCHAR(MAX)))) OVER (
          ORDER BY DATEPART(YEAR, [Order Date]), DATEPART(QUARTER, [Order Date])
          ROWS UNBOUNDED PRECEDING) * 100.0 /
          SUM(COUNT(CAST([Order ID] AS VARCHAR(MAX)))) OVER(), 2) AS Cumulative_Percent
from Sales.train_v5
--where cast(Category as VARCHAR(MAX)) = 'furniture'
group by cast(Category as VARCHAR(MAX)), datepart(year, [Order Date]), datepart(quarter, [Order Date])
order by Order_Count desc

5. select *, datepart(year, [Order Date]) as year
from Sales.train_v5
where datepart(year, [Order Date]) = '2017' and  [Order Date] <'2017-12-31'
order by [Order Date] desc

6. With RANKEDSAlES as(
select
    cast([Product Name] as varchar(max)) as Product_Name_Clean,
       cast([Sub-Category] as varchar(max)) as Sub_Category_Clean,
       sum(sales) as total_Sales,
       rank() over (partition by cast([Sub-Category] as varchar(max)) order by sum(Sales) desc) as Sales_Rank
       from Sales.train_v5
group by
    cast([Product Name] as varchar(max)),
         cast([Sub-Category] as varchar(max))
)
SELECT * FROM RankedSales
WHERE Sales_Rank <= 5
ORDER BY Sub_Category_Clean, Sales_Rank;

 7. select
    cast (Region as varchar(max)) as Region,
       datepart(Month,cast(cast([Order Date] as varchar(max)) as date)) as month,
       sum(Sales) as current_month,
       LAG(SUM(Sales)) OVER (
        PARTITION BY
           CAST(Region AS VARCHAR(MAX))
        ORDER BY
            DATEPART(Month, CAST(CAST([Order Date] AS VARCHAR(MAX)) AS DATE))) as previous_Month,
 Lead(SUM(Sales)) OVER (
        PARTITION BY
           CAST(Region AS VARCHAR(MAX))
        ORDER BY
            DATEPART(Month, CAST(CAST([Order Date] AS VARCHAR(MAX)) AS DATE))) as Next_Month,

   (sum(Sales)-Lag(SUM(Sales)) OVER (
        PARTITION BY
           CAST(Region AS VARCHAR(MAX))
        ORDER BY
            DATEPART(Month, CAST(CAST([Order Date] AS VARCHAR(MAX)) AS DATE)))) *1.0 /LAG(SUM(Sales)) OVER (
        PARTITION BY
           CAST(Region AS VARCHAR(MAX))
        ORDER BY
            DATEPART(Month, CAST(CAST([Order Date] AS VARCHAR(MAX)) AS DATE))) as Previous_MOM_Change,

     (sum(Sales)-Lead(SUM(Sales)) OVER (
        PARTITION BY
           CAST(Region AS VARCHAR(MAX))
        ORDER BY
            DATEPART(Month, CAST(CAST([Order Date] AS VARCHAR(MAX)) AS DATE))))*1.0 /Lead(SUM(Sales)) OVER (
        PARTITION BY
           CAST(Region AS VARCHAR(MAX))
        ORDER BY
            DATEPART(Month, CAST(CAST([Order Date] AS VARCHAR(MAX)) AS DATE))) as Predicted_MOM_Change


    from
           Sales.train_v5
group by
           cast (Region as varchar(max)),
           datepart(Month,cast(cast([Order Date] as varchar(max))as date))
order by
          Region

 
8. select

    cast([Product Name] as varchar(max)) as Product_Name_Clean,
       cast([Sub-Category] as varchar(max)) as Sub_Category_Clean,
       sum(sales) as total_Sales,
       rank() over (partition by cast([Sub-Category] as varchar(max)) order by sum(Sales) desc) as Sales_Rank
       from Sales.train_v5
group by
    cast([Product Name] as varchar(max)),
         cast([Sub-Category] as varchar(max))
)
SELECT * FROM RankedSales
WHERE Sales_Rank <= 5
ORDER BY Sub_Category_Clean, Sales_Rank;

 
9. with RankedSales as(
select
    Cast([Customer Name] as VARCHAR(max)) as Customer_Name,
    Cast([Segment] as VARCHAR(max)) as Segment_Clean,
    sum(sales) as total_Sales,
       rank() over (partition by Cast([Segment] as VARCHAR(max)) order by sum(Sales) desc) as Sales_Rank
       from Sales.train_v5
group by
        Cast([Customer Name] as VARCHAR(max)),
    Cast([Segment] as VARCHAR(max)),
         cast([Sub-Category] as varchar(max))
)
SELECT * FROM RankedSales
WHERE Sales_Rank <= 5
ORDER BY Segment_Clean

