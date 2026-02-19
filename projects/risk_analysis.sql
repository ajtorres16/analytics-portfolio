-- Step 1: Aggregate client financial behaviors
WITH ClientMetrics AS (
    SELECT 
        client_id,
        region,
        credit_utilization,
        payment_history_score, -- 1 to 100
        total_debt_load,
        -- Calculate a weighted risk score
        (credit_utilization * 0.4) + ((100 - payment_history_score) * 0.6) AS raw_risk_score
    FROM portfolio_data
),

-- Step 2: Segment into Tiers and calculate Regional Benchmarks
RiskAnalysis AS (
    SELECT 
        client_id,
        region,
        raw_risk_score,
        CASE 
            WHEN raw_risk_score > 75 THEN 'High Risk'
            WHEN raw_risk_score BETWEEN 40 AND 75 THEN 'Medium Risk'
            ELSE 'Low Risk'
        END AS risk_tier,
        -- Window function to show how this client compares to their peers
        AVG(raw_risk_score) OVER(PARTITION BY region) AS regional_avg_risk
    FROM ClientMetrics
)

-- Step 3: Final Output for Business Stakeholders
SELECT 
    client_id,
    region,
    ROUND(raw_risk_score, 2) AS risk_score,
    risk_tier,
    ROUND(raw_risk_score - regional_avg_risk, 2) AS variance_from_avg
FROM RiskAnalysis
WHERE risk_tier = 'High Risk'
ORDER BY variance_from_avg DESC;
