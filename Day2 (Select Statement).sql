-- DAY 2 (Select Statement)
-- Retrieve all the columns of the tables in the sales database

USE sales_db;
-- adverts table
SELECT * FROM adverts;
SELECT * FROM calender;
SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM sales;

-- SELECT SOME COLUMNS OF THE TABLES
-- Retrieve details and figures of each advert conducted by the business
SELECT ad_id, ad_date, impressions, clicks, spend
FROM adverts;

-- Return the customer and region where they patronize the business
SELECT customer_name, region
FROM customers;

-- Retrieve the product name on the shelf of the business
SELECT product_name
FROM products;