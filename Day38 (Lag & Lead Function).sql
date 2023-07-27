USE sales_db;
SELECT * FROM sales;
SELECT * FROM adverts;

-- LAG FUNCTION
SELECT MONTH(ad_date) AS ad_month, SUM(spend) AS total_ad_spend, 
		LAG(SUM(spend)) OVER(ORDER BY MONTH(ad_date) ASC) AS prev_month_ad_spend,
       ROUND(100.00 * ((SUM(spend)/LAG(SUM(spend)) OVER(ORDER BY MONTH(ad_date) ASC))-1),2) AS ad_budget_Performance
FROM adverts
GROUP BY ad_month;

-- LEAD FUNCTION
SELECT agency, MONTH(ad_date) AS ad_month, COUNT(agency) AS total_adverts,
		LEAD(COUNT(agency), 1, 0) OVER(PARTITION BY (MONTH(ad_date)) ORDER BY agency) AS nxt_mnth_tot_ad
FROM adverts
WHERE spend > 0
GROUP BY agency, MONTH(ad_date)
ORDER BY agency, ad_month;