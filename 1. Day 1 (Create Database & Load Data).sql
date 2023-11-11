-- CREATE DATABASE
DROP DATABASE IF EXISTS sales_db;

CREATE DATABASE sales_db;

-- CREATE TABLES FOR THE DATABASE
USE sales_db;

CREATE TABLE customers (
					customer_id		INT 			NOT NULL,
					customer_name	VARCHAR (32),
					region			VARCHAR (32),
					customer_segment VARCHAR (32),
PRIMARY KEY (customer_id)
);

CREATE TABLE calender (
					date_id 		DATE 			NOT NULL,
PRIMARY KEY (date_id)
);

CREATE TABLE products (
					product_id		VARCHAR(16)		NOT NULL,
					product_name	VARCHAR(60)		NOT NULL,
					product_category VARCHAR(32)	NOT NULL,
PRIMARY KEY (product_id)
);

CREATE TABLE adverts (
					ad_id			VARCHAR(16)		NOT NULL,
					ad_date			DATE			NOT NULL,
					day_of_the_week	VARCHAR(16)		NOT NULL,
					hour_of_day		TIME 			NOT NULL,
					agency			VARCHAR (16)	NOT NULL,
					ad_size			VARCHAR (16),
					platform		TEXT,
					device_type		TEXT,
					ad_format		TEXT,
					impressions		INTEGER,
					clicks			INTEGER,
					spend			DECIMAL (10,2),
PRIMARY KEY (ad_id)
);

-- METHOD OF INSERTING VALUES INTO THE TABLES
-- METHOD I (Insert Method)
INSERT INTO adverts VALUES('ads10001', '2017-01-01', 'Sunday', '23:00', 'Ogly', '300x258', 'App', 'Mobile', 
							'Display', 265236, 580, 283);
                            
-- METHOD II (Load Infile Method)
SET GLOBAL LOCAL_INFILE = true;

LOAD DATA LOCAL INFILE 'C:/Users/babat/OneDrive/Desktop/Personal Projects/Sales Project/Datasets/adverts.csv'
INTO TABLE adverts
FIELDS TERMINATED BY ','
ENCLOSED BY '"' LINES
TERMINATED BY '\n'
IGNORE 1 ROWS;

-- METHOD III (Import and Export Wizard (For MSSQL))
	-- Right-click required database.
	-- Select Tasks.
	-- Select Import Flatfile


-- METHOD IV (Bulk Insert Method (For MSSQL))
BULK INSERT dbo.adverts
FROM 'C:/Users/babat/OneDrive/Desktop/Personal Projects/Sales Project/Datasets/adverts.csv'
WITH (FORMAT = 'CSV');