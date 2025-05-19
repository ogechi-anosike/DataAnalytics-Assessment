SELECT * FROM users_customuser LIMIT 10;
SELECT * FROM savings_savingsaccount LIMIT 10;

SELECT 
    u.id AS customer_id,
    u.name,
    PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), DATE_FORMAT(u.date_joined, '%Y%m')) + 1 AS tenure_months,
    COUNT(s.confirmed_amount) AS total_transactions,
    ROUND(
        (COUNT(s.confirmed_amount) / (PERIOD_DIFF(DATE_FORMAT(CURDATE(), '%Y%m'), DATE_FORMAT(u.date_joined, '%Y%m')) + 1)) 
        * 12 
        * (0.001 * AVG(s.confirmed_amount)),
        2
    ) AS estimated_clv
FROM 
    users_customuser u
LEFT JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
GROUP BY 
    u.id, u.name, u.date_joined
ORDER BY 
    estimated_clv DESC;
