USE sales_db;

SELECT * FROM sales;

SELECT ad_id, agency, ROUND(100.00 * (clicks/impressions),2) AS ad_conversion, spend,
		DENSE_RANK() OVER(PARTITION BY agency ORDER BY spend DESC) AS advert_spend_rank
FROM adverts
WHERE spend > 0;

SELECT order_id, order_quantity, shipping_price,
		NTILE(4) OVER(PARTITION BY order_quantity ORDER BY shipping_price) AS logistics_basket
FROM sales;
