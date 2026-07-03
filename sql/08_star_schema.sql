CREATE TABLE dim_age_group
(
    age_group_id INT AUTO_INCREMENT PRIMARY KEY,
    age_group VARCHAR(20) UNIQUE
);

INSERT INTO dim_age_group(age_group)
SELECT DISTINCT age_group
FROM credit_customers
ORDER BY age_group;

CREATE TABLE dim_credit_band
(
    credit_band_id INT AUTO_INCREMENT PRIMARY KEY,
    credit_band VARCHAR(30) UNIQUE
);

INSERT INTO dim_credit_band(credit_band)
SELECT DISTINCT credit_band
FROM credit_customers;

CREATE TABLE dim_risk_category
(
    risk_category_id INT AUTO_INCREMENT PRIMARY KEY,
    risk_category VARCHAR(20) UNIQUE
);

INSERT INTO dim_risk_category(risk_category)
SELECT DISTINCT risk_category
FROM credit_customers;

CREATE TABLE dim_education
(
    education_id INT PRIMARY KEY,
    education_name VARCHAR(50)
);

INSERT INTO dim_education VALUES
(1,'Graduate School'),
(2,'University'),
(3,'High School'),
(4,'Others');

CREATE TABLE fact_customer_risk AS
SELECT
c.ID AS customer_id,
a.age_group_id,
cb.credit_band_id,
r.risk_category_id,
c.EDUCATION,
c.SEX,
c.MARRIAGE,
c.LIMIT_BAL,
c.total_bill,
c.total_payment,
c.payment_ratio,
c.max_delay,
c.risk_score,
c.`default payment next month` AS default_flag
FROM credit_customers c
JOIN dim_age_group a
ON c.age_group = a.age_group
JOIN dim_credit_band cb
ON c.credit_band = cb.credit_band
JOIN dim_risk_category r
ON c.risk_category = r.risk_category;

ALTER TABLE fact_customer_risk
ADD PRIMARY KEY(customer_id);

SELECT *
FROM fact_customer_risk
LIMIT 10;