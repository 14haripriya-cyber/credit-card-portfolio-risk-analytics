-- Executive Portfolio Summary

CREATE VIEW vw_portfolio_summary AS
SELECT
COUNT(*) AS total_customers,
SUM(`default payment next month`) AS total_defaulters,
ROUND(AVG(`default payment next month`)*100,2) AS default_rate,
ROUND(AVG(LIMIT_BAL),0) AS average_credit_limit,
ROUND(SUM(total_bill),0) AS total_exposure,
ROUND(AVG(payment_ratio),2) AS average_payment_ratio
FROM credit_customers;

-- Customer Risk View

CREATE OR REPLACE VIEW vw_customer_risk AS
SELECT
ID,
AGE,
age_group,
SEX,
EDUCATION,
MARRIAGE,
LIMIT_BAL,
credit_band,
risk_score,
risk_category,
total_bill,
total_payment,
payment_ratio,
max_delay,
`default payment next month`
FROM credit_customers;

-- Credit Segment Summary

CREATE OR REPLACE VIEW vw_credit_segments AS
SELECT
credit_band,
COUNT(*) AS customers,
ROUND(AVG(`default payment next month`)*100,2) AS default_rate,
ROUND(AVG(total_bill),0) AS average_bill,
ROUND(AVG(payment_ratio),2) AS average_payment_ratio
FROM credit_customers
GROUP BY credit_band;

-- Age Analysis

CREATE OR REPLACE VIEW vw_age_analysis AS
SELECt
age_group,
COUNT(*) customers,
ROUND(AVG(`default payment next month`)*100,2) default_rate,
ROUND(AVG(total_bill),0) avg_bill,
ROUND(AVG(payment_ratio),2) payment_ratio
FROM credit_customers
GROUP BY age_group;

-- Priority Monitoring

CREATE OR REPLACE VIEW vw_priority_monitoring AS
SELECT
ID,
LIMIT_BAL,
total_bill,
payment_ratio,
risk_score,
risk_category,
max_delay,
`default payment next month`
FROM credit_customers
WHERE risk_score >=4
AND payment_ratio <0.30;

-- Executive Risk Summary

CREATE OR REPLACE VIEW vw_risk_summary AS
SELECT
risk_category,
COUNT(*) customers,
ROUND(AVG(`default payment next month`)*100,2) default_rate,
ROUND(SUM(total_bill),0) portfolio_exposure,
ROUND(AVG(payment_ratio),2) payment_ratio
FROM credit_customers
GROUP BY risk_category;

SHOW FULL TABLES
WHERE Table_type='VIEW';