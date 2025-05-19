/* 3. Account Inactivity Alert
Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .
Tables:
plans_plan
savings_savingsaccount
*/
SELECT * FROM plans_plan;
SELECT * FROM savings_savingsaccount;

WITH savings_last_txn AS (
    SELECT
        s.id AS plan_id,
        s.owner_id,
        'Savings' AS type,
        MAX(s.transaction_date) AS last_transaction_date
    FROM savings_savingsaccount s
    LEFT JOIN plans_plan p ON s.plan_id = p.id AND s.amount > 0
    GROUP BY s.id, s.owner_id
),
plans_last_txn AS (
    SELECT
        p.id AS plan_id,
        p.owner_id,
        'Investment' AS type,
        MAX(pt.created_at) AS last_transaction_date
    FROM savings_savingsaccount s
    LEFT JOIN plans_plan p ON s.plan_id = p.id AND s.amount > 0
    GROUP BY p.id, p.owner_id
),
combined AS (
    SELECT * FROM savings_last_txn
    UNION ALL
    SELECT * FROM plans_last_txn
)
SELECT
    plan_id,
    owner_id,
    type,
    last_transaction_date,
    DATE_PART('day', NOW() - last_transaction_date) AS inactivity_days
FROM
    combined
WHERE
    last_transaction_date IS NULL
    OR last_transaction_date;
