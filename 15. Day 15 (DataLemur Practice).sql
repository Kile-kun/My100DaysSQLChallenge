
-- DAY 15 (DataLemur Practice)

/*Assume you're given a table Twitter tweet data, write a query to obtain a histogram of tweets posted per 
user in 2022. Output the tweet count per user as the bucket and the number of Twitter users who fall into
that bucket.*/
SELECT tweet_count, COUNT(tweet_count) AS tweeters_num
FROM
(SELECT user_id, COUNT(user_id) AS tweet_count
FROM tweets
WHERE EXTRACT(YEAR FROM tweet_date) = 2022
GROUP BY user_id) AS total_tweets
GROUP BY tweet_count;

/*Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find
the number of days between each user's first post of the year and last post of the year in the year 2021.
Output the user and number of the days between each user's first and last post.*/
SELECT user_id,
(MAX(DAYOFYEAR(post_date))-MIN(DAYOFYEAR(post_date)) AS day_between
FROM posts
WHERE YEAR(post_date) = 2021
GROUP BY user_id
HAVING COUNT(user_id)>1
ORDER BY user_id;