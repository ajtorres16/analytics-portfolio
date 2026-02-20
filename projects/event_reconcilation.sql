-- Reconciling Portfolio Positions Post-Merger
WITH PreEventPositions AS (
    SELECT 
        account_id, 
        security_id, 
        quantity AS old_qty, 
        cost_basis_per_share AS old_basis
    FROM portfolio_snapshot
    WHERE snapshot_date = '2025-12-30'
),

MergerRatio AS (
    -- Simulating a 1:1.5 stock swap (Acme Corp merging into Global Tech)
    SELECT 
        'ACME' AS target_ticker, 
        'GTECH' AS survivor_ticker, 
        1.5 AS exchange_ratio
)

SELECT 
    p.account_id,
    m.survivor_ticker,
    p.old_qty * m.exchange_ratio AS new_shares,
    p.old_basis / m.exchange_ratio AS adjusted_cost_basis,
    -- Audit flag to ensure positions were updated correctly
    'MERGER_ADJUSTMENT' AS action_type
FROM PreEventPositions p
JOIN MergerRatio m ON p.security_id = m.target_ticker;
