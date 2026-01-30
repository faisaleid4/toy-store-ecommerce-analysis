/* Analysis 4: Primary vs Secondary Items

Business Question:
	Do customers mainly buy one product or bundle items? 
*/

USE ToyStoreEcommrce


-- Primary vs Secondary Items

SELECT 
	is_primary_item,
	COUNT(order_item_id) items_count,
	ROUND(
		CAST(COUNT(order_item_id) AS float)/SUM(COUNT(order_item_id)) OVER() * 100
		, 2) 'percentage'
FROM order_items
GROUP BY is_primary_item



-- items count for each bundle size 

SELECT 
	items_purchased bundle_size,
	COUNT(order_item_id) items_count,
	ROUND(
		CAST(COUNT(order_item_id) AS float)/SUM(COUNT(order_item_id)) OVER() * 100
		, 2) 'percentage'
FROM order_items oi
LEFT JOIN orders o
ON oi.order_id = o.order_id
GROUP BY items_purchased