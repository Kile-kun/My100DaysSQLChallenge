
-- DAY 33 (JOIN PRACTICE)
/*Find the number of times each users flagged videos that ended up being approved.*/
SELECT CONCAT(u.user_firstname, '', u.user_lastname) AS user_fullname, COUNT(r.flag_id) AS total_review
FROM user_flags u
JOIN flag_review r
ON u.flag_id = r.flag_id
WHERE r.reviewed_outcome = 'APPROVED '
GROUP BY CONCAT(u.user_firstname, ' ', u.user_lastname);

/*Find the number of Apple product users and the number of total users with a device and group the 
counts by language. Assume Apple products are only MacBook-Pro, iPhone 5s, and iPad-air. 
Output the language along with the total number of Apple users and users with any device. 
Order your results based on the number of total users in descending order.*/
SELECT u.language,COUNT(DISTINCT 
                                CASE WHEN e.device IN ('macbook pro','iphone 5s','ipad air') 
                                            THEN e.user_id ELSE NULL END) 
                                            AS total_apple_users,
        COUNT(DISTINCT e.user_id) AS total_device_users
FROM playbook_events e
JOIN playbook_users u
ON u.user_id = e.user_id
GROUP BY u.language
ORDER BY total_device_users DESC;