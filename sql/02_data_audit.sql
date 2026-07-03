-- Total records

SELECT COUNT(*) AS total_customers
FROM stg_credit_customers;

-- duplicate customers

SELECT
    ID,
    COUNT(*) AS duplicate_count
FROM stg_credit_customers
GROUP BY ID
HAVING COUNT(*) > 1;

-- missing values

SELECT
    SUM(ID IS NULL) AS missing_id,
    SUM(LIMIT_BAL IS NULL) AS missing_limit,
    SUM(AGE IS NULL) AS missing_age,
    SUM(`default payment next month` IS NULL) AS missing_default
FROM stg_credit_customers;

-- Credit Limit: Does every customer have a valid credit limit?

SELECT
    MIN(LIMIT_BAL) AS minimum_limit,
    MAX(LIMIT_BAL) AS maximum_limit,
    AVG(LIMIT_BAL) AS average_limit
FROM stg_credit_customers;

-- checking for invalid limits

SELECT COUNT(*) AS invalid_credit_limits
FROM stg_credit_customers
WHERE LIMIT_BAL <= 0;

-- Age: Unrealistic/ Impossible age

SELECT
    MIN(AGE) AS youngest_customer,
    MAX(AGE) AS oldest_customer,
    AVG(AGE) AS average_age
FROM stg_credit_customers;

SELECT *
FROM stg_credit_customers
WHERE AGE < 18
   OR AGE > 100;
   
-- gender codes

SELECT
    SEX,
    COUNT(*) AS customers
FROM stg_credit_customers
GROUP BY SEX;

-- education codes

SELECT
    EDUCATION,
    COUNT(*) AS customers
FROM stg_credit_customers
GROUP BY EDUCATION
ORDER BY EDUCATION;

-- marriage codes

SELECT
    MARRIAGE,
    COUNT(*) AS customers
FROM stg_credit_customers
GROUP BY MARRIAGE
ORDER BY MARRIAGE;

-- default distribution: How balanced is the dataset?

SELECT
    `default payment next month` AS default_status,
    COUNT(*) AS customers,
    ROUND(COUNT(*) * 100.0 /
          (SELECT COUNT(*) FROM stg_credit_customers),2) AS percentage
FROM stg_credit_customers
GROUP BY `default payment next month`;

-- Repayment Status

SELECT
    PAY_0,
    COUNT(*) AS customers
FROM stg_credit_customers
GROUP BY PAY_0
ORDER BY PAY_0;

-- Bill Amounts: check for -ve bill amounts

SELECT COUNT(*) AS negative_bill_amounts
FROM stg_credit_customers
WHERE BILL_AMT1 < 0;

-- Payment Amounts

SELECT
    MIN(PAY_AMT1) AS minimum_payment,
    MAX(PAY_AMT1) AS maximum_payment,
    AVG(PAY_AMT1) AS average_payment
FROM stg_credit_customers;

