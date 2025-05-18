-- aim is to Fetch a summary of user deposits across savings and investment plans

USE adashi_staging;
SELECT
a.id AS owner_id, CONCAT(a.first_name, ' ', a.last_name) AS name, -- Concatenate first and last names to form full name
COUNT(DISTINCT CASE WHEN b.is_regular_savings = 1 THEN b.id END) AS savings_count,-- Count the number of distinct regular savings plans owned by the use
COUNT(DISTINCT CASE WHEN b.is_a_fund = 1 THEN b.id END) AS investment_count,-- Count the number of distinct investment plans owned by the user
ROUND(SUM(c.confirmed_amount) / 100, 2) AS total_deposits -- Calculate the total confirmed deposit amount for each user and also Convert from kobo to naira (divide by 100) and round to 2 decimal places
FROM users_customuser AS a
JOIN plans_plan AS b ON a.id = b.owner_id -- Challenge: Initially used LEFT JOIN to include all users, but realized it caused rows with NULL plan data, which distorted counts and sums. Switched to INNER JOIN because we only want users who actually have plans linked to them.
JOIN savings_savingsaccount AS c ON b.id = c.plan_id
WHERE c.confirmed_amount > 0
AND (b.is_regular_savings = 1 OR b.is_a_fund = 1) -- Only include plans that are either regular savings or investment plans
GROUP BY a.id, a.first_name, a.last_name
HAVING savings_count > 0 AND investment_count > 0 -- Only include users who have both at least one savings and one investment plan
ORDER BY total_deposits DESC;