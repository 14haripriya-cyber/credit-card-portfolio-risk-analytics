-- Priority Monitoring List : Which customers should the bank monitor immediately?
WITH portfolio_average AS
(
    SELECT AVG(total_bill) AS avg_bill
    FROM credit_customers
)

SELECT
    c.ID,
    c.LIMIT_BAL,
    c.total_bill,
    c.total_payment,
    c.payment_ratio,
    c.max_delay,
    c.risk_score,
    c.`default payment next month`
FROM credit_customers c
CROSS JOIN portfolio_average p
WHERE c.risk_score >= 4
AND c.payment_ratio < 0.30
AND c.total_bill > p.avg_bill
ORDER BY c.total_bill DESC;

-- Customers Eligible for Credit Limit Increase: Which customers appear financially responsible?

SELECT
ID,
LIMIT_BAL,
payment_ratio,
total_bill,
total_payment
FROM credit_customers
WHERE risk_score = 1
AND `default payment next month` = 0
AND payment_ratio > 0.50
ORDER BY payment_ratio DESC;

-- High Exposure + High Risk : These are the customers management worries about.

SELECT
ID,
LIMIT_BAL,
total_bill,
risk_score,
payment_ratio,
`default payment next month`
FROM credit_customers
WHERE risk_score >= 4
ORDER BY total_bill DESC
LIMIT 20;

-- Portfolio Exposure by Education : Where is the bank's money concentrated?

SELECT
CASE
WHEN EDUCATION = 1 THEN 'Graduate School'
WHEN EDUCATION = 2 THEN 'University'
WHEN EDUCATION = 3 THEN 'High School'
ELSE 'Others'
END AS education,
COUNT(*) customers,
ROUND(SUM(total_bill),0) total_exposure,
ROUND(AVG(total_bill),0) avg_exposure
FROM credit_customers
GROUP BY education
ORDER BY total_exposure DESC;

-- Default Rate vs Credit Limit: Does increasing credit limit increase risk?

SELECT
credit_band,
COUNT(*) customers,
ROUND(AVG(`default payment next month`)*100,2) default_rate,
ROUND(AVG(payment_ratio),2) avg_payment_ratio,
ROUND(AVG(max_delay),2) avg_delay
FROM credit_customers
GROUP BY credit_band
ORDER BY AVG(LIMIT_BAL);

-- Top 10% Highest Exposure Customers

WITH exposure_rank AS
(
SELECT
ID,
total_bill,
risk_score,
NTILE(10) OVER(ORDER BY total_bill DESC) exposure_decile
FROM credit_customers
)
SELECT *
FROM exposure_rank
WHERE exposure_decile = 1;

-- Rank Customers by Financial Exposure

SELECT
ID,
total_bill,
RANK() OVER(ORDER BY total_bill DESC) exposure_rank
FROM credit_customers
LIMIT 20;

-- Customer Segmentation

SELECT
age_group,
credit_band,
COUNT(*) customers,
ROUND(AVG(`default payment next month`)*100,2) default_rate,
ROUND(AVG(payment_ratio),2) avg_payment_ratio
FROM credit_customers
GROUP BY age_group, credit_band
ORDER BY age_group, credit_band;

-- Executive Summary

SELECT
risk_category,
COUNT(*) customers,
ROUND(COUNT(*)*100/
(SUM(COUNT(*)) OVER()),2) portfolio_share,
ROUND(AVG(`default payment next month`)*100,2) default_rate,
ROUND(SUM(total_bill),0) portfolio_exposure
FROM credit_customers
GROUP BY risk_category;

-- Top Risk Segment

SELECT
age_group,
credit_band,
risk_category,
COUNT(*) customers,
ROUND(AVG(`default payment next month`)*100,2) default_rate
FROM credit_customers
GROUP BY age_group,
         credit_band,
         risk_category
HAVING COUNT(*) >= 100
ORDER BY default_rate DESC,
         customers DESC;