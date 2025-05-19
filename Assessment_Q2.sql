SELECT * FROM users_customuser LIMIT 10;
SELECT * FROM savings_savingsaccount LIMIT 10;

WITH customer_count_date AS (
    SELECT 
        owner_id,
        COUNT(*) AS total_transactions,
        PERIOD_DIFF(
            DATE_FORMAT(MAX(transaction_date), '%Y%m'),
            DATE_FORMAT(MIN(transaction_date), '%Y%m')
        ) + 1 AS active_months
    FROM 
        savings_savingsaccount
    GROUP BY 
        owner_id
),
classification AS (
    SELECT 
        owner_id,
        total_transactions,
        active_months,
        total_transactions / active_months AS avg_transactions_per_month,
        CASE
            WHEN total_transactions / active_months >= 10 THEN 'High Frequency'
            WHEN total_transactions / active_months >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_count_date
)
SELECT 
    frequency_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM 
    classification
GROUP BY 
    frequency_category
ORDER BY 
    FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
