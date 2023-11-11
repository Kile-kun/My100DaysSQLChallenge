
-- DAY 14 (Hackerrank Practice)

/*Write a query identifying the type of each record in the TRIANGLES table using its three side lengths. 
Output one of the following statements for each record in the table:
    --Equilateral: It's a triangle with sides of equal length. 
    --Isosceles: It's a triangle with sides of equal length. 
    --Scalene: It's a triangle with sides of differing lengths.
    --Not A Triangle: The given values of A, B, and C don't form a triangle.*/
SELECT CASE
FROM TRIANGLES;
WHEN_A+B>C_AND_(A=B_AND_B=C_AND_A=C) THEN "Equilateral" WHEN A+B>C AND ((A=B AND B<>C)OR
(A=C_AND_C<>B) OR
B=C AND A<>B) THEN "Isosceles"
WHEN A+B>C AND (A<>B AND B<>C_AND_A<>C) THEN "Scalene" ELSE "Not A Triangle"
END AS Type

/*Generate the following two result sets:
Query an alphabetically ordered list of all names in OCCUPATIONS, immediately followed by the first letter
of each profession as a parenthetical (i.e.: enclosed in parentheses). For example:
AnActorName(A), ADoctorName(D), AProfessorName(P), and ASingerName(S). Query the number of ocurrences of
each occupation in OCCUPATIONS. Sort the occurrences in ascending order, and output them in the following
format:
There are a total of [occupation_count] [occupation]s.
--where [occupation_count] is the number of occurrences of an occupation in OCCUPATIONS and [occupation] 
is the lowercase occupation name. If more than one Occupation has the same [occupation_count], 
they should be ordered alphabetically.*/
SELECT CONCAT(Name, "(", LEFT(Occupation,1), ")") AS result
FROM OCCUPATIONS
UNION,
SELECT CONCAT("There are a total of COUNT(Occupation)," LOWER(Occupation), "s.") AS result 
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY result;