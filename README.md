# My100DaysSQLChallenge
Follow my 100-day journey of mastering SQL and exploring the powerful data manipulation and analysis world. Each day, I'll be working on SQL problems, learning window functions, honing my query skills, and sharing my progress here. Join me as I dive into SQL magic, and together, let's conquer data challenges and unlock valuable insights! 

## DAY 0 (INTRODUCTION)
According to Malcolm Gladwell, he said, "It takes 10,000 hours to become an expert in anything.". According to the general opinion, SQL is one of the most important tools a data specialist Is meant to master (if not the most important). So, I am dedicating the next 100 days to solving different SQL problems. The problem will cover different SQL topics. The SQL tool I will majorly use throughout the challenge is MySQL and occasionally, I will pitch in different methods peculiar to other SQL tools like MSSQL and PostgreSQL.

## DAY 1 (CREATING DATABASE, LOADING AND INSERTING DATA INTO TABLES)

## DAY 2 (SELECT STATEMENT)
It is the most basic and important function of an SQL Data Manipulation Language (DML). It is used to retrieve data from a database and to display it in a table.

## DAY 3 (WHERE CLAUSE)
The WHERE clause filter rows by a condition. It normally follows the SELECT and FROM Clauses. 
The condition is a Boolean expression that evaluates to TRUE or FALSE. If the condition is TRUE, the result set will include the row. If the condition is FALSE, the row will be excluded from the result set.
We are going to give special consideration to the basic Boolean operators like the Greater Than (>), Less than (<), and the Equals Sign (=). 
These operators are more effective for the Numerical Data Types (Numbers) which cover Integers, Decimals, and all that define only numeric.

## DAY 4 (WHERE CLAUSE WITH ADVANCE OPERATORS)
Another way to filter rows with WHERE condition is to use advanced operators like; the LIKE, BETWEEN, and IN operators. 
The LIKE operator filters table rows by searching for a specified pattern in a column. There are two wildcards often used in conjunction with the LIKE operator:
      1. %- Represents zero, one, or multiple characters.
      2. _: Represents one, single character.
The IN-operator filters rows by returning only specified values separated by commas. It can also be used to compare a value to a subquery.
The BETWEEN operator returns values within a specified range. 
Unlike LIKE and IN operators which are used for Strings, and Mixed of Strings and Integers Respectively, The Between Operation is specifically meant for Numeric Data types.

## DAY 5 (AND, OR & NOT OPERATORS)
When there is a need to combine multiple conditions in a query, The AND-OR-NOT operators are attached to join the conditions of the WHERE Clauses. 
      1. The AND operator returns rows that meet all the conditions,
      2. The OR operator returns rows that meet any of the conditions,
      3. The NOT operator returns rows that negate the conditions, it is attached to the ADVANCED OPERATORS (we discussed in DAY 4).

## DAY 6 (STRING OPERATORS AND FUNCTIONS)
To further perform operations on Columns with string data types, certain functions are used. They are very many with different purposes, but the most prominent among them include;
    1. CONCAT(): This joins (Concatenate) two or more columns together in a single string                    
    2. RIGHT():  This extracts a substring from the right side of a string
    3. LEFT(): This returns a substring from the left side of a string.
    4. MID(): Extract certain substring from a specified center of a string

## DAY 7 (GROUP BY AND AGGREGATE FUNCTIONS)
The GROUP BY and ORDER BY are one of the most integral clauses in SQL as you are most likely going to use them in your everyday analysis. 
The GROUP BY Clause is always applied to group rows with the same values as summary rows. This is often done to apply some sort of aggregate function to the data, such as 

    1. COUNT(): which Count the values of each row of similar items,
    2. MAX(): The Highest value of a grouped entity, 
    3. MIN(): The Lowest value of a grouped entity,
    4. SUM(): The addition of all values of the group, or
    5. AVG(): This is the Mean(Average) Value of the specified numerical values of the group entity
In Summary, The GROUP BY Clause always follows the Aggregate function in a QUERY.

## DAY 8 (ORDER BY AND LIMIT (TOP N) CLAUSE)
The ORDER BY clause has a sequential function for a table. It is used to rank items based on the Progression of Alphabetical Order, Values, Date, or User-Defined Sequence.
By default, when added to a query, Rows are presented in Ascending Order. It is now left to the user to specify which order the query should return.
The Limit (TOP N for MSSQL) Clause is used to restrict the number of rows returned by a SELECT query. It takes one or two arguments.

    1. The first argument is the number of rows to return.
    2. The second argument, if present, is the offset, which is the number of rows to skip before returning the first row.
It is also used with the WHERE or any other clauses to further filter results.

## DAY 9 (CASE STATEMENT)
The CASE statement is a conditional statement that allows you to execute different statements based on the value of an expression.
It has two forms: 
The simple CASE form is used when there is a need to execute different statements based on the value of a single expression. 

     1. The searched CASE form is used when it is necessary to execute different statements based on the value of a Boolean expression.
          The CASE statement can also be used to;
     2. Return different messages based on the value of an expression.
     3. Categorize data into different groups.
     4. Calculate different values based on the value of an expression.

## DAY 10 (DATE AND TIME EXTRACTIONS)
In some of the previous days of this challenge, little attempt has been made to do the above. Cases like that of day 7 and day 9 where Month Name and Hour were extracted from order date and advert time respectively. 
So, Date and time extractions are quite important to compare performance based on different elements of the date and time columns. Like comparing sales revenue for months, or days of the week, or comparing hourly traffic movement. 
Unless otherwise stated, the DateTime format Is always in YYYY-MM-DD HH:MM:SS by default which all can be extracted individually by;

     1. DATE(): Extracts the date from a date or DateTime value.
     2. TIME(): Extracts the time from a date or DateTime value.
     3. YEAR(): Extracts the year from a date or DateTime value.
     4. MONTH()/MONTHNAME(): Extracts the month number (or month name) from a date or DateTime value.
     5. DAY()/DAYNAME(): Extracts the day number (and day name) from a date or DateTime value.
     6. HOUR(): Extracts hours of the day from DateTime or Time value.

## DAY 11-20 PRACTICE QUESTION 
I spent the next 10 days working on different case studies to solidify my proficiency in the basic SQL syntax. The resources I used include;

     1. [Datalemur](https://datalemur.com/questions?category=SQL),
     2. [Stratascratch](https://platform.stratascratch.com/coding?code_type=3),
     3. [Hackerrank](https://www.hackerrank.com/domains/sql?filters%5Bsubdomains%5D%5B%5D=select).

## DAY 21 (UNION AND HAVING STATEMENT)
Before I start with the intermediate section of the challenge, I want to quickly treat the statements I omitted in the basic section. I use them on 2 different occasions during the practice. They are the 
UNION Statement – This Statement is used to combine different queries into a single query. A perfect example is the query that returns a table's top N and bottom 3 N in a single dataset. 

HAVING Statement – Having statement is a conditional statement always attached to a GROUP BY statement to filter the results of a query based on aggregate conditions. It works similarly to the WHERE function which is to filter results. The differences include;

      1. Where Statement is attached to the SELECT FROM Statement While The HAVING Statement is always attached to the GROUP BY Statement,
      2. WHERE Statement Filter by rows of a dataset, While HAVING Filter by Aggregates of a Group of a Dataset,
      3. In Order of Arrangement of Queries, WHERE comes before HAVING.

## DAY 22 SQL JOINS
As far as Database is concerned and the concept of Normalization is to be obeyed, Queries that join multiple tables will always be needed. 
For Proper Context, Database normalization is a process of organizing data in a database to reduce redundancy and improve data integrity. It is a systematic approach to dividing tables into smaller tables and linking them using relationships.
SQL Join is that clause that returns data from multiple tables based on a common column. It helps combine rows or columns for different based on a common field between them. 
**NB** The important point to note is that to make meaning out of the tables, both must contain a common field (A Primary or Foreign key) between them.

## DAY 23 TYPES OF JOINS
In continuation of the concept of the join clause, there are different types of Joins in SQL. The type to use is dependent on the result we are expecting. The types include.

      1. INNER JOIN- This is the most used of the types, it returns only matching records from the selected table.
      2. OUTER JOIN- This clause returns every record of the selected table (regardless of whether they match or not). They are further divided into.
      3. LEFT OUTER JOIN OR LEFT JOIN- This returns all matching records from all specified tables including the entire records of the left table.
      4. RIGHT OUTER JOIN OR RIGHT JOIN- It returns matching records from all specified tables including the entire records of the right table.
      5. SELF JOIN- This clause, though not really used (because of its normalization deficiency), is used to join a table with itself. 
      6. CROSS JOIN- Also called CARTESIAN JOIN is used to return all possible combinations of rows between specified tables. Unlike other types, it doesn’t need a matching column to 
          work.



## DAY 40 (PERCENTILE OF CONTINUOUS VALUE FUNCTION)
Percentile from statistics is used to explain how a value compares to the entire values of a population. It is normally expressed in whole numbers between 0 and 100. It has no universal definition but expresses the percentage of numbers below the value. If for example, a student's exam score is the 75th percentile, it means he scores rank above 75% of the class.
In the context of SQL, the percentile function is of three types depending on what we aim to achieve.

  1. PERCENT_RANK: This function is like that of CUME_DIST (). It calculates the relative rank of the current row within the result set. However, unlike CUME_DIST (), which returns a value from 0 to 1, PERCENT_RANK () returns a value from 0 to 1 inclusive, indicating the relative position of the current row concerning the total number of rows in the partition.

  2. PERCENTILE-CONT: This function calculates the specified percentile (continuous value) for a group (partition) based on the specified ORDER BY clause. It returns the value representing the specified percentile within each partition (i.e., what the value should be).

  3. PERCENTILE-DISC: This function is used to calculate the discrete percentile value within a group (partition) based on the specified ordering. Unlike the PERCENTILE_CONT, it returns the actual value from the dataset that corresponds to the specified percentile.

Off all the three categories of Percentile functions, only PERCENT_RANK can be found in MySQL, the remaining categories including the PERCENT_RANK are found in MSSQL.

## DAY 41 (AGGREGATE FUNCTIONS WITHIN WINDOW FUNCTIONS)
If you observe in the previous days when I had to write queries to explain the different elements of window functions, there have been scenarios where there was the need to use AGGREGATE FUNCTIONS to drive the explanations further. 
Handling aggregate functions within window functions is a powerful capability in SQL that allows you to perform complex calculations and aggregate results over defined partitions or groups. When using aggregate functions like SUM(), AVG(), and COUNT() within window functions, you can create more insightful and detailed analyses of your data.

## DAY 42 (USING WHERE CLAUSES ON WINDOW FUNCTIONS)
it is practically impossible to directly use a WHERE clause on window function results. This setback is normally encountered because at the time the WHERE clause is being used, the window functions won’t have been computed yet. 
An example of such a scenario is; trying to retrieve the top-performing product per month for a particular year by just passing using “WHERE WINDOW_FUNCTION = 1;”. In this scenario, the error it normally throws in is the 
“Error Code: 3593. You cannot use the window function 'row_number' in this context.”
Ways to prevent this scenario is to either use a SUBQUERY or the COMMON TABLE EXPRESSION. 
The SUBQUERY method will be used today, the COMMON TABLE EXPRESSION method will be treated as a separate topic tomorrow.

## DAY 43 (COMMON TABLE EXPRESSION)
I wrote an article (titled: (SQL Query best practices)[https://medium.com/@rajibabatunde/sql-queries-best-practices-1bdf77148bf3]) on the importance of writing efficient and readable queries. This singular art helps save processing time for our queries. Common Table Expression (Popularly called CTE) is an important aspect of SQL to master to achieve the art of writing efficient SQL queries.
CTEs are temporary named result sets that you can reference within a SELECT, INSERT, UPDATE, or DELETE statement. They allow you to break down complex queries into smaller, more manageable parts, making it easier to understand and maintain your code.
They are used mostly in place of SUBQUERIES. 
Benefits of CTEs include;

      1. Improving query performance by reducing the amount of redundant code and minimizing the number of times you need to join the same tables. 
      2. Also, CTEs can be used to simplify recursive queries, which can be difficult to write and optimize.








