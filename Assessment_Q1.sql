SELECT * FROM users_customuser LIMIT 10;
SELECT * FROM savings_savingsaccount LIMIT 10;
SELECT * FROM plans_plan LIMIT 10;

SELECT 
    u.id AS owner_id,
    u.name,
    COALESCE(s.savings_count, 0) AS savings_count,
    COALESCE(i.investment_count, 0) AS investment_count,
    ROUND(COALESCE(d.total_deposits, 0) / 100.0,2) AS total_deposits
FROM 
    users_customuser u
LEFT JOIN (
    SELECT owner_id, COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1
    GROUP BY owner_id
) s ON u.id = s.owner_id
LEFT JOIN (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
) i ON u.id = i.owner_id
LEFT JOIN (
    SELECT owner_id, SUM(confirmed_amount) AS total_deposits
    FROM savings_savingsaccount
    GROUP BY owner_id
) d ON u.id = d.owner_id
WHERE 
    s.savings_count > 0 AND i.investment_count > 0
ORDER BY 
    total_deposits DESC;


