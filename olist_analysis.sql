-- Q1: Total number of orders by status
SELECT order_status, COUNT(*) as total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Q2: Top 10 cities by number of customers
SELECT TOP 10 customer_city, COUNT(*) as total_customers
FROM customers
GROUP BY customer_city
ORDER BY total_customers DESC;

-- Q3: Total revenue generated
SELECT ROUND(SUM(payment_value), 2) as total_revenue
FROM order_payments;

-- Q4: Most used payment methods
SELECT payment_type, COUNT(*) as usage_count,
ROUND(SUM(payment_value), 2) as total_value
FROM order_payments
GROUP BY payment_type
ORDER BY usage_count DESC;

-- Q5: Average order value
SELECT ROUND(AVG(payment_value), 2) as avg_order_value
FROM order_payments;










-- Q6: Monthly order trend
SELECT 
    FORMAT(CAST(order_purchase_timestamp AS DATETIME), 'yyyy-MM') as order_month,
    COUNT(*) as total_orders
FROM orders
WHERE order_purchase_timestamp IS NOT NULL
GROUP BY FORMAT(CAST(order_purchase_timestamp AS DATETIME), 'yyyy-MM')
ORDER BY order_month;

-- Q7: Top 10 product categories by revenue
SELECT TOP 10
    t.product_category_name_english as category,
    ROUND(SUM(oi.price), 2) as total_revenue
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_translation t 
    ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY total_revenue DESC;

-- Q8: Average delivery time in days
SELECT 
    ROUND(AVG(DATEDIFF(day, 
        CAST(order_purchase_timestamp AS DATETIME),
        CAST(order_delivered_customer_date AS DATETIME)
    )), 1) as avg_delivery_days
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
AND order_purchase_timestamp IS NOT NULL;

-- Q9: Top 10 sellers by revenue
SELECT TOP 10
    oi.seller_id,
    s.seller_city,
    s.seller_state,
    ROUND(SUM(oi.price), 2) as total_revenue,
    COUNT(DISTINCT oi.order_id) as total_orders
FROM order_items oi
JOIN sellers s ON oi.seller_id = s.seller_id
GROUP BY oi.seller_id, s.seller_city, s.seller_state
ORDER BY total_revenue DESC;

-- Q10: Customer retention — repeat vs one-time buyers
SELECT 
    CASE WHEN order_count = 1 THEN 'One-time buyer'
         ELSE 'Repeat buyer' END as customer_type,
    COUNT(*) as total_customers
FROM (
    SELECT customer_unique_id, COUNT(*) as order_count
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    GROUP BY customer_unique_id
) as customer_orders
GROUP BY CASE WHEN order_count = 1 THEN 'One-time buyer'
              ELSE 'Repeat buyer' END;















-- Q11: Review score distribution
SELECT 
    review_score,
    COUNT(*) as total_reviews,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
FROM order_reviews
GROUP BY review_score
ORDER BY review_score DESC;

-- Q12: Late deliveries by state
SELECT TOP 10
    c.customer_state,
    COUNT(*) as late_deliveries
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE CAST(o.order_delivered_customer_date AS DATETIME) 
    > CAST(o.order_estimated_delivery_date AS DATETIME)
AND o.order_delivered_customer_date IS NOT NULL
AND o.order_estimated_delivery_date IS NOT NULL
GROUP BY c.customer_state
ORDER BY late_deliveries DESC;

-- Q13: Revenue by state
SELECT TOP 10
    c.customer_state,
    ROUND(SUM(op.payment_value), 2) as total_revenue,
    COUNT(DISTINCT o.order_id) as total_orders
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_payments op ON o.order_id = op.order_id
GROUP BY c.customer_state
ORDER BY total_revenue DESC;

-- Q14: Average review score by product category
SELECT TOP 10
    t.product_category_name_english as category,
    ROUND(AVG(CAST(r.review_score AS FLOAT)), 2) as avg_review_score,
    COUNT(*) as total_reviews
FROM order_reviews r
JOIN orders o ON r.order_id = o.order_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
JOIN product_category_translation t 
    ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
HAVING COUNT(*) > 100
ORDER BY avg_review_score DESC;



-- Q15: Running total revenue by month (Window Function)
SELECT 
    order_month,
    monthly_revenue,
    ROUND(SUM(monthly_revenue) OVER(ORDER BY order_month 
          ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW), 2) as running_total
FROM (
    SELECT 
        FORMAT(CAST(o.order_purchase_timestamp AS DATETIME), 'yyyy-MM') as order_month,
        ROUND(SUM(op.payment_value), 2) as monthly_revenue
    FROM orders o
    JOIN order_payments op ON o.order_id = op.order_id
    WHERE o.order_purchase_timestamp IS NOT NULL
    GROUP BY FORMAT(CAST(o.order_purchase_timestamp AS DATETIME), 'yyyy-MM')
) as monthly
ORDER BY order_month;