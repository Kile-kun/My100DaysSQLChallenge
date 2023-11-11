DROP DATABASE IF EXISTS balanced_tree;

CREATE DATABASE balanced_tree;

USE balanced_tree;

-- product hierarchy table
CREATE TABLE product_hierarchy (
	id INTEGER,
	parent_id INTEGER,
	level_text VARCHAR(19),
	level_name VARCHAR(8)
);


-- Load data into table
SET
	GLOBAL LOCAL_INFILE = true;

LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Materials/Dataset/Day70-72 (SQL Case Study7)- product_hierarchy.csv' INTO TABLE product_hierarchy FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- product prices table
CREATE TABLE product_prices (
	id INTEGER,
	product_id VARCHAR(6),
	price INTEGER
);

-- Load data into table
SET
	GLOBAL LOCAL_INFILE = true;

LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Materials/Dataset/Day70-72 (SQL Case Study7)- product_prices.csv' INTO TABLE product_prices FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- product details table
CREATE TABLE product_details (
	product_id VARCHAR(6),
	price INTEGER,
	product_name VARCHAR(32),
	category_id INTEGER,
	segment_id INTEGER,
	style_id INTEGER,
	category_name VARCHAR(6),
	segment_name VARCHAR(6),
	style_name VARCHAR(19)
);

-- Load data into table
SET
	GLOBAL LOCAL_INFILE = true;

LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Materials/Dataset/Day70-72 (SQL Case Study7)- product_details.csv' INTO TABLE product_details FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- sales table
DROP TABLE IF EXISTS balanced_tree.sales;

USE balanced_tree;

CREATE TABLE sales (
	prod_id VARCHAR(6),
	qty INTEGER,
	price INTEGER,
	discount INTEGER,
	member ENUM('t', 'f'),
	txn_id VARCHAR(6),
	start_txn_time DATETIME
);

-- Load data into table
SET
	GLOBAL LOCAL_INFILE = true;

LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/MDATA Trainings/Soft Skills Training/Microsoft Word/Linkedin Strategy/100daysofSQL/Materials/Dataset/Day70-72 (SQL Case Study7)- sales.csv' INTO TABLE balanced_tree.sales FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

SELECT
	MONTH(start_txn_time)
FROM
	balanced_tree.sales;
    
SELECT * FROM product_hierarchy;
SELECT * FROM product_details;
SELECT * FROM product_prices;
SELECT * FROM sales;


-- 1. High Level Sales Analysis
-- 1a. What was the total quantity sold for all products?
SELECT SUM(qty) AS total_quantity_sold
FROM sales;

-- 1b. What is the total generated revenue for all products before discounts?
SELECT SUM(qty * price) AS revenue_before_discount
FROM sales;

-- 1c. What was the total discount amount for all products?
SELECT SUM(discount) AS total_discount
FROM sales;

-- 2. Transaction Analysis

-- 2a. How many unique transactions were there?
SELECT COUNT(DISTINCT txn_id) AS total_txns
FROM sales;

-- 2b. What is the average unique products purchased in each transaction?
WITH txn_per_product AS (
					SELECT txn_id, COUNT(DISTINCT prod_id) AS num_of_products
					FROM sales
					GROUP BY txn_id)
SELECT AVG(num_of_products) AS avg_uniq_prod_per_txn
FROM txn_per_product;

-- 2c. What are the 25th, 50th and 75th percentile values for the revenue per transaction?
WITH rev_per_txn AS (
					SELECT txn_id, ROUND(AVG((qty * price) - (discount)), 2) AS avg_revenue
					FROM sales
					GROUP BY txn_id),
	perc_avg_rev AS (
					SELECT avg_revenue, NTILE(100) OVER(ORDER BY avg_revenue) AS buckets
					FROM rev_per_txn)
SELECT buckets AS percentile, MAX(avg_revenue) AS revenue
FROM perc_avg_rev
WHERE buckets IN (25, 50, 75)
GROUP BY buckets;

-- 2d. What is the average discount value per transaction?
SELECT ROUND(AVG(discount), 2) AS avg_disc
FROM sales;

-- 2e. What is the percentage split of all transactions for members vs non-members?
WITH member_txn_count AS (
						SELECT COUNT(DISTINCT(txn_id)) AS tot_txns,
								(SELECT COUNT(DISTINCT(CASE WHEN member = 't' THEN txn_id END))
								FROM sales) AS t_cust_txns,
								(SELECT COUNT(DISTINCT(CASE WHEN member = 'f' THEN txn_id END))
								FROM sales) AS f_cust_txns
						FROM sales)
SELECT ROUND((100.00 * (t_cust_txns / tot_txns)), 2) AS perc_tcust_txns,
		ROUND((100.00 *(f_cust_txns / tot_txns)), 2) AS perc_fcust_txns
FROM member_txn_count;

-- 2f. What is the average revenue for member transactions and non-member transactions?
SELECT member, ROUND(AVG((qty * price) - discount), 2) AS avg_revenue
FROM sales
GROUP BY member;

-- 3. Product Analysis
-- 3a. What are the top 3 products by total revenue before discount?
SELECT pd.product_name,
		SUM(sl.qty * sl.price) AS rev_pre_discount
FROM product_details pd
JOIN sales sl ON pd.product_id = sl.prod_id
GROUP BY pd.product_name
ORDER BY rev_pre_discount DESC
LIMIT 3;

--	3b.	What is the total quantity, revenue and discount for each segment?
SELECT pd.segment_name, SUM(sl.qty) AS tot_qty,
		SUM((sl.qty * sl.price) - sl.discount) AS tot_rev, SUM(sl.discount) AS tot_disc
FROM product_details pd
JOIN sales sl ON pd.product_id = sl.prod_id
GROUP BY pd.segment_name
ORDER BY pd.segment_name;

--	3c.	What is the top selling product for each segment?
WITH prod_seg_sales AS (
					SELECT pd.segment_name, pd.product_name, SUM(sl.qty) AS tot_qty
					FROM product_details pd
					JOIN sales sl ON pd.product_id = sl.prod_id
					GROUP BY pd.segment_name, pd.product_name),
	prod_seg_ranking AS (
					SELECT *,
							DENSE_RANK() OVER(PARTITION BY segment_name ORDER BY tot_qty DESC) AS ranking
					FROM prod_seg_sales)
SELECT product_name, segment_name, tot_qty
FROM prod_seg_ranking
WHERE ranking = 1;

--	3d.	What is the total quantity, revenue and discount for each category?
SELECT pd.category_name, SUM(sl.qty) AS tot_qty, 
		SUM((sl.qty * sl.price) - sl.discount) AS tot_rev, SUM(sl.discount) AS tot_disc
FROM product_details pd
JOIN sales sl ON pd.product_id = sl.prod_id
GROUP BY pd.category_name
ORDER BY pd.category_name;

--	3e.	What is the top selling product for each category?
WITH prod_cat_sales AS (
					SELECT pd.category_name, pd.product_name, SUM(sl.qty) AS tot_qty
					FROM product_details pd
					JOIN sales sl ON pd.product_id = sl.prod_id
					GROUP BY pd.category_name, pd.product_name),
	prod_cat_ranking AS (
					SELECT *,
							DENSE_RANK() OVER(PARTITION BY category_name ORDER BY tot_qty DESC) AS ranking
					FROM prod_cat_sales)
SELECT category_name, product_name, tot_qty
FROM prod_cat_ranking
WHERE ranking = 1;

--	3f.	What is the percentage split of revenue by product for each segment?
WITH seg_prod_rev AS (
				SELECT pd.segment_name, pd.product_name,
						SUM((sl.qty * sl.price) -(sl.discount)) AS tot_rev
				FROM product_details pd
				JOIN balanced_tree.sales sl ON pd.product_id = sl.prod_id
				GROUP BY pd.segment_name, pd.product_name)
SELECT *,
		ROUND(100.00 * (SUM(tot_rev)) /(SUM(tot_rev) OVER(PARTITION BY segment_name)),2) AS perc_seg_rev
FROM seg_prod_rev
GROUP BY segment_name, product_name
ORDER BY segment_name, product_name, perc_seg_rev;

--	3g.	What is the percentage split of revenue by segment for each category?
WITH cat_seg_rev AS (
				SELECT pd.category_name, pd.segment_name,
						SUM((sl.qty * sl.price) -(sl.discount)) AS tot_rev
				FROM product_details pd
				JOIN balanced_tree.sales sl ON pd.product_id = sl.prod_id
				GROUP BY pd.category_name, pd.segment_name)
SELECT *,
		ROUND(100.00 * (SUM(tot_rev)) /(SUM(tot_rev) OVER(PARTITION BY category_name)),2) AS perc_cat_rev
FROM cat_seg_rev
GROUP BY category_name, segment_name
ORDER BY category_name, segment_name, perc_cat_rev;

--	3h.	What is the percentage split of total revenue by category?
SELECT pd.category_name,
		SUM((sl.qty * sl.price) -(sl.discount)) AS tot_rev,
		ROUND((100.00 * (SUM((sl.qty * sl.price) -(sl.discount))) 
							/
		(SELECT SUM((qty * price) -(discount))
		FROM sales)),2) 
					AS perc_cat_rev
FROM product_details pd
JOIN sales sl ON pd.product_id = sl.prod_id
GROUP BY pd.category_name;

-- 3i.	What is the total transaction “penetration” for each product? 
-- (hint: penetration = number of transactions where at least 1 quantity of a 
-- product was purchased divided by total number of transactions)
SELECT pd.product_name,
		ROUND(100.00 * (COUNT(DISTINCT sl.txn_id) 
							/ 
		(SELECT COUNT(DISTINCT txn_id)
		FROM sales)),2) 
					AS tot_penetration
FROM product_details pd
JOIN sales sl ON pd.product_id = sl.prod_id
WHERE sl.qty > 1
GROUP BY pd.product_name;

-- 3j.	What is the most common combination of at least 1 quantity of any 3 products in a 1 single transaction?
WITH txn_prod_counts AS (
					SELECT sl.txn_id, pd.product_name,
							SUM(sl.qty) AS total_quantity
					FROM sales sl
					JOIN product_details pd ON sl.prod_id = pd.product_id
					GROUP BY sl.txn_id, pd.product_name
					HAVING total_quantity >= 1)
SELECT 	p1.product_name AS product1, p2.product_name AS product2,
		p3.product_name AS product3, COUNT(*) AS txn_prod_counts
FROM txn_prod_counts p1
INNER JOIN txn_prod_counts p2 ON p1.txn_id = p2.txn_id AND p1.product_name > p2.product_name
INNER JOIN txn_prod_counts p3 ON p2.txn_id = p3.txn_id AND p2.product_name > p3.product_name
GROUP BY product1, product2, product3
ORDER BY txn_prod_counts DESC
LIMIT 1;

/*4. Reporting Challenge
 Write a single SQL script that combines all of the previous questions into a scheduled 
 report that the Balanced Tree team can run at the beginning of each month to calculate 
 the previous month’s values. Imagine that the Chief Financial Officer has asked for all 
 of these questions at the end of every month. He first wants you to generate the data for 
 January only - but then he also wants you to demonstrate that you can easily run the same 
 analysis for February without many changes (if at all). Feel free to split up your final 
 outputs into as many tables as you need - but be sure to explicitly reference which table 
 outputs relate to which question for full marks :)*/
 
 -- 4a. For Sales Performance
DROP TABLE IF EXISTS sales_performance;
CREATE TABLE sales_performance AS 
WITH 
sp1 AS (SELECT MONTH(start_txn_time) AS sl_mnth,
					SUM(qty) AS tot_qty_sold,
					LAG(SUM(qty)) OVER(ORDER BY MONTH(start_txn_time)) AS prev_tqs,
					SUM(qty * price) AS rev_prior_disc,
					LAG(SUM(qty * price)) OVER(ORDER BY MONTH(start_txn_time)) AS prev_rpd, 
					SUM(discount) AS tot_disc,
					LAG(SUM(discount)) OVER(ORDER BY MONTH(start_txn_time)) AS prev_td,
					COUNT(DISTINCT txn_id) AS tot_txn,
					LAG(COUNT(DISTINCT txn_id)) OVER(ORDER BY MONTH(start_txn_time)) AS prev_tt,
                    ROUND(AVG(discount), 2) AS avg_disc,
                    LAG(ROUND(AVG(discount), 2)) OVER(ORDER BY MONTH(start_txn_time)) AS prev_ad
		FROM sales
		GROUP BY MONTH(start_txn_time)),
sp2 AS (SELECT sl_mnth, 
				ROUND(AVG(num_of_products),2) AS uniq_prod_p_txn,
				LAG(ROUND(AVG(num_of_products),2)) OVER(ORDER BY sl_mnth) AS prev_uppt
		FROM 	(SELECT MONTH(start_txn_time) AS sl_mnth,
						txn_id, COUNT(DISTINCT prod_id) AS num_of_products
				FROM sales
				GROUP BY txn_id, MONTH(start_txn_time)) AS txn_per_product
		GROUP BY sl_mnth),
sp3 AS (WITH rev_per_txn AS (
							SELECT txn_id, MONTH(start_txn_time) AS sl_mnth,
									ROUND(AVG((qty * price) - (discount)), 2) AS avg_revenue
							FROM balanced_tree.sales
							GROUP BY txn_id, MONTH(start_txn_time)),
			perc_avg_rev AS (
							SELECT sl_mnth, avg_revenue, 
									NTILE(100) OVER(PARTITION BY sl_mnth ORDER BY avg_revenue) AS buckets
							FROM rev_per_txn),
			month_perc_rev AS (
							SELECT sl_mnth, MAX(CASE WHEN buckets = 25 THEN avg_revenue END) AS "lq_rev",
									MAX(CASE WHEN buckets = 50 THEN avg_revenue END) AS "mid_rev",
									MAX(CASE WHEN buckets = 75 THEN avg_revenue END) AS "uq_rev"
							FROM perc_avg_rev
							WHERE buckets IN (25, 50, 75)
							GROUP BY sl_mnth
							ORDER BY sl_mnth)
		SELECT sl_mnth, lq_rev, LAG(lq_rev) OVER(ORDER BY sl_mnth) AS prev_lqr,
				mid_rev, LAG(mid_rev) OVER(ORDER BY sl_mnth) AS prev_mdr,
				uq_rev, LAG(uq_rev) OVER(ORDER BY sl_mnth) AS prev_uqr
		FROM month_perc_rev),
sp4 AS (WITH membernonmember_txn AS (
							SELECT 
									MONTH(start_txn_time) AS sl_mnth,
									COUNT(DISTINCT txn_id) AS tot_txns,
									ROUND(SUM((qty * price) - discount), 2) AS tot_rev,
									COUNT(DISTINCT CASE WHEN member = 't' THEN txn_id END) AS mem_txns,
									ROUND(SUM(CASE WHEN member = 't' THEN (qty * price) - discount ELSE 0 END), 2) AS mem_rev,
									COUNT(DISTINCT CASE WHEN member = 'f' THEN txn_id END) AS nmem_txns,
									ROUND(SUM(CASE WHEN member = 'f' THEN (qty * price) - discount ELSE 0 END), 2) AS nmem_rev
							FROM sales
							GROUP BY MONTH(start_txn_time)
							ORDER BY MONTH(start_txn_time))
		SELECT sl_mnth, ROUND((mem_txns/nmem_txns), 2) AS mnm_txn_ratio,
				LAG(ROUND((mem_txns/nmem_txns), 2)) OVER(ORDER BY sl_mnth) AS prev_mnmt_ratio,
                ROUND((mem_rev/nmem_rev),2) AS mnm_rev_ratio,
                LAG(ROUND((mem_rev/nmem_rev), 2)) OVER(ORDER BY sl_mnth) AS prev_mnmr_ratio
		FROM membernonmember_txn)
SELECT sp1.sl_mnth, sp1.tot_qty_sold, sp1.prev_tqs, sp1.rev_prior_disc, sp1.prev_rpd, sp1.tot_disc,
		sp1.prev_td, sp1.tot_txn, sp1.prev_tt, sp1.avg_disc, sp1.prev_ad, sp2.uniq_prod_p_txn, sp2.prev_uppt,
        sp3.lq_rev, sp3.prev_lqr, sp3.mid_rev, sp3.prev_mdr, sp3.uq_rev, sp3.prev_uqr,
        sp4.mnm_txn_ratio, sp4.prev_mnmt_ratio, sp4.mnm_rev_ratio, sp4.prev_mnmr_ratio
FROM sp1
JOIN sp2 ON sp1.sl_mnth = sp2.sl_mnth
JOIN sp3 ON sp2.sl_mnth = sp3.sl_mnth
JOIN sp4 ON sp3.sl_mnth = sp4.sl_mnth;
SELECT * FROM sales_performance;

-- 4b. For Product Performance1
-- 4bi. 
DROP TABLE product_performance1;
CREATE TABLE product_performance1 AS 
WITH pp1 AS (WITH ranked_products AS (
						SELECT MONTH(sl.start_txn_time) AS sl_mnth, pd.product_name, SUM(sl.qty * sl.price) AS monthly_rev,
								DENSE_RANK() OVER (PARTITION BY MONTH(sl.start_txn_time) ORDER BY SUM(sl.qty * sl.price) DESC) AS prod_rank
						FROM product_details pd
						JOIN sales sl ON pd.product_id = sl.prod_id
						GROUP BY MONTH(sl.start_txn_time), pd.product_name)
				SELECT sl_mnth, GROUP_CONCAT(product_name ORDER BY monthly_rev DESC) AS top_3prod,
							LAG(GROUP_CONCAT(product_name ORDER BY monthly_rev DESC)) OVER (ORDER BY sl_mnth) AS prev_t3p
				FROM ranked_products
				WHERE prod_rank <= 3
				GROUP BY sl_mnth
				ORDER BY sl_mnth),
	pp2 AS 	(WITH txn_prod_counts AS (
							SELECT MONTH(sl.start_txn_time) AS sl_mnth, sl.txn_id, pd.product_name,
									SUM(sl.qty) AS total_quantity
							FROM sales sl
							JOIN product_details pd ON sl.prod_id = pd.product_id
							GROUP BY MONTH(sl.start_txn_time), sl.txn_id, pd.product_name
							HAVING total_quantity >= 1
							ORDER BY sl_mnth, total_quantity DESC),
				prod_comb_rank AS (SELECT p1.sl_mnth, CONCAT(p1.product_name, ', ' , p2.product_name, ', ', p3.product_name) AS prod_combinations, COUNT(*) AS txn_prod_counts,
											DENSE_RANK() OVER(PARTITION BY p1.sl_mnth ORDER BY COUNT(*) DESC) AS comb_rank
									FROM txn_prod_counts p1
									INNER JOIN txn_prod_counts p2 ON p1.txn_id = p2.txn_id AND p1.product_name > p2.product_name
									INNER JOIN txn_prod_counts p3 ON p2.txn_id = p3.txn_id AND p2.product_name > p3.product_name
									GROUP BY p1.sl_mnth, CONCAT(p1.product_name, ', ' , p2.product_name, ', ', p3.product_name)
									ORDER BY p1.sl_mnth, txn_prod_counts DESC)
				SELECT sl_mnth, prod_combinations AS top_product_combination_orders, txn_prod_counts
				FROM prod_comb_rank
				WHERE comb_rank = 1
				ORDER BY sl_mnth)
SELECT 	pp1.sl_mnth, pp1.top_3prod,
		pp2.top_product_combination_orders, pp2.txn_prod_counts
FROM pp1
JOIN pp2 ON pp1.sl_mnth = pp2.sl_mnth;
SELECT * FROM product_performance1;

-- 4bii.
DROP TABLE product_performance2;
CREATE TABLE product_performance2 AS
WITH pp1 AS (SELECT
					MONTH(sl.start_txn_time) AS sl_mnth, pd.segment_name,
					SUM(sl.qty) AS tot_qty, SUM((sl.qty * sl.price) - sl.discount) AS tot_rev, SUM(sl.discount) AS tot_disc
			FROM product_details pd
			JOIN sales sl ON pd.product_id = sl.prod_id
			GROUP BY MONTH(sl.start_txn_time), pd.segment_name
			ORDER BY sl_mnth),
pp2 AS 		(WITH prod_seg_sales AS (
						SELECT MONTH(sl.start_txn_time) AS sl_mnth, pd.segment_name, pd.product_name, SUM(sl.qty) AS prod_tot_qty
						FROM product_details pd
                        JOIN sales sl ON pd.product_id = sl.prod_id
                        GROUP BY MONTH(sl.start_txn_time), pd.segment_name, pd.product_name),
			prod_seg_ranking AS (
						SELECT *, DENSE_RANK() OVER(PARTITION BY segment_name, sl_mnth ORDER BY prod_tot_qty DESC) AS ranking
						FROM prod_seg_sales)
			SELECT sl_mnth, segment_name, product_name, prod_tot_qty
			FROM prod_seg_ranking
			WHERE ranking = 1
			ORDER BY sl_mnth),
pp3 AS (WITH seg_rev AS (
				SELECT MONTH(sl.start_txn_time) AS sl_mnth, pd.segment_name, SUM((sl.qty * sl.price) -(sl.discount)) AS tot_rev
				FROM product_details pd
				JOIN balanced_tree.sales sl ON pd.product_id = sl.prod_id
				GROUP BY MONTH(sl.start_txn_time), pd.segment_name)
		SELECT *,
			(ROUND(100.00 * ((tot_rev)) /SUM(tot_rev) OVER(PARTITION BY sl_mnth ORDER BY sl_mnth),2)) AS perc_seg_rev
		FROM seg_rev
		GROUP BY sl_mnth, segment_name
		ORDER BY sl_mnth, segment_name, perc_seg_rev)
SELECT pp1.sl_mnth, pp1.segment_name, pp1.tot_qty, pp1.tot_rev, pp1.tot_disc, 
		pp2.product_name AS top_prod, pp2.prod_tot_qty AS top_prod_order_tot_qty,
        pp3.perc_seg_rev
FROM pp1
LEFT JOIN pp2 ON pp1.segment_name = pp2.segment_name AND pp1.sl_mnth = pp2.sl_mnth
JOIN pp3 ON pp2.segment_name = pp3.segment_name AND pp2.sl_mnth = pp3.sl_mnth
ORDER BY sl_mnth;
SELECT * FROM product_performance2;

-- 4biii. For Product Performance3 (Monthly Product Penetration)
DROP TABLE product_performance3;
CREATE TABLE product_performance3 AS
SELECT MONTH(start_txn_time) AS sl_mnth, pd.product_name,
		ROUND(100.00 * (COUNT(DISTINCT sl.txn_id) 
							/ 
		(SELECT COUNT(DISTINCT txn_id)
		FROM sales)),2) 
					AS tot_penetration
FROM product_details pd
JOIN sales sl ON pd.product_id = sl.prod_id
WHERE sl.qty > 1
GROUP BY MONTH(start_txn_time), pd.product_name
ORDER BY sl_mnth;
SELECT * FROM product_performance3;

-- 4c. For Category (Gender) Revenue Performance
DROP TABLE gender_revenue_performance;
CREATE TABLE gender_revenue_performance AS 
WITH grp1 AS (WITH cat_seg_rev AS (
					SELECT MONTH(sl.start_txn_time) AS sl_mnth, pd.category_name, pd.segment_name,
							SUM((sl.qty * sl.price) - (sl.discount)) AS tot_rev
					FROM product_details pd
					JOIN sales sl ON pd.product_id = sl.prod_id
					GROUP BY MONTH(sl.start_txn_time), pd.category_name, pd.segment_name)
				SELECT *, ROUND(100.00 * (SUM(tot_rev)) /(SUM(tot_rev) OVER(PARTITION BY category_name)),2) AS perc_cat_rev
				FROM cat_seg_rev
				GROUP BY sl_mnth, category_name, segment_name
				ORDER BY sl_mnth, perc_cat_rev DESC),
	grp2 AS (WITH gender_rev_contribtn AS (
					SELECT
						MONTH(sl.start_txn_time) AS sl_mnth, pd.category_name,
                        SUM(sl.qty) AS tot_qty_contributn,
                        SUM(sl.discount) AS tot_discnt_awarded,
						SUM((sl.qty * sl.price) - (sl.discount)) AS tot_rev_contribtn
					FROM product_details pd
					JOIN sales sl ON pd.product_id = sl.prod_id
					GROUP BY sl_mnth, pd.category_name
					ORDER BY sl_mnth)
			SELECT *, ROUND(100.00 * (tot_rev_contribtn/(SUM(tot_rev_contribtn) OVER(PARTITION BY sl_mnth ORDER BY sl_mnth))),2) AS perc_gender_rev_contr
			FROM gender_rev_contribtn
			GROUP BY sl_mnth, category_name),
grp3 AS (WITH prod_cat_sales AS (
					SELECT MONTH(sl.start_txn_time) AS sl_mnth, pd.category_name, 
						pd.product_name, SUM(sl.qty) AS tot_qty
					FROM product_details pd
					JOIN sales sl ON pd.product_id = sl.prod_id
					GROUP BY sl_mnth, pd.category_name, pd.product_name),
			prod_cat_ranking AS (
					SELECT *,
						DENSE_RANK() OVER (PARTITION BY sl_mnth, category_name ORDER BY tot_qty DESC) AS ranking
					FROM prod_cat_sales)
		SELECT sl_mnth, category_name, product_name, tot_qty
		FROM prod_cat_ranking
		WHERE ranking = 1
		ORDER BY sl_mnth, category_name, tot_qty DESC)
SELECT grp1.sl_mnth, grp1.category_name, grp2.tot_rev_contribtn, grp2.tot_qty_contributn, 
		grp2.tot_discnt_awarded, grp2.perc_gender_rev_contr, grp3.product_name, grp3.tot_qty,
		grp1.segment_name, grp1.tot_rev, grp1.perc_cat_rev
FROM grp2
LEFT JOIN grp1 ON grp1.sl_mnth = grp2.sl_mnth AND grp1.category_name = grp2.category_name
JOIN grp3 ON grp2.sl_mnth = grp3.sl_mnth AND grp2.category_name = grp3.category_name
ORDER BY grp1.sl_mnth;
SELECT * FROM gender_revenue_performance;