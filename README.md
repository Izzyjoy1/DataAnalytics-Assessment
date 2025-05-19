# SQL Analytics Assessment

This repository contains solutions to four SQL-based analytical problems related to customer behavior, transactions, and account activity.

Each section includes:

- 🧠 **Approach**: Explanation of how the problem was tackled.  
- ⚠️ **Challenges**: Any difficulties encountered and how they were resolved.

---

## Assessment_Q1: Summary of User Deposits Across Savings and Investment Plans

### 🧠 Approach  
I joined the `users_customuser`, `plans_plan`, and `savings_savingsaccount` tables to connect user profiles with their savings and investment activities.  
Conditional aggregation using `CASE` was applied to separately count savings and investment plans.  
Confirmed deposit amounts were summed and converted from kobo to naira by dividing by 100 and rounding to two decimal places.  
I filtered for users who had at least one savings and one investment plan, and who had made confirmed deposits. This ensured the dataset focused on financially active users.

### ⚠️ Challenges  
Initially, I used a `LEFT JOIN` between users and plans to include users without plans, but this introduced `NULLs` into the dataset, which distorted count and sum aggregations.  
Switching to an `INNER JOIN` ensured only users with valid and funded plans were included in the results.

---

## Assessment_Q2: Categorization of Users Based on Monthly Transaction Frequency

### 🧠 Approach  
I structured this query using three Common Table Expressions (CTEs):

- `monthly_transactions`: calculated the number of transactions per user per month using `transaction_date`.  
- `average_txns_per_user`: computed the average monthly transactions per user.  
- `categorized_users`: used a `CASE` statement to assign users into frequency categories:
  - High Frequency (≥10 transactions/month)  
  - Medium Frequency (3–9 transactions/month)  
  - Low Frequency (<3 transactions/month)  

The final `SELECT` aggregated the number of users and average monthly transactions for each frequency group.

### ⚠️ Challenges  
Choosing effective segmentation thresholds was key. I reviewed the distribution of user activity and used simple and interpretable bands.  
Another challenge was accounting for users with no activity. To handle this, I ensured that transactions were grouped with `LEFT JOINs` and used filters only after aggregating.

---

## Assessment_Q3: Identification of Inactive Savings and Investment Plans

### 🧠 Approach  
I joined the `plans_plan` and `savings_savingsaccount` tables to associate each plan with its transactions.  
Using `MAX()` on the `created_on` field, I identified the most recent transaction date per plan.  
I then calculated the number of days since the last transaction using `DATEDIFF()` and `CURDATE()`.  
The final output filtered to include only those plans with more than 365 days of inactivity or no transaction history at all (`NULL` transaction dates).  
This approach supports detection of dormant or abandoned accounts for follow-up or re-engagement.

### ⚠️ Challenges  
Dealing with `NULL` transaction records required a `HAVING` clause that accounted for both types of inactivity:  
- No transaction ever  
- Last transaction over one year ago  

This dual-condition logic was essential to include all relevant inactive plans.

---

## Assessment_Q4: Estimation of Customer Lifetime Value (CLV)

### 🧠 Approach  
I calculated the user’s tenure in months using `TIMESTAMPDIFF()` between their `date_joined` and the current date.  
I counted their total transactions and computed the average transaction value.  
CLV was then estimated as:  
```sql
(average monthly transactions) × (average transaction value) × 12
