-- Analysis 1: Product Sales Volume

-- Which product sells most units?

USE ToyStoreEcommrce

SELECT 
	oi.product_id,
	p.product_name,
	COUNT(oi.product_id) units_sold
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
GROUP BY 
	oi.product_id,
	p.product_name
ORDER BY units_sold DESC

