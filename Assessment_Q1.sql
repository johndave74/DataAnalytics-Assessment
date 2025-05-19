/* 1. High-Value Customers with Multiple Products
Scenario: The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).
Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
Tables:
	users_customuser
	savings_savingsaccount
	plans_plan
*/
select * from users_customuser;
select * from savings_savingsaccount;
select * from plans_plan;

SELECT
    u.id AS owner_id,
    u.name,
    COUNT(DISTINCT s.id) AS savings_count,
    COUNT(DISTINCT p.id) AS investment_count,
    COALESCE(SUM(s.new_balance), 0) + COALESCE(SUM(p.amount), 0) AS total_deposits
FROM users_customuser u
LEFT JOIN savings_savingsaccount s 
	ON u.id = s.owner_id AND s.new_balance > 0
LEFT JOIN plans_plan p 
	ON u.id = p.owner_id AND p.amount > 0
GROUP BY u.id, u.name
HAVING COUNT(DISTINCT s.id) >= 1 AND COUNT(DISTINCT p.id) >= 1
ORDER BY total_deposits DESC;


