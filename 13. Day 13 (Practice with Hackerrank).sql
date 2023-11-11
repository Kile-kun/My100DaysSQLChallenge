
--DAY 13 (Practice with Hackerrank)

/*Query the Name of any student in STUDENTS who scored higher than Marks. Order your output by the last 
three characters of each name. If two or more students both have names ending in the same last three 
characters (i.e.: Bobby, Robby, etc.), secondary sort them by ascending ID.*/
SELECT NAME 
FROM STUDENTS
WHERE Marks > 75
ORDER BY RIGHT (Name,3), ID ASC;

/*Query the two cities in STATION with the shortest and longest CITY names, as well as their respective 
lengths (i.e.: number of characters in the name). If there is more than one smallest or largest city, 
choose the one that comes first when ordered alphabetically.*/
(SELECT
CITY, (LENGTH(CITY)) AS CHAR_LENGTH
FROM STATION
WHERE (LENGTH(CITY)) = (SELECT MIN(LENGTH(CITY)) FROM STATION) ORDER BY CITY ASC
LIMIT 1)
UNION
(SELECT
CITY, (LENGTH(CITY)) AS CHAR_LENGTH
FROM STATION
WHERE (LENGTH(CITY)) = (SELECT MAX(LENGTH(CITY)) FROM STATION) LIMIT 1)
ORDER BY LENGTH(CITY)ASC;