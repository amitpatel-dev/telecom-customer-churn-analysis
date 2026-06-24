-- Customer Overview
SELECT COUNT(*) AS total_customers 
FROM telco_churn; 

-- Churned Customers.
SELECT Churn, COUNT(*) AS customers 
FROM telco_churn 
GROUP BY Churn; 

-- Overall Churned Rate.
SELECT 
     ROUND( 
       100 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
       /COUNT(*), 2
	) AS churn_rate
FROM telco_churn; 

-- Churn BY Customer Segments. 

-- CONTRACT TYPE 
WITH contract_summary AS
(
    SELECT
        Contract,
        COUNT(*) AS total_customers,
        SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END) AS churned
    FROM telco_churn
    GROUP BY Contract
)

SELECT *,
       ROUND(
           100 * churned / total_customers,
           2
       ) AS churn_rate
FROM contract_summary; 

-- INTERNET SERVICES 
SELECT 
   InternetService, 
   COUNT(*) AS customers, 
   ROUND( 
      100 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
	/COUNT(*), 
2 ) AS churn_rate 
FROM telco_churn 
GROUP BY InternetService ; 

-- PAYMENT METHOD 
SELECT 
   PaymentMethod, 
   COUNT(*) AS customers, 
   ROUND(
       100 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END)
	 /COUNT(*), 
	2 ) AS churn_rate 
FROM telco_churn 
GROUP BY PaymentMethod ; 

-- SENIOR CITIZEN 
SELECT 
   SeniorCitizen, 
   COUNT(*) AS customers, 
   ROUND( 
        100*SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) 
        / COUNT(*),2 
	) AS churn_rate 
FROM telco_churn 
GROUP BY SeniorCitizen; 

-- GENDER 
SELECT
    gender,
    COUNT(*) AS customers,
    ROUND(
        100 * SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate
FROM telco_churn
GROUP BY gender;

-- CHURN BY MULTIPLE FACTORS
SELECT
    Contract,
    InternetService,
    COUNT(*) AS customers,
    ROUND(
        100 * SUM(CASE WHEN Churn='Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS churn_rate
FROM telco_churn
GROUP BY Contract, InternetService
ORDER BY churn_rate DESC;

-- Revenue Analysis 

-- OVERALL REVENUE
SELECT 
ROUND(
   SUM(MonthlyCharges),2) AS total_monthly_revenue
FROM telco_churn; 

-- REVENUE AT RISK DUE TO CHURN
SELECT 
   ROUND(SUM(MonthlyCharges),2) AS revenue_at_risk 
FROM telco_churn 
WHERE Churn = 'Yes'; 

-- Average monthly charges for churned and non-churned customers.
SELECT 
   Churn, 
   ROUND(
      AVG(MonthlyCharges),2) AS avg_monthly_charge 
FROM telco_churn 
GROUP BY Churn; 

-- Top Revenue Contributing Customer Segments
SELECT
    Contract,
    ROUND(SUM(TotalCharges),2) AS total_revenue
FROM telco_churn
GROUP BY Contract
ORDER BY total_revenue DESC;

-- Above Average Monthly Charges
SELECT
    customerID,
    MonthlyCharges
FROM telco_churn
WHERE MonthlyCharges >
(
    SELECT AVG(MonthlyCharges)
    FROM telco_churn
);

-- Tenure Groups: 
SELECT 
     CASE 
         WHEN tenure <= 12 THEN '0-1 Year'
         WHEN tenure <= 24 THEN '1-2 Year' 
         WHEN tenure <= 48 THEN '2-4 Year' 
         ELSE '4+ Years' 
	 END AS tenure_group, 
     COUNT(*) AS customers, 
     ROUND( 
        100 * SUM(CASE WHEN Churn = 'Yes' THEN 1 ELSE 0 END) /
        COUNT(*),2 ) AS churn_rate 
FROM telco_churn 
GROUP BY tenure_group 
ORDER BY churn_rate DESC; 

-- TOP 10 Highest-paying churned customers: 
SELECT * 
FROM
   ( SELECT customerID, MonthlyCharges, 
   ROW_NUMBER() OVER( ORDER BY MonthlyCharges DESC ) AS rn 
FROM telco_churn WHERE Churn ='Yes' )t WHERE rn <= 10;

-- Rank Customers by Revenue
SELECT
    customerID,
    TotalCharges,
    RANK() OVER(
        ORDER BY TotalCharges DESC
    ) AS revenue_rank
FROM telco_churn
WHERE TotalCharges >= 5000;

-- Potential Revenue at risk based on MonthlyCharges.
SELECT
      Contract,
      SUM(MonthlyCharges)
FROM telco_churn
WHERE Churn = 'Yes'
GROUP BY Contract
ORDER BY SUM(MonthlyCharges) DESC
;


      
