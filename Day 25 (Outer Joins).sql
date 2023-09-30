
-- DAY 25 (OUTER JOINS)

/* Return the entire rows and column from the customers and card orders table for American Express*/
SELECT *
FROM customers cu
FULL JOIN card_orders co
ON cu.id = co.order_id;

/* Given shopify_carriers and shopify_order table of shopify Watabaaequery to access all entries of the shopify carriers and matchingof the shopify orders*/
SELECT *
FROM shopify_carriers sc
LEFT JOIN shopify_orders so
ON sc.id = so.order_id;

/* Salesforce asked to write queries that return the entire columns offie sales table combined with the 
matching columns of the product*/
SELECT 
FROM dim_product dp
RIGHT JOIN fct_customer_sales fc
ON dp.prod_sku_id = fc.prod_sku_id;