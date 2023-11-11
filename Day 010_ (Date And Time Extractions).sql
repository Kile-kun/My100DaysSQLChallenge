
-- DAY 10 (DATE AND TIME EXTRACTIONS)
USE sales_db;

--Get the Monthly Average Spend on adverts
SELECT CONCAT(MONTH(ad_date), '-', MONTHNAME (ad_date)) AS ad_month,
SUM(spend) AS total_ad_spend
FROM adverts
GROUP BY ad_month;

--How Much on the average does the business spend on shipping product to customers daily? SELECT CONCAT(WEEKDAY(order_date), '-', DAYNAME(order_date)) AS sales_day,
AVG(shipping_cost) AS avg_shipping
FROM sales
GROUP BY sales_day
ORDER BY sales_day;