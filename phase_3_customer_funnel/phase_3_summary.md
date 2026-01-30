## Phase 3 – Customer & Conversion Funnel

Phase 3 focuses on understanding customer behavior, website sessions to orders conversion rate and user funnel steps. in this phase we will manipulate our data via multiple analytics tools based on analysis cases and business questions.

### Phase 3.1 – SQL Analysis

In this section we will perform SQL queries to create views and extract some insights from our data that will help us to understand customer behavior and conversion rates.

Using SQL, I created views to analyze the following:
- Website sessions to orders conversion
- Calculating conversion rates on annual basis
- Showing user funnel steps from session start to order completion

#### Website Sessions to Orders Conversion & Conversion Rate
To analyze the conversion from website sessions to orders, I created a SQL view that aggregates the number of sessions and the number of orders placed. The conversion rate is calculated by dividing the number of orders by the number of sessions.

```sql 
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
GROUP BY YEAR(ws.created_at);
```

The above SQL code creates two views:
1. `vw_session_order_convesion`: This view joins the `orders` and `website_sessions` tables to provide detailed information about each order and its corresponding session, including the duration between session creation and order creation.
2. `vw_session_order_conversion_rate`: This view calculates the conversion rate of sessions to orders on an annual basis from 2012 to 2015.

SQL file: [01_session_order_conversion.sql](SQL/01_session_order_conversion.sql)

#### User Funnel Steps
To analyze the user funnel steps, I created a SQL view that tracks the sequence of page views leading up to an order. This view captures the entry and exit times for each page view, the duration spent on each page, and relevant UTM parameters.

```sql
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
ON o.website_session_id = ws.website_session_id;
```

The above SQL code creates the `vw_user_funnel_steps` view, which provides insights into the user journey by tracking page views associated with each order. It includes details such as page entrance and exit times, duration spent on each page, and UTM parameters.

SQL file: [02_user_funnel_steps.sql](SQL/02_user_funnel_steps.sql)

