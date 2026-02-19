-- Analyzing Regional Price Sensitivity
WITH SalesData AS (
    SELECT 
        location_id,
        region,
        item_name,
        unit_price,
        quantity_sold,
        (unit_price * quantity_sold) AS total_revenue
    FROM escape_enterprise_sales
    WHERE transaction_date BETWEEN '2025-01-01' AND '2025-12-31'
),

RegionMetrics AS (
    SELECT 
        region,
        item_name,
        AVG(unit_price) AS avg_price,
        SUM(quantity_sold) AS total_qty,
        SUM(total_revenue) AS revenue
    FROM SalesData
    GROUP BY region, item_name
)

-- Identify regions where price increases led to a volume drop (Elasticity)
SELECT 
    region,
    item_name,
    avg_price,
    revenue,
    RANK() OVER (PARTITION BY item_name ORDER BY revenue DESC) AS revenue_rank
FROM RegionMetrics
WHERE total_qty < (SELECT AVG(total_qty) FROM RegionMetrics)
ORDER BY revenue DESC;
