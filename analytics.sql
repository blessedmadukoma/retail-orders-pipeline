-- top 10 highest revenue generating products
SELECT 
    product_id,
    sum(sale_price) AS sales
FROM 
    df_orders 
GROUP BY 
    product_id 
ORDER BY 
    sales DESC 
LIMIT 10;

-- top 5 highest selling products in each region
WITH cte AS (
    SELECT 
        region,
        product_id,
        sum(sale_price) AS sales
    FROM 
        df_orders 
    GROUP BY 
        region,
        product_id 
)
SELECT * FROM (
    SELECT 
        *,
        ROW_NUMBER() 
            OVER(PARTITION BY region ORDER BY sales DESC) AS rn 
    FROM CTE
) AS A 
WHERE rn <= 5;

-- month over month growth comparison for 2022 and 2023 sales e.g. January 2022 vs January 2023
WITH cte AS (
SELECT 
    EXTRACT(YEAR FROM order_date) AS order_year, 
    EXTRACT(MONTH FROM order_date) AS order_month, 
    SUM(sale_price) AS sales 
FROM df_orders 
GROUP BY order_year, order_month 
-- ORDER BY order_year, order_month;
)
SELECT 
    order_month,
    SUM(CASE WHEN order_year=2022 THEN sales ELSE 0 END) AS Sales_2022,
    SUM(CASE WHEN order_year=2023 THEN sales ELSE 0 END) AS Sales_2023
FROM cte 
GROUP BY order_month
ORDER BY order_month;

-- for each category, which month had the highest sales?
WITH cte AS (
    SELECT 
        category, TO_CHAR(order_date, 'YYYY-MM') AS order_year_month,
        SUM(sale_price) AS sales 
    FROM df_orders 
    GROUP BY category, order_year_month
)
SELECT * FROM (
    SELECT
        *,
        ROW_NUMBER() OVER (PARTITION BY category ORDER BY sales) AS rn
    FROM cte
) AS a
WHERE rn = 1;

-- which sub category had the highest growth by profit in 2023, compared to 2022
WITH cte AS (
SELECT 
    sub_category,
    EXTRACT(YEAR FROM order_date) AS order_year,
    SUM(sale_price) AS sales 
FROM df_orders 
GROUP BY sub_category, order_year 
),
cte2 AS (
SELECT 
    sub_category,
    SUM(CASE WHEN order_year=2022 THEN sales ELSE 0 END) AS Sales_2022,
    SUM(CASE WHEN order_year=2023 THEN sales ELSE 0 END) AS Sales_2023
FROM cte 
GROUP BY sub_category
)
SELECT 
    *, 
    (Sales_2023 - Sales_2022)*100/Sales_2022 AS growth_percent
FROM cte2
ORDER BY growth_percent DESC
LIMIT 1;