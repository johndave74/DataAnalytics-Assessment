/*4. Customer Lifetime Value (CLV) Estimation
Scenario: Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).
Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
Account tenure (months since signup)
Total transactions
Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
Order by estimated CLV from highest to lowest

Tables:
users_customuser
savings_savingsaccount
*/

WITH txn_summary AS (
    SELECT
        sa.owner_id,
        COUNT(s.owner_id) AS total_transactions,
        SUM(s.amount) AS total_transaction_value
    FROM users_customuser u
    JOIN savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY sa.owner_id
),
tenure_calc AS (
    SELECT
        u.id AS owner_id,
        DATE_PART('month', AGE(NOW(), u.date_joined)) AS tenure_months
    FROM users_customuser u
),
clv_calc AS (
    SELECT
        t.owner_id,
        te.tenure_months,
        t.total_transactions,
        t.total_transaction_value,
        -- Calculate average profit per transaction
        (t.total_transaction_value * 0.001) / NULLIF(t.total_transactions, 0) AS avg_profit_per_transaction
    FROM txn_summary t
    JOIN tenure_calc te ON t.owner_id = te.owner_id
)
SELECT
    c.owner_id,
    c.tenure_months,
    c.total_transactions,
    ROUND((
        (c.total_transactions / NULLIF(c.tenure_months, 0)) * 12 * c.avg_profit_per_transaction
    ), 2) AS estimated_clv
FROM clv_calc c
ORDER BY estimated_clv DESC;
