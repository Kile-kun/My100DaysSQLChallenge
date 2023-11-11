
-- DAY17 (Practice)

/*Rank guests based on their ages.Output the guest id along with the corresponding rank. Order records by
 the age in descending order*/
SELECT guest_id, age
FROM airbnb_guests ORDER BY age DESC;

/*Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft 
Teams in August 2022. Display the IDs of these 2 users along with the total number of messages they sent.
Output the results in descending order based on the count of the messages.*/
SELECT sender_id, COUNT(sender_id) AS num_of_messages
FROM messages
WHERE YEAR(sent_date) = 8 AND
MONTH(sent_date)= 2022
GROUP BY sender_id
ORDER BY num_of_messages DESC
LIMIT 2;

/*Write a query to find the top 3 most profitable drugs sold, and how much profit they made. Assume that 
there are no ties in the profits. Display the result from the highest to the lowest total profit.*/
SELECT drug, (total_sales-cogs) AS profit
FROM pharmacy_sales
ORDER BY profit DESC
LIMIT 3;

/*You've been asked by Amazon to find the shipment_id and weight of the third heaviest shipment. Output 
the shipment_id, and total_weight for that shipment_id.*/
SELECT shipment_id, SUM(weight) AS total_weight
FROM amazon_shipment
GROUP BY shipment_id
ORDER BY total_weight DESC
LIMIT 2,1;