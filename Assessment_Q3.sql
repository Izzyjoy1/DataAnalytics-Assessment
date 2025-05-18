-- The query identifies inactive savings or investment plans by Checking the last transaction date for each plan, calculating how many days have passed since the last confirmed transaction and filtering plans that have been inactive for over a year or have never had a transaction.
-- it can help to 1. Flag dormant accounts for follow-up or re-engagement
-- 				  2. Generate reports on customer inactivity for stakeholders review
-- 				  3. Inform strategy team for reactivation campaigns.

USE adashi_staging;

SELECT
a.id AS plan_id, a.owner_id,
CASE WHEN a.is_a_fund = 1 THEN 'Investment' WHEN a.is_regular_savings = 1 THEN 'Savings' END AS type, -- Determine the plan type if it is Investment or Savings
MAX(b.created_on) AS last_transaction_date,
DATEDIFF(CURDATE(), MAX(b.created_on)) AS inactivity_days
FROM plans_plan a
LEFT JOIN savings_savingsaccount b
ON a.id = b.plan_id
WHERE (a.is_regular_savings = 1 OR a.is_a_fund = 1) -- Only consider plans that are either regular savings or investment plans
AND b.confirmed_amount > 0
GROUP BY a.id, a.owner_id, type
HAVING last_transaction_date IS NULL OR inactivity_days > 365; -- Only return plans with no transactions OR those inactive for over a year
