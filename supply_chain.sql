CREATE DATABASE supply_chain_project
use supply_chain_project

SELECT * FROM supply_chain

-- 1. Total Sales and Profit Analysis
SELECT 
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(order_profit_per_order),2) AS total_profit
FROM supply_chain;

-- 2. Which shipping modes are more likely to result in late deliveries?
-- Objective:
-- To identify which shipping methods have the highest delay rates and evaluate delivery efficiency.
-- Business Impact:
-- Helps the company improve logistics planning, reduce customer dissatisfaction, and optimize shipping strategies.

SELECT
    shipping_mode,
    delivery_status,
    COUNT(*) AS total_orders
FROM supply_chain
GROUP BY shipping_mode, delivery_status
ORDER BY shipping_mode, delivery_status;

-- 3. How frequently do shipping delays occur, and what do their patterns tell us about operational consistency?
-- Objective:
-- To analyze how often delays happen and detect recurring operational issues in the supply chain process.
-- Business Impact:
-- Helps management understand operational stability and improve delivery performance consistency.

SELECT 
    shipping_delay_days,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM supply_chain),
    2) AS percentage_of_orders

FROM supply_chain
GROUP BY shipping_delay_days
ORDER BY shipping_delay_days DESC;

-- 4. Are there specific regions or time periods where shipping delays are more common?
-- Objective:
-- To identify geographical areas or seasonal periods with higher shipping delays.
-- Business Impact:
-- Supports region-specific logistics optimization, workforce planning, and seasonal demand management.

SELECT 
    order_region,
    order_year,
    order_month,
    COUNT(*) AS total_orders,
    SUM(CASE 
            WHEN shipping_delay_days > 0 THEN 1 
            ELSE 0 
        END) AS delayed_orders,
    ROUND(
        SUM(CASE 
                WHEN shipping_delay_days > 0 THEN 1 
                ELSE 0 
            END) * 100.0 / COUNT(*),
    2) AS delay_percentage
FROM supply_chain
GROUP BY 
    order_region,
    order_year,
    order_month
ORDER BY delay_percentage DESC;

-- 5. Which product categories contribute the most to overall sales and profit?
-- Objective:
-- To identify high-performing product categories based on revenue and profitability.
-- Business Impact:
-- Helps businesses focus on profitable categories and optimize inventory investment.

SELECT 
    category_name,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(order_profit_per_order),2) AS total_profit
FROM supply_chain
GROUP BY category_name
ORDER BY total_profit DESC;

-- 6. Which regions generate the highest revenue but suffer from low profitability?
-- Objective:
-- To compare sales performance with profitability across regions.
-- Business Impact:
-- Helps identify regions with high operational costs or pricing inefficiencies.

SELECT 
    order_region,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(order_profit_per_order),2) AS total_profit,
    ROUND(
        SUM(order_profit_per_order) * 100.0 /
        SUM(sales),
    2) AS profit_margin_pct

FROM supply_chain
GROUP BY order_region
ORDER BY total_sales DESC;

-- 7. Which customers contribute the highest revenue to the business?
-- Objective:
-- To identify high-value customers based on total purchase value.
-- Business Impact:
-- Supports customer retention strategies and targeted marketing campaigns.

SELECT TOP 10
    customer_segment,
    ROUND(SUM(sales), 2) AS total_revenue,
    COUNT(order_id) AS total_orders

FROM supply_chain
GROUP BY customer_segment
ORDER BY total_revenue DESC;


-- 8. Which products are generating losses despite having high sales volume?
-- Objective:
-- To identify products with strong sales but poor profitability.
-- Business Impact:
-- Helps reduce losses by improving pricing, sourcing, or operational costs.

SELECT
    product_name,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit

FROM supply_chain
GROUP BY product_name
HAVING SUM(order_profit_per_order) < 0
ORDER BY total_sales DESC;

-- 9. How does customer segment influence sales and profitability?
-- Objective:
-- To analyze purchasing behavior and profitability across customer segments.
-- Business Impact:
-- Helps businesses design targeted strategies for different customer groups.

SELECT 
    customer_segment,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(order_profit_per_order),2) AS total_profit,
    COUNT(order_id) AS total_orders

FROM supply_chain
GROUP BY customer_segment
ORDER BY total_sales DESC;

-- 10. Which months experience peak sales and profit performance?
-- Objective:
-- To identify seasonal sales trends and high-performing periods.
-- Business Impact:
-- Supports demand forecasting and seasonal inventory planning.

SELECT 
    order_year,
    order_month,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(order_profit_per_order),2) AS total_profit
FROM supply_chain
GROUP BY order_year, order_month
ORDER BY total_sales DESC;

-- 11. Is there a relationship between shipping delays and profitability?
-- Objective:
-- To analyze whether delayed deliveries negatively affect business profits.
-- Business Impact:
-- Helps evaluate the financial impact of operational inefficiencies.

SELECT 

    delivery_performance,
    COUNT(*) AS total_orders,
    ROUND(AVG(order_profit_per_order),2) AS avg_profit,
    ROUND(AVG(shipping_delay_days),2) AS avg_delay

FROM supply_chain
GROUP BY delivery_performance
ORDER BY avg_profit DESC;

-- 12. Which markets have the highest operational efficiency?
-- Objective:
-- To evaluate market performance based on delivery speed and profitability.
-- Business Impact:
-- Helps management identify best-performing markets for expansion.

SELECT
    market,
    ROUND(AVG(days_shipping_real), 2) AS avg_delivery_days,
    ROUND(SUM(order_profit_per_order), 2) AS total_profit,
    ROUND(AVG(profit_margin_pct), 2) AS avg_profit_margin

FROM supply_chain
GROUP BY market
ORDER BY avg_profit_margin DESC;

-- 13. Which cities experience the highest order volume and revenue?
-- Objective:
-- To identify major business hubs based on order activity and revenue generation.
-- Business Impact:
-- Supports regional expansion and warehouse planning decisions.

SELECT TOP 10
    customer_state,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(sales), 2) AS total_sales

FROM supply_chain
GROUP BY customer_state
ORDER BY total_sales DESC;

-- 14. Which departments have the highest sales but low profit margins?
-- Objective:
-- To identify departments generating strong revenue but struggling with profitability.
-- Business Impact:
-- Helps management improve pricing strategies, reduce operational costs, and increase profit margins.

SELECT 
    department_name,
    ROUND(SUM(sales),2) AS total_sales,
    ROUND(SUM(order_profit_per_order),2) AS total_profit,
    ROUND(
        SUM(order_profit_per_order) * 100.0 /
        SUM(sales),
    2) AS profit_margin_pct

FROM supply_chain
GROUP BY department_name
ORDER BY total_sales DESC;

-- 15. Which products have the highest average shipping delays?
-- Objective:
-- To identify products that frequently experience delayed deliveries.
-- Business Impact:
-- Helps businesses improve inventory planning, supplier coordination, and logistics management.

SELECT TOP 10
    product_name,
    COUNT(order_id) AS total_orders,
    SUM(
        CASE
            WHEN shipping_delay_days > 0
            THEN 1
            ELSE 0
        END
    ) AS delayed_orders,

    ROUND(
        SUM(
            CASE
                WHEN shipping_delay_days > 0
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(order_id),
        2
    ) AS delay_percentage
FROM supply_chain
GROUP BY product_name
HAVING COUNT(order_id) > 50
ORDER BY delay_percentage DESC;

-- 16. How does order size impact profitability and delivery performance?
-- Objective:
-- To analyze whether large orders affect profit margins and shipping efficiency.
-- Business Impact:
-- Supports better resource allocation, shipping optimization, and bulk order management.

SELECT
    order_size,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(sales), 2) AS avg_sales,
    ROUND(AVG(order_profit_per_order), 2) AS avg_profit,
    ROUND(
        SUM(
            CASE
                WHEN shipping_delay_days > 0
                THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(order_id),
        2
    ) AS delay_percentage

FROM supply_chain
GROUP BY order_size
ORDER BY avg_sales DESC;
