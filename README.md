# My100DaysSQLChallenge
Follow my 100-day journey of mastering SQL and exploring the powerful data manipulation and analysis world. Each day, I'll be working on SQL problems, learning window functions, honing my query skills, and sharing my progress here. Join me as I dive into SQL magic, and together, let's conquer data challenges and unlock valuable insights! 

## DAY 0 (INTRODUCTION)
According to Malcolm Gladwell, he said, "It takes 10,000 hours to become an expert in anything.". According to the general opinion, SQL is one of the most important tools a data specialist Is meant to master (if not the most important). So, I am dedicating the next 100 days to solving different SQL problems. The problem will cover different SQL topics. The SQL tool I will majorly use throughout the challenge is MySQL and occasionally, I will pitch in different methods peculiar to other SQL tools like MSSQL and PostgreSQL.

<img width="786" alt="Malcom Gladwell" https://raw.githubusercontent.com/Kile-kun/My100DaysSQLChallenge/main/Others/Malcolm%20Gladwell.webp"

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
      **%-** Represents zero, one, or multiple characters.
      **_:** Represents one, single character.
The IN-operator filters rows by returning only specified values separated by commas. It can also be used to compare a value to a subquery.
The BETWEEN operator returns values within a specified range. 
Unlike LIKE and IN operators which are used for Strings, and Mixed of Strings and Integers Respectively, The Between Operation is specifically meant for Numeric Data types.

## DAY 5 (AND, OR & NOT OPERATORS)
When there is a need to combine multiple conditions in a query, The AND-OR-NOT operators are attached to join the conditions of the WHERE Clauses. 
The AND operator returns rows that meet all the conditions,
The OR operator returns rows that meet any of the conditions,
The NOT operator returns rows that negate the conditions, it is attached to the ADVANCED OPERATORS (we discussed in DAY 4).

## DAY 6 (STRING OPERATORS AND FUNCTIONS)
To further perform operations on Columns with string data types, certain functions are used. They are very many with different purposes, but the most prominent among them include;
    **CONCAT():** This joins (Concatenate) two or more columns together in a single string                    
    **RIGHT():**  This extracts a substring from the right side of a string
    **LEFT():** This returns a substring from the left side of a string.
    **MID():** Extract certain substring from a specified center of a string

## DAY 7 (GROUP BY AND AGGREGATE FUNCTIONS)
The GROUP BY and ORDER BY are one of the most integral clauses in SQL as you are most likely going to use them in your everyday analysis. 
The GROUP BY Clause is always applied to group rows with the same values as summary rows. This is often done to apply some sort of aggregate function to the data, such as 
    **COUNT():** which Count the values of each row of similar items,
    **MAX():** The Highest value of a grouped entity, 
    **MIN():** The Lowest value of a grouped entity,
    **SUM():** The addition of all values of the group, or
    **AVG():** This is the Mean(Average) Value of the specified numerical values
    of the group entity
In Summary, The GROUP BY Clause always follows the Aggregate function in a QUERY.

## DAY 8 (ORDER BY AND LIMIT (TOP N) CLAUSE)
The ORDER BY clause has a sequential function for a table. It is used to rank items based on the Progression of Alphabetical Order, Values, Date, or User-Defined Sequence.
By default, when added to a query, Rows are presented in Ascending Order. It is now left to the user to specify which order the query should return.
The Limit (TOP N for MSSQL) Clause is used to restrict the number of rows returned by a SELECT query. It takes one or two arguments.
    **a.** The first argument is the number of rows to return.
    **b.** The second argument, if present, is the offset, which is the number of rows to skip before returning the first row.
It is also used with the WHERE or any other clauses to further filter results.

## DAY 9 (CASE STATEMENT)
The CASE statement is a conditional statement that allows you to execute different statements based on the value of an expression.
It has two forms: 
The simple CASE form is used when there is a need to execute different statements based on the value of a single expression. 
    **a.** The searched CASE form is used when it is necessary to execute
    different statements based on the value of a Boolean expression.
     The CASE statement can also be used to;
    **b.** Return different messages based on the value of an expression.
    **c.** Categorize data into different groups.
    **d.** Calculate different values based on the value of an expression.



## DAY 40 (PERCENTILE OF CONTINUOUS VALUE FUNCTION)
Percentile from statistics is used to explain how a value compares to the entire values of a population. It is normally expressed in whole numbers between 0 and 100. It has no universal definition but expresses the percentage of numbers below the value. If for example, a student's exam score is the 75th percentile, it means he scores rank above 75% of the class.
In the context of SQL, the percentile function is of three types depending on what we aim to achieve.

  **PERCENT_RANK:** This function is like that of CUME_DIST (). It calculates the relative rank of the current row within the result set. However, unlike CUME_DIST (), which returns a value from 0 to 1, PERCENT_RANK () returns a value from 0 to 1 inclusive, indicating the relative position of the current row concerning the total number of rows in the partition.

  **PERCENTILE-CONT:** This function calculates the specified percentile (continuous value) for a group (partition) based on the specified ORDER BY clause. It returns the value representing the specified percentile within each partition (i.e., what the value should be).

  **PERCENTILE-DISC:** This function is used to calculate the discrete percentile value within a group (partition) based on the specified ordering. Unlike the PERCENTILE_CONT, it returns the actual value from the dataset that corresponds to the specified percentile.

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





