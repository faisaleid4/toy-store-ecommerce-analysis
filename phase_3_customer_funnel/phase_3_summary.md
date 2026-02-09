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

### Phase 3.2 – Python Analysis
for further analysis, I utilized Python to perform a detailed examination of drop-off rates at various stages of the purchase funnel, to compare the behavior of converted versus non-converted sessions and finally to validate findings and insights that were optained by SQL. in the comming lines I will outline the key steps and findings from this analysis.

#### Drop-off Rate Analysis
I began by loading the website pageviews data into a pandas DataFrame. I then calculated the drop-off rates by identifying the last page visited in each session and counting how many sessions ended on each page. This allowed me to determine where customers were most likely to abandon the purchase process. Key steps included:
* Identifying the last page visited in each session.
* Calculating the number of sessions that dropped off at each page.
* Calculating drop-off rates based on page visits and total sessions.
* Merging the results into a single DataFrame for analysis.
* Sorting the drop-off rates to identify critical points in the funnel.
  
Kindly check notebook python file: [funnel_analysis.ipynb](Python/funnel_analysis.ipynb)

#### Converted vs Non-converted Sessions Behavior Comparison
I then compared the behavior of sessions that resulted in orders (converted) versus those that did not (non-converted). This involved:
* Loading the orders and website sessions data.
* Creating separate DataFrames for converted and non-converted sessions.
* Analyzing key metrics such as:
    *  session count, 
    *  repeat sessions, 
    *  average session duration, 
    *  average number of pages visited, 
	*  device type distribution (mobile vs desktop).
	*  Calculating percentages and averages to highlight differences in behavior between the two groups.
* Presenting the findings in a clear and concise manner.

Kindly check notebook python file: [behavior_comparison.ipynb](Python/behavior_comparsion.ipynb)

#### SQL Findings Validation
To ensure the accuracy of the insights obtained from the SQL analysis, I performed a validation process using Python. This involved replicating the SQL queries in Python and comparing the results to confirm consistency. The key steps included:
* Loading the relevant data tables into pandas DataFrames.
* Performing the same aggregations and calculations as in the SQL queries using pandas functions.
* Comparing the results from Python with those obtained from SQL to confirm that they match, thereby validating the findings.
* Documenting the validation process and results to provide confidence in the accuracy of the insights derived from the SQL analysis.  

This validation process is crucial to ensure that the insights we are basing our decisions on are accurate and reliable, and it helps to identify any discrepancies that may arise from differences in data handling between SQL and Python.

Kindly check notebook python file: [sql_findings_validation.ipynb](Python/sql_findings_validation.ipynb)


#### Findings Summary
The analysis revealed several key insights into customer behavior and conversion rates:
1. **Drop-off Rates**: The highest drop-off rates were observed on the product detail pages and the shopping cart page, indicating that customers may be encountering issues or hesitations at these stages of the funnel.
2. **Converted vs Non-converted Sessions**: Converted sessions had a significantly higher average session duration and a greater number of pages visited compared to non-converted sessions. Additionally, converted sessions were more likely to be repeat sessions, suggesting that returning customers are more likely to complete a purchase.
3. **Device Type Distribution**: A higher percentage of converted sessions were conducted on desktop devices compared to mobile devices, indicating that customers may prefer to complete purchases on desktop platforms.
4. **SQL Validation**: The results obtained from the SQL analysis were successfully validated using Python, confirming the accuracy of the insights derived from the SQL queries.
5. **Conversion Rates**: The conversion rates from sessions to orders varied across different years, with a noticeable increase in conversion rates in the later years, suggesting improvements in the website or marketing strategies over time.  

Overall, these findings provide valuable insights into customer behavior and highlight areas for potential improvement in the purchase funnel to increase conversion rates.


#### Next Phase: Phase 4 – Excl Analysis
In the next phase, we will focus on performing an EXCL analysis to further explore customer behavior and conversion patterns. This will involve using Excel to create pivot tables, charts, and perform additional calculations to gain deeper insights into the data. We will also look into segmenting customers based on various attributes such as demographics, purchase history, and behavior to identify specific trends and opportunities for targeted marketing strategies. The EXCL analysis will complement our SQL and Python findings and provide a more comprehensive understanding of the customer funnel.




