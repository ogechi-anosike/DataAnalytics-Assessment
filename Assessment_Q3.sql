SELECT * FROM savings_savingsaccount LIMIT 10;
SELECT * FROM plans_plan LIMIT 10;

SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Unknown'
    END AS type,
    s.last_transaction_date,
    DATEDIFF(CURDATE(), s.last_transaction_date) AS inactivity_days
FROM 
    plans_plan p
LEFT JOIN (
    SELECT 
        owner_id,
        MAX(transaction_date) AS last_transaction_date
    FROM 
        savings_savingsaccount
    GROUP BY owner_id
) s ON p.owner_id = s.owner_id
WHERE 
    s.last_transaction_date IS NULL 
    OR DATEDIFF(CURDATE(), s.last_transaction_date) > 365
ORDER BY 
    inactivity_days DESC;
