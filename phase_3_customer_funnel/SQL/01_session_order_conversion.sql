-- Website Session to Order Conversion


USE ToyStoreEcommrce

CREATE VIEW [vw_session_order_conversion] AS
SELECT 
	order_id,
	o.website_session_id,
	o.user_id,
	ws.created_at session_created_at,
	o.created_at order_created_at,
	DATEDIFF(MINUTE, ws.created_at, o.created_at) [duration(mins)], 
	is_repeat_session,
	utm_source,
	utm_campaign,
	utm_content,
	device_type
FROM orders o
LEFT JOIN website_sessions ws
ON o.website_session_id = ws.website_session_id




-- Sessions to orders conversion rate over 2012 - 2015
CREATE VIEW [vw_session_order_conversion_rate] AS
SELECT 
	YEAR(ws.created_at) 'year',
	COUNT(ws.website_session_id) total_sessions,
	COUNT(o.website_session_id) total_orders,
	ROUND(
	CAST(COUNT(o.website_session_id)AS FLOAT) *100
	/COUNT(ws.website_session_id)
	,2) conversion_rate
FROM orders o
FULL JOIN website_sessions ws
ON o.website_session_id = ws.website_session_id
GROUP BY YEAR(ws.created_at)



