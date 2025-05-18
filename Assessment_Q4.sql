-- the aim is to calculates an estimated Customer Lifetime Value (CLV) for each user based on how long they have been with the company, their total number of transactions and the average transaction value.
-- it helps to rank customers by potential value and can inform marketing, retention, and engagement strategies.

USE adashi_staging;

SELECT
a.id AS customer_id, CONCAT(a.first_name, ' ', a.last_name) AS name,
timestampdiff(month, a.date_joined, CURDATE()) as tenure_months,  -- Calculate how many full months the user has been with the company
COUNT(b.owner_id) AS total_transactions,  -- Count the total number of transactions for the user
CASE WHEN timestampdiff(month, a.date_joined, CURDATE()) > 0 THEN
round((COUNT(b.id) / timestampdiff(month, a.date_joined, CURDATE())) -- Avg transactions per month
 * 12 * ((SUM(b.confirmed_amount) / COUNT(b.id)) * 0.001),2) ELSE 0 END AS estimated_clv -- Estimate customer lifetime value (CLV) using average monthly transactions and transaction value
FROM users_customuser a
JOIN savings_savingsaccount b
ON a.id = b.owner_id
WHERE b.confirmed_amount > 0
GROUP BY a.id, name, a.date_joined
ORDER BY estimated_clv DESC;
