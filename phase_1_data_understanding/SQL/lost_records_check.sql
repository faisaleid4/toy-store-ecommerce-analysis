-- Lost Records in Fact and Dimension tabels

-- orders, order_items and order_item_refunds tables

SELECT 
	oi.order_id,
	o.order_id
FROM orders o
FULL JOIN order_items oi
ON oi.order_id = o.order_id
WHERE 
	o.order_id IS NULL
	OR oi.order_id IS NULL
-- Result: no lost records

SELECT 
	oir.order_item_id,
	oi.order_item_id
FROM order_item_refunds oir
LEFT JOIN order_items oi
ON oir.order_item_id = oi.order_item_id
WHERE oi.order_item_id IS NULL
-- Result: no lost records


-- website_pageviews and website_session tabels
SELECT 
	wp.website_session_id, 
	ws.website_session_id
FROM website_pageviews wp
FULL JOIN  website_sessions ws
ON wp.website_session_id = ws.website_session_id
WHERE 
	wp.website_session_id IS NULL
	OR ws.website_session_id IS NULL
-- Result: no lost records
