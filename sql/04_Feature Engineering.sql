-- Which age groups have the highest default rates?

ALTER TABLE credit_customers
ADD COLUMN age_group VARCHAR(20);

UPDATE credit_customers
SET age_group =
CASE
    WHEN AGE BETWEEN 21 AND 30 THEN '21-30'
    WHEN AGE BETWEEN 31 AND 40 THEN '31-40'
    WHEN AGE BETWEEN 41 AND 50 THEN '41-50'
    WHEN AGE BETWEEN 51 AND 60 THEN '51-60'
    ELSE '60+'
END;

-- Do customers with larger credit limits default less often?

ALTER TABLE credit_customers
ADD COLUMN credit_band VARCHAR(30);

UPDATE credit_customers
SET credit_band =
CASE
    WHEN LIMIT_BAL < 50000 THEN 'Low'
    WHEN LIMIT_BAL < 150000 THEN 'Medium'
    WHEN LIMIT_BAL < 300000 THEN 'High'
    ELSE 'Premium'
END;

-- Total Bill: How much exposure does each customer have?

ALTER TABLE credit_customers
ADD COLUMN total_bill BIGINT;

UPDATE credit_customers
SET total_bill = BILL_AMT1 + BILL_AMT2 + BILL_AMT3 + BILL_AMT4 + BILL_AMT5 + BILL_AMT6;

-- Total Payment

ALTER TABLE credit_customers
ADD COLUMN total_payment BIGINT;

UPDATE credit_customers
SET total_payment =
PAY_AMT1 +
PAY_AMT2 +
PAY_AMT3 +
PAY_AMT4 +
PAY_AMT5 +
PAY_AMT6;

-- Payment Ratio: What percentage of their bills did customers actually repay?

ALTER TABLE credit_customers
ADD COLUMN payment_ratio DECIMAL(10,2);

UPDATE credit_customers
SET payment_ratio =
CASE
    WHEN total_bill = 0 THEN NULL
    ELSE ROUND(total_payment / total_bill,2)
END;

-- Maximum Delay: What is the worst repayment behaviour this customer has shown?

ALTER TABLE credit_customers
ADD COLUMN max_delay INT;

UPDATE credit_customers
SET max_delay =
GREATEST(
PAY_0,
PAY_2,
PAY_3,
PAY_4,
PAY_5,
PAY_6
);

-- Risk Category : classification of customers based on repayment history

ALTER TABLE credit_customers
ADD COLUMN risk_category VARCHAR(20);

UPDATE credit_customers
SET risk_category =
CASE
    WHEN max_delay <= 0 THEN 'Low Risk'
    WHEN max_delay <= 2 THEN 'Medium Risk'
    ELSE 'High Risk'
END;