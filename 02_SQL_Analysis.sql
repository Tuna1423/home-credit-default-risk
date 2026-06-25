-- Query 1: Default Rate theo Giới tính & Học vấn
SELECT 
    CODE_GENDER,
    NAME_EDUCATION_TYPE,
    COUNT(*) AS total_applications,
    SUM(TARGET) AS total_defaults,
    ROUND(AVG(TARGET) * 100, 2) AS default_rate_pct
FROM application
GROUP BY CODE_GENDER, NAME_EDUCATION_TYPE
ORDER BY default_rate_pct DESC;

-- Query 2: Risk Ranking theo Thu nhập
SELECT 
    NAME_INCOME_TYPE,
    COUNT(*) AS total,
    ROUND(AVG(TARGET) * 100, 2) AS default_rate_pct,
    RANK() OVER (ORDER BY AVG(TARGET) DESC) AS risk_rank
FROM application
GROUP BY NAME_INCOME_TYPE
ORDER BY risk_rank;

-- Query 3: Default Rate theo Nhóm tuổi
WITH age_group AS (
    SELECT 
        CASE 
            WHEN (DAYS_BIRTH / -365) BETWEEN 20 AND 30 THEN '20-30'
            WHEN (DAYS_BIRTH / -365) BETWEEN 31 AND 40 THEN '31-40'
            WHEN (DAYS_BIRTH / -365) BETWEEN 41 AND 50 THEN '41-50'
            WHEN (DAYS_BIRTH / -365) BETWEEN 51 AND 60 THEN '51-60'
            ELSE '60+'
        END AS age_band,
        TARGET
    FROM application
)
SELECT
    age_band,
    COUNT(*) AS total,
    SUM(TARGET) AS defaults,
    ROUND(AVG(TARGET) * 100, 2) AS default_rate_pct,
    SUM(SUM(TARGET)) OVER (ORDER BY age_band) AS running_total_defaults
FROM age_group
GROUP BY age_band
ORDER BY age_band;

-- Query 4: Default Rate theo Loại hợp đồng & Loại thu nhập
SELECT 
    a.NAME_CONTRACT_TYPE,
    a.NAME_INCOME_TYPE,
    COUNT(DISTINCT a.SK_ID_CURR) AS total_customers,
    ROUND(AVG(a.TARGET) * 100, 2) AS default_rate_pct,
    ROUND(AVG(b.AMT_CREDIT_SUM_OVERDUE), 2) AS avg_overdue_amount
FROM application a
LEFT JOIN (
    SELECT 
        SK_ID_CURR,
        AVG(AMT_CREDIT_SUM_OVERDUE) AS AMT_CREDIT_SUM_OVERDUE
    FROM bureau
    GROUP BY SK_ID_CURR
) b ON a.SK_ID_CURR = b.SK_ID_CURR
GROUP BY a.NAME_CONTRACT_TYPE, a.NAME_INCOME_TYPE
HAVING total_customers > 100
ORDER BY default_rate_pct DESC
LIMIT 15;

