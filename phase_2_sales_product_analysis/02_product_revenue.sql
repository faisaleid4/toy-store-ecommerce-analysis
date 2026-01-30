-- Analysis 2: Product Revenue

-- Which products generate the most revenue?

USE ToyStoreEcommrce

SELECT
	oi.product_id,
	product_name,
	COUNT(oi.product_id) units_sold,
	ROUND(AVG(price_usd),2) price,
	ROUND(SUM(price_usd),2) total_revenue
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
GROUP BY 
	oi.product_id,
	product_name
ORDER BY total_revenue DESC