# DataAnalytics-Assessment

## Overview

This repository contains my SQL-based solutions to a four-part Data Analyst technical assessment. Each question is designed to evaluate core SQL competencies such as joins, aggregations, conditional logic, date calculations, and business scenario modeling. The dataset mimics a real-world relational database with customer, transaction, and plan information. My approach was to carefully study the structure and content of each table, identify the relationships, and build modular, readable queries that solve the business tasks accurately.

---

## Per-Question Explanations

### Question 1: High-Value Customers with Multiple Products

For this question, I started by inspecting the structure of all three involved tables: `users_customuser`, `savings_savingsaccount`, and `plans_plan`. I wanted to understand which columns indicated a savings plan, an investment plan, and where deposits were stored. After identifying that `is_regular_savings` and `is_a_fund` flags marked plan types, and `confirmed_amount` represented deposit inflows (in kobo), I proceeded to build my query.

I selected the customer ID and name from the user table, then counted how many savings and investment plans each customer held using conditional `CASE` statements within `COUNT`. To handle possible null values where customers had no matching rows in the joined tables, I used `COALESCE`. I summed all confirmed deposits for each customer, dividing by 100 to convert the values from kobo to Naira.

I used `LEFT JOIN` to combine `users_customuser` with `plans_plan` and `savings_savingsaccount`, ensuring that even users with incomplete records would be considered. Finally, I filtered for customers with at least one of both plan types and sorted the results by total deposits to align with the business goal of identifying cross-sell opportunities.

### Question 2: Transaction Frequency Analysis

This question required categorizing customers based on how frequently they transacted monthly. I started by reviewing the `savings_savingsaccount` and `users_customuser` tables to find transaction dates and user IDs.

To structure the logic cleanly, I used Common Table Expressions (CTEs). In the first CTE, `customer_count_date`, I calculated the total number of transactions per customer and the number of active months by computing the difference between the earliest and latest transaction dates using `PERIOD_DIFF` and adding 1 to include the starting month. 

In the second CTE, `classification`, I calculated the average number of transactions per month and classified each customer using a `CASE` clause. Customers were segmented into "High Frequency" (10+ transactions/month), "Medium Frequency" (3–9/month), and "Low Frequency" (≤2/month). Finally, I aggregated the number of customers in each category and calculated the average transaction rate per category. This approach ensured my final output aligned with the format and business logic expected.

### Question 3: Account Inactivity Alert

This task involved identifying accounts that had not received inflows in the past year. Once again, I began by understanding the relevant fields in `plans_plan` and `savings_savingsaccount`. I created a `type` column using a `CASE` clause to assign either 'Savings', 'Investment', or 'Unknown' based on the `is_regular_savings` and `is_a_fund` flags in the `plans_plan` table.

To find inactivity, I created a subquery to extract the `MAX(transaction_date)` per customer from the `savings_savingsaccount` table, assuming the last inflow represents the last account activity. I then joined this result with the `plans_plan` table and used the `DATEDIFF` function to calculate the number of days since that last inflow. If the result was greater than 365 or null (indicating no transaction), the account was flagged. This provided a clear, actionable list of inactive accounts, as required.

### Question 4: Customer Lifetime Value (CLV) Estimation

This question involved implementing a simplified CLV formula based on tenure and transaction behavior. I began by determining the customer's account tenure in months, using the difference between the current date and `date_joined` from the `users_customuser` table.

I joined this with the `savings_savingsaccount` table and used `COUNT` to determine the number of transactions and `AVG(confirmed_amount)` to estimate the average transaction value. Using the provided CLV formula:

CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction


I implemented it directly in the `SELECT` clause and used `ROUND(..., 2)` to format the result to two decimal places. I assumed profit per transaction to be 0.1% (or 0.001) of the average transaction value and left the amount in kobo unless otherwise instructed. This logic allowed me to rank customers by profitability and generate a business-ready insight.

---

## Challenges

### 1. Database Setup & Performance
One of the most significant challenges I faced was setting up the database. Initially, I used DBeaver, but due to the large file size and performance limitations, the environment kept freezing and crashing. I later switched to MySQL Workbench, which provided better performance and allowed me to run and test queries more efficiently.

### 2. Schema Discovery
The question prompts didn’t specify which columns to use, so I had to explore each table manually to understand its structure and relationships. This involved inspecting every field and inferring meaning from column names like `is_regular_savings`, `is_a_fund`, and `confirmed_amount`.

### 3. Kobo to Naira Conversion
The monetary values were stored in kobo, which required careful conversion in every query involving financial aggregation. Forgetting to divide by 100 would have skewed all financial results, so I had to double-check all numeric fields involving money.

### 4. Query Optimization
Some queries, especially those involving joins across large tables, timed out or ran slowly. To mitigate this, I rewrote some queries using subqueries or Common Table Expressions (CTEs) to reduce computation and improve readability.



