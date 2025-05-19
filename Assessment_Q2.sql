/* 2. Transaction Frequency Analysis
Scenario: The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).
Task: Calculate the average number of transactions per customer per month and categorize them:
"High Frequency" (≥10 transactions/month)
"Medium Frequency" (3-9 transactions/month)
"Low Frequency" (≤2 transactions/month)
	Tables:
	users_customuser
	savings_savingsaccount
*/

select * from users_customuser;
select * from savings_savingsaccount;

WITH customer_txn_counts AS (
    SELECT
        u.id as owner_id,
        COUNT(s.owner_id) AS total_txns,
        EXTRACT(YEAR FROM NOW()) - EXTRACT(YEAR FROM MIN(s.transaction_date)) + 1 AS years_active,
        COUNT(s.owner_id) / NULLIF(
            EXTRACT(MONTH FROM AGE(MAX(s.transaction_date), MIN(s.transaction_date))) + 1, 0
        ) AS avg_txns_per_month
    FROM users_customuser as u
    JOIN savings_savingsaccount s ON u.id = s.account_id
    GROUP BY s.owner_id
),
categorized AS (
    SELECT
        CASE 
            WHEN avg_txns_per_month >= 10 THEN 'High Frequency'
            WHEN avg_txns_per_month >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        avg_txns_per_month
    FROM
        customer_txn_counts
)
SELECT
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_txns_per_month), 1) AS avg_transactions_per_month
FROM
    categorized
GROUP BY
    frequency_category
ORDER BY
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');