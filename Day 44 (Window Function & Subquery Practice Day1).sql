-- DAY 44 (Window Function & Subquery Practice Day1)

/* CASE STUDY: A Senator looking to get re-elected employed you to help analyze his chance of returning to the house if the new electoral bill is passed
OLD BILL: Electorates are allowed to vote for multiple candidates but not more than three and each vote will count separately
NEW BILL: An Electorate is allowed to vote for multiple candidates but in this case the candidates he vote for recieve a fraction of his votes (That is, his vote gets equally split across these candidates)

-- A Mock election was setup and a result sheet was present to you for analysis*/
-- (NOTE: VOID VOTES ARE NOT ELIGIBLE)

-- VOTER'S RESULT ACCORDING TO THE OLD ELECTORAL BILL 

USE election_db;
SELECT candidate, COUNT(*) AS total_vote_recieved,
        DENSE_RANK() OVER(ORDER BY COUNT(*) DESC) AS vot_rank
FROM voters_result
WHERE candidate IS NOT NULL
GROUP BY candidate;

-- VOTER'S RESULT ACCORDING TO THE NEW ELECTORAL BILL
SELECT * 
FROM
        (SELECT candidate, ROUND(SUM(vot_val),3) AS total_count,
                DENSE_RANK() OVER(ORDER BY ROUND(SUM(vot_val),3) DESC) AS vot_rank
        FROM
                (SELECT voter, candidate, 
                1.00/COUNT(*) OVER(PARTITION BY voter) AS vot_val
                FROM voters_result
                WHERE candidate IS NOT NULL) AS vot_val_table
        GROUP BY candidate) AS final_result;