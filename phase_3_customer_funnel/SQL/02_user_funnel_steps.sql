-- Customers Pruchasing Funnel Steps

USE ToyStoreEcommrce

CREATE VIEW [vw_user_funnel_steps] AS 
SELECT 
	order_id,
	o.website_session_id,
	o.user_id,
	website_pageview_id,
	wp.created_at page_enterance,
	LEAD(wp.created_at,1) OVER(PARTITION BY order_id ORDER BY website_pageview_id) page_exit,
	pageview_url,
	ISNULL(
		DATEDIFF(
			MINUTE,wp.created_at,
			LEAD(wp.created_at,1) OVER(PARTITION BY order_id ORDER BY website_pageview_id)
			),0) duration,
	utm_source,
	utm_campaign,
	utm_content
FROM orders o
LEFT JOIN website_pageviews wp
ON o.website_session_id = wp.website_session_id
LEFT JOIN website_sessions ws
ON o.website_session_id = ws.website_session_id


