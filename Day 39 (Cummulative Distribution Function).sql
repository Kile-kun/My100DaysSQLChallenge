USE sales_db;
SELECT * FROM sales;
SELECT * FROM adverts;

-- Cummulated Distribution of Revenue Generated on Order Quantity
SELECT order_quantity, SUM(revenue) AS total_rev_gen, 
CUME_DIST() OVER(ORDER BY order_quantity ASC) AS cumm_dist
FROM sales
GROUP BY order_quantity;

-- Cummulative Distribution of Monthly Advert Expenditure
SELECT MONTH(ad_date) AS ad_month, SUM(spend) AS total_ad_expenditure, 
CUME_DIST() OVER(ORDER BY MONTH(ad_date) ASC) AS cumm_dist
FROM adverts
GROUP BY MONTH(ad_date);