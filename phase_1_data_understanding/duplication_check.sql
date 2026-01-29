-- Duplication Check
USE ToyStoreEcommrce

-- orders Table
SELECT 
	order_id,
	COUNT(*)
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1
-- Result: 100% Unique IDs


-- order_items Table
SELECT 
	order_item_id,
	COUNT(*)  
FROM order_items
GROUP BY order_item_id
HAVING COUNT(*) > 1
-- Result: 100% Unique IDs


-- order_item_refunds Table
SELECT 
	order_item_refund_id,
	COUNT(*)
FROM order_item_refunds
GROUP BY order_item_refund_id
HAVING COUNT(*) > 1
-- Result: 100% Unique IDs


-- website_pageviews Table
SELECT 
	website_pageview_id,
	COUNT(*)
FROM website_pageviews
GROUP BY website_pageview_id
HAVING COUNT(*) > 1
-- Result: 100% Unique IDs


-- website_sessions Table 
SELECT 
	website_session_id,
	COUNT(*)
FROM website_sessions
GROUP BY website_session_id
HAVING COUNT(*) > 1
-- Result: 100% Unique IDs

