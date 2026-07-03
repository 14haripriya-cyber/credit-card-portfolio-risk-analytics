-- Portfolio Overview: What does the bank's portfolio look like?

SELECT
    COUNT(*) AS total_customers,
    SUM(`default payment next month`) AS total_defaulters,
    ROUND(AVG(`default payment next month`) * 100,2) AS default_rate,
    ROUND(AVG(LIMIT_BAL),2) AS avg_credit_limit,
    ROUND(AVG(total_bill),2) AS avg_total_bill,
    ROUND(AVG(total_payment),2) AS avg_total_payment
FROM credit_customers;

-- Default Rate by Gender: Does gender influence default?

SELECT
    CASE
        WHEN SEX = 1 THEN 'Male'
        ELSE 'Female'
    END AS gender,
    COUNT(*) AS customers,
    SUM(`default payment next month`) AS defaulters,
    ROUND(AVG(`default payment next month`) * 100,2) AS default_rate
FROM credit_customers
GROUP BY gender
ORDER BY default_rate DESC;

-- Default Rate by Age Group

SELECT
    age_group,
    COUNT(*) AS customers,
    SUM(`default payment next month`) AS defaulters,
    ROUND(AVG(`default payment next month`) * 100,2) AS default_rate
FROM credit_customers
GROUP BY age_group
ORDER BY default_rate DESC;

-- Default Rate by Education

SELECT
    CASE
        WHEN EDUCATION = 1 THEN 'Graduate School'
        WHEN EDUCATION = 2 THEN 'University'
        WHEN EDUCATION = 3 THEN 'High School'
        ELSE 'Others'
    END AS education_level,
    COUNT(*) AS customers,
    ROUND(AVG(`default payment next month`) * 100,2) AS default_rate
FROM credit_customers
GROUP BY education_level
ORDER BY default_rate DESC;

-- Default Rate by Marital Status

SELECT
CASE
WHEN MARRIAGE = 1 THEN 'Married'
WHEN MARRIAGE = 2 THEN 'Single'
ELSE 'Others'
END AS marital_status,
COUNT(*) AS customers,
ROUND(AVG(`default payment next month`) *100,2) AS default_rate
FROM credit_customers
GROUP BY marital_status
ORDER BY default_rate DESC;

-- Default Rate by Credit Band

SELECT
credit_band,
COUNT(*) AS customers,
ROUND(AVG(`default payment next month`)*100,2) AS default_rate,
ROUND(AVG(LIMIT_BAL),0) AS avg_limit
FROM credit_customers
GROUP BY credit_band
ORDER BY avg_limit;

-- Risk Category

SELECT
risk_category,
COUNT(*) AS customers,
SUM(`default payment next month`) AS defaulters,
ROUND(AVG(`default payment next month`)*100,2) AS default_rate
FROM credit_customers
GROUP BY risk_category
ORDER BY default_rate DESC;

-- Portfolio Exposure: Which customer segment represents the largest outstanding balance?

SELECT
risk_category,
ROUND(SUM(total_bill),0) AS total_exposure,
ROUND(AVG(total_bill),0) AS avg_customer_exposure
FROM credit_customers
GROUP BY risk_category
ORDER BY total_exposure DESC;

-- Highest Exposure Customers : Which customers currently expose the bank to the greatest financial risk?

SELECT
ID,
LIMIT_BAL,
total_bill,
risk_category,
`default payment next month`
FROM credit_customers
ORDER BY total_bill DESC
LIMIT 10;

-- Payment Behaviour: Are customers paying enough?

SELECT
risk_category,
ROUND(AVG(payment_ratio),2) AS avg_payment_ratio
FROM credit_customers
GROUP BY risk_category;

-- Average Delay

SELECT
risk_category,
ROUND(AVG(max_delay),2) AS average_delay
FROM credit_customers
GROUP BY risk_category;

-- Top 10% Highest Bills

WITH ranked_customers AS
(
SELECT
ID,
total_bill,
NTILE(10) OVER (ORDER BY total_bill DESC) AS bill_decile
FROM credit_customers
)
SELECT *
FROM ranked_customers
WHERE bill_decile = 1;

ALTER TABLE credit_customers
ADD COLUMN risk_score INT;

UPDATE credit_customers
SET risk_score =
CASE
    WHEN max_delay <= 0 THEN 1
    WHEN max_delay = 1 THEN 2
    WHEN max_delay = 2 THEN 3
    WHEN max_delay = 3 THEN 4
    ELSE 5
END;

SELECT
    risk_score,
    COUNT(*) customers,
    ROUND(AVG(`default payment next month`)*100,2) default_rate
FROM credit_customers
GROUP BY risk_score
ORDER BY risk_score;