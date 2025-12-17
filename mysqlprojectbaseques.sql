SELECT * FROM vvs.customers3;
SELECT * FROM vvs.products3;
SELECT * FROM vvs.orders3;
SELECT * FROM vvs.order_items1;

-- 1
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(oi.total_price) AS total_spent
FROM vvs.customers3 c
JOIN vvs.orders3 o 
    ON c.customer_id = o.customer_id
JOIN order_items1 oi 
    ON o.order_id = oi.order_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC
LIMIT 10;
-- 2
select c.city,sum(oi.total_price) as highest_revenue
from vvs.customers3 c
join  vvs.orders3 o 
on c.customer_id=o.customer_id
join vvs.order_items1 oi
on o.order_id=oi.order_id
group by c.city
order by highest_revenue desc;
-- 3
SELECT 
    CASE 
        WHEN COUNT(o.order_id) = 1 THEN 'New Customer'
        ELSE 'Repeat Customer'
    END AS customer_type,
    COUNT(*) AS total_customers
FROM vvs.orders3 o
GROUP BY o.customer_id
ORDER BY customer_type;
-- 4
SELECT c.customer_id, c.customer_name, c.city, c.signup_date
FROM vvs.customers3 c
LEFT JOIN vvs.orders3 o 
       ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;
-- 5
SELECT SUM(total_price) AS total_revenue
FROM vvs.order_items1;
SELECT COUNT(*) AS total_orders
FROM vvs.orders3;
SELECT 
    SUM(oi.total_price) / COUNT(DISTINCT o.order_id) AS AOV
FROM vvs.orders3 o
join vvs.order_items1 as oi
on o.order_id=oi.order_id;
-- 6
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.total_price) AS total_revenue,
    (SUM(oi.total_price) / COUNT(DISTINCT o.order_id)) AS avg_order_value
FROM vvs.orders3 o
JOIN vvs.order_items1 oi 
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY month;
-- 7
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(oi.total_price) AS total_revenue
FROM vvs.orders3 o
JOIN vvs.order_items1 oi 
    ON o.order_id = oi.order_id
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m')
ORDER BY order_month;
-- 8
SELECT 
    p.product_id,
    p.product_name,
    SUM(oi.quantity) AS total_quantity_sold
FROM vvs.order_items1 oi
JOIN vvs.products3 p 
    ON oi.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 5;
-- 9
select p.product_name,p.category,sum(oi.total_price) as highest_revenue
from vvs.products3 p 
join vvs.order_items1 oi 
on p.product_id=oi.product_id
group by p.product_name,p.category
order by highest_revenue desc;
-- 10
select p.product_name,p.product_id,min(oi.order_id) as few_order
from vvs.products3 p 
join vvs.order_items1 oi 
on p.product_id = oi.product_id
group by p.product_name,p.product_id
order by few_order;
-- 11



-- 12
select c.customer_name,o.order_id,avg(oi.total_price) as avg_revenue
from vvs.customers3 c 
join vvs.orders3 o 
on c.customer_id=o.customer_id
join vvs.order_items1 oi 
on o.order_id=oi.order_id 
group by c.customer_name,o.order_id
order by avg_revenue;
-- 13
WITH monthly_category_sales AS (
    SELECT 
        DATE_FORMAT(o.order_date, '%Y-%m') AS order_month,
        p.category,
        SUM(oi.total_price) AS revenue,
        ROW_NUMBER() OVER (
            PARTITION BY DATE_FORMAT(o.order_date, '%Y-%m') 
            ORDER BY SUM(oi.total_price) DESC
        ) AS rn
    FROM vvs.orders3 o
    JOIN vvs.order_items1 oi 
        ON o.order_id = oi.order_id
    JOIN vvs.products3 p 
        ON oi.product_id = p.product_id
    GROUP BY DATE_FORMAT(o.order_date, '%Y-%m'), p.category
)
SELECT 
    order_month,
    category AS top_category,
    revenue AS category_revenue
FROM monthly_category_sales
WHERE rn = 1
ORDER BY order_month;
-- 14
SELECT 
    p1.product_name AS product_1,
    p2.product_name AS product_2,
    COUNT(*) AS times_bought_together
FROM vvs.order_items1 oi1
JOIN vvs.order_items1 oi2 
    ON oi1.order_id = oi2.order_id
   AND oi1.product_id < oi2.product_id      -- avoid duplicates & self join
JOIN vvs.products3 p1 ON oi1.product_id = p1.product_id
JOIN vvs.products3 p2 ON oi2.product_id = p2.product_id
GROUP BY 
    p1.product_name, 
    p2.product_name
HAVING COUNT(*) >= 1
ORDER BY times_bought_together DESC;
-- 15
SELECT 
    COUNT(*) / COUNT(DISTINCT customer_id) AS avg_orders_per_customer
FROM vvs.orders3;
-- 16
SELECT 
    CASE 
        WHEN item_count = 1 THEN 'Single Item Order'
        WHEN item_count = 2 THEN 'Two-Item Order'
        ELSE 'Multi-Item Order (3+ items)'
    END AS order_type,
    COUNT(*) AS total_orders
FROM (
    SELECT 
        order_id,
        COUNT(product_id) AS item_count
    FROM vvs.order_items1
    GROUP BY order_id
) t
GROUP BY order_type
ORDER BY total_orders DESC;
-- 17
SELECT 
    DAYNAME(o.order_date) AS day_name,
    SUM(oi.quantity * p.price) AS total_sales
FROM vvs.orders3 o
JOIN vvs.order_items1 oi ON o.order_id = oi.order_id
JOIN vvs.products3 p ON oi.product_id = p.product_id
GROUP BY day_name
ORDER BY total_sales DESC;












