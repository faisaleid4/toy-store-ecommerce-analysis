-- Analysis 3: Product Profitability

-- Profitability by Product

USE ToyStoreEcommrce


SELECT 
	oi.product_id,
	product_name,
	ROUND(SUM(price_usd),2) total_revenue,
	ROUND(SUM(cogs_usd),2) total_cost,
	ROUND(SUM(price_usd) - SUM(cogs_usd),2) AS total_product_profit,
	SUM(ROUND(SUM(price_usd - cogs_usd),2)) OVER() total_profit,
	ROUND(
		(SUM(price_usd - cogs_usd)*100)/SUM(price_usd),
		2
		)  profit_margin,
	ROUND(((SUM(price_usd) - SUM(cogs_usd))/SUM((SUM(price_usd) - SUM(cogs_usd))) OVER())*100, 2) '% contribution'
FROM order_items oi
LEFT JOIN products p
ON oi.product_id = p.product_id
GROUP BY 
	oi.product_id,
	product_name
ORDER BY oi.product_id