-- The aim is to analyzes customer transaction behavior by categorizing users based on how frequently they perform transactions per month.
-- This helps in customer segmentation for product decisions, marketing, and user engagement strategies.
-- used 3 CTEs 1. which prepares monthly transaction data per user
-- 			   2. it calculates the average number of transactions per month for each user by averaging the monthly counts
-- 			   3. it takes each user’s average and assigns them to a frequency category

USE adashi_staging;

WITH monthly_transactions as
(SELECT b.id AS owner_id,
DATE_FORMAT(a.transaction_date, '%Y-%m') AS txn_month, -- Format transaction date to Year-Month
COUNT(*) AS monthly_txn_count
FROM savings_savingsaccount as a
LEFT JOIN users_customuser as b ON a.owner_id = b.id 
GROUP BY b.id, txn_month),

average_txns_per_user as
(SELECT owner_id,
ROUND(AVG(monthly_txn_count),1) AS avg_txns_per_month -- Calculate average transactions per month per user
FROM monthly_transactions
GROUP BY owner_id),

categorized_users as
(SELECT 
CASE WHEN avg_txns_per_month >= 10 THEN 'High Frequency' -- Users with >= 10 transactions/month
WHEN avg_txns_per_month BETWEEN 3 AND 9 THEN 'Medium Frequency' -- Users with 3–9 transactions/month
ELSE 'Low Frequency' END AS frequency_category, -- Users with < 3 transactions/month
avg_txns_per_month
FROM average_txns_per_user)

-- Outputs the final results: how many users fall into each frequency category and their average monthly transactions.
SELECT 
frequency_category,
COUNT(*) AS customer_count,
ROUND(AVG(avg_txns_per_month), 1) AS avg_transactions_per_month
FROM categorized_users
GROUP BY frequency_category;