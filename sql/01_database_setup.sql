CREATE DATABASE credit_risk_portfolio;
USE credit_risk_portfolio;

SELECT COUNT(*) AS total_customers
FROM stg_credit_customers;

SELECT
    MIN(ID) AS minimum_id,
    MAX(ID) AS maximum_id
FROM stg_credit_customers;

SELECT
    `default payment next month` AS default_status,
    COUNT(*) AS customers
FROM stg_credit_customers
GROUP BY `default payment next month`;

SELECT
    SUM(ID IS NULL) AS missing_id,
    SUM(LIMIT_BAL IS NULL) AS missing_limit,
    SUM(AGE IS NULL) AS missing_age,
    SUM(`default payment next month` IS NULL) AS missing_default
FROM stg_credit_customers;

SELECT
    `default payment next month`,
    COUNT(*)
FROM stg_credit_customers
GROUP BY `default payment next month`;

SELECT
    ID,
    COUNT(*)
FROM stg_credit_customers
GROUP BY ID
HAVING COUNT(*) > 1;