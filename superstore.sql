-- Show available databases
SHOW DATABASES;

-- Use the IPL analysis database
USE ipl_analysis;

-- Show all the tables in the current database
SHOW TABLES;

-- Display all rows from the sales_data table
SELECT * FROM sales_data;

-- Count the total number of records in the sales_data table
SELECT COUNT(*) FROM sales_data;

-- Finding duplicate rows based on order_id and product_name
SELECT 
    order_id, 
    Product_Name, 
    COUNT(*) AS entry_count
FROM sales_data
GROUP BY order_id, Product_Name
HAVING COUNT(*) > 1;

-- Finding NULL values in the sales_data table
SELECT
    SUM(CASE WHEN order_ID IS NULL THEN 1 ELSE 0 END) AS null_row_id,
    SUM(CASE WHEN Order_date IS NULL THEN 1 ELSE 0 END) AS null_order_id,
    SUM(CASE WHEN Customer_Name IS NULL THEN 1 ELSE 0 END) AS null_customer_name,
    SUM(CASE WHEN ship_date IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN ship_mode IS NULL THEN 1 ELSE 0 END) AS null_state,
    SUM(CASE WHEN segment IS NULL THEN 1 ELSE 0 END) AS null_postal_code,
    SUM(CASE WHEN state IS NULL THEN 1 ELSE 0 END) AS null_region,
    SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS null_sales,
    SUM(CASE WHEN market IS NULL THEN 1 ELSE 0 END) AS null_market,
    SUM(CASE WHEN region IS NULL THEN 1 ELSE 0 END) AS null_region,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS null_proudctid,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN sub_category IS NULL THEN 1 ELSE 0 END) AS null_subcategory,
    SUM(CASE WHEN product_name IS NULL THEN 1 ELSE 0 END) AS null_productid
FROM sales_data;

-- Analyzing the total sales, profit, quantity and profit margin in the sales_data table
SELECT
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    CONCAT(ROUND((SUM(profit) / SUM(sales)) * 100, 2), '%') AS profit_margin
FROM sales_data;

-- Analyzing sales performance by region
SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    CONCAT(ROUND((SUM(profit) / SUM(sales)) * 100, 2), '%') AS profit_margin
FROM sales_data
GROUP BY region;

-- Analyzing sales by product name, top 10 products by total sales
SELECT
    product_name,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    CONCAT(ROUND((SUM(profit) / SUM(sales)) * 100, 2), '%') AS profit_margin
FROM sales_data
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 10;

-- Answer to Question 1: Most Profitable Sub-Categories
-- Binders – ₹72,449.60
-- Paper – ₹59,207.25
-- Machines – ₹58,867.70

-- Answer to Question 2: Low Margin or Loss-Making Sub-Categories
-- Tables is the worst performer with a loss of ₹64,083.55 and a -22.09% profit margin.
-- Supplies, Furnishings, and Fasteners show low profit margins (between 10%–14%).

SELECT
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity,
    CONCAT(ROUND((SUM(profit) / SUM(sales)) * 100, 2), '%') AS profit_margin
FROM sales_data
GROUP BY sub_category
ORDER BY total_profit, profit_margin ASC
LIMIT 10;

-- Analyzing by segment, calculating total sales, profit, AOV and profit margin
SELECT
    segment,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS AOV,
    CONCAT(ROUND((SUM(profit) / SUM(sales)) * 100, 2), '%') AS profit_margin
FROM sales_data
GROUP BY segment;

-- Analyzing by region with total sales, profit, AOV, and profit margin
SELECT
    region,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS AOV,
    CONCAT(ROUND((SUM(profit) / SUM(sales)) * 100, 2), '%') AS profit_margin
FROM sales_data
GROUP BY region;

-- Analyzing sales and profit by category, sub-category, and top-performing products
SELECT 
    category,
    sub_category,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(sales) / COUNT(DISTINCT order_id), 2) AS AOV,
    CONCAT(ROUND((SUM(profit) / SUM(sales)) * 100, 2), '%') AS profit_margin,
    -- Top-performing product by sales
    (SELECT product_name 
     FROM sales_data 
     WHERE category = s.category AND sub_category = s.sub_category 
     GROUP BY product_name 
     ORDER BY SUM(sales) DESC LIMIT 1) AS top_product_by_sales,
    -- Top-performing product by profit
    (SELECT product_name 
     FROM sales_data 
     WHERE category = s.category AND sub_category = s.sub_category 
     GROUP BY product_name 
     ORDER BY SUM(profit) DESC LIMIT 1) AS top_product_by_profit
FROM sales_data s
GROUP BY category, sub_category;

-- Analyzing sales by year and month with profit margin
SELECT 
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    CONCAT(ROUND((SUM(profit) / SUM(sales)) * 100, 2), '%') AS profit_margin
FROM sales_data
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY year, month;
