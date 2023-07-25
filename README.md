# My100DaysSQLChallenge
Follow my 100-day journey of mastering SQL and exploring the powerful world of data manipulation and analysis. Each day, I'll be working on SQL problems, learning window functions, honing my query skills, and sharing my progress here. Join me as I dive into SQL magic, and together, let's conquer data challenges and unlock valuable insights! 

## DAY 0 (INTRODUCTION)
According to Malcolm Gladwell, he said, "It takes 10,000 hours to become an expert in anything.". According to the general opinion, SQL is one of the most important tools a data specialist Is meant to master (if not the most important). So, I am dedicating the next 100 days to solving different SQL problems. The problem will cover different SQL topics. The SQL tool I will majorly use throughout the challenge is MySQL and occasionally, I will pitch in different methods peculiar to other SQL tools like MSSQL and PostgreSQL.

<img width="786" alt="Malcom Gladwell" https://raw.githubusercontent.com/Kile-kun/My100DaysSQLChallenge/main/Others/Malcolm%20Gladwell.webp"

## DAY 1 (CREATING DATABASE, LOADING AND INSERTING DATA INTO TABLES)

## DAY 40 (PERCENTILE OF CONTINUOUS VALUE FUNCTION)
Percentile from statistics is used to explain how a value compares to the entire values of a population. It is normally expressed in whole numbers between 0 and 100. It has no universal definition, but it is used to express the percentage of numbers below the value. If for example, a student's exam score is the 75th percentile, it means he scores rank above 75% of the class.
In the context of SQL, the percentile function is of three types depending on what we aim to achieve.
**PERCENT_RANK:** This function is like that of CUME_DIST (). It calculates the relative rank of the current row within the result set. However, unlike CUME_DIST (), which returns a value from 0 to 1, PERCENT_RANK () returns a value from 0 to 1 inclusive, indicating the relative position of the current row concerning the total number of rows in the partition.

**PERCENTILE-CONT:** This function calculates the specified percentile (continuous value) for a group (partition) based on the specified ORDER BY clause. It returns the value that represents the specified percentile within each partition (i.e., what the value ought to be).

**PERCENTILE-DISC:** This function is used to calculate the discrete percentile value within a group (partition) based on the specified ordering. Unlike the PERCENTILE_CONT, it returns the actual value from the dataset that corresponds to the specified percentile.

Off all the three categories of Percentile functions, only PERCENT_RANK can be found  in MySQL, the remaining categories including the PERCENT_RANK are found in MSSQL.

