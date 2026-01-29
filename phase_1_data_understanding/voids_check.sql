-- Voids Check ('NULL', blank spaces)

/* Note: NULL is not allowed in all columns in tabels in this database
		 So I will search for String 'NULL' or blank spaces in char or varchar data type columns */
		 
-- website_pageviews and website_session tables have nvarchar columns


-- website_pageviews Table
SELECT *
FROM website_pageviews
WHERE pageview_url = 'NULL'
	OR pageview_url = SPACE(LEN(pageview_url))
-- Result: No 'NULL' or blank spaces valuse


-- website_sessions Table
SELECT *
FROM website_sessions
WHERE  utm_source = 'NULL'
	OR utm_source = SPACE(LEN(utm_source))
	OR utm_campaign = 'NULL'
	OR utm_campaign = SPACE(LEN(utm_campaign))
	OR utm_content = 'NULL'
	OR utm_content = SPACE(LEN(utm_content))
	OR device_type = 'NULL'
	OR device_type = SPACE(LEN(device_type))
	OR http_referer = 'NULL'
	OR http_referer = SPACE(LEN(http_referer))
-- Result: 83,328 out of 472,871 rows contains one 'NULL' or balnk space value at leaset