-- Aggregating Flight Telemetry for Tax Compliance
WITH FlightData AS (
    SELECT 
        aircraft_tail_number,
        client_id,
        flight_hours,
        fuel_cost,
        departure_state,
        arrival_state,
        -- Identify if the flight is a taxable event based on state borders
        CASE WHEN departure_state <> arrival_state THEN 1 ELSE 0 END AS interstate_flag
    FROM telemetry_raw_logs
),

TaxCalculations AS (
    SELECT 
        client_id,
        COUNT(*) AS total_trips,
        SUM(flight_hours) AS total_hours,
        SUM(fuel_cost) AS total_fuel_spend,
        -- Simulating a complex tax logic based on hours and fuel
        SUM(flight_hours * 125.50 + fuel_cost * 0.08) AS estimated_tax_liability
    FROM FlightData
    GROUP BY client_id
)

-- Final view for Attorneys/CPAs
SELECT 
    c.client_name,
    t.total_trips,
    t.total_hours,
    ROUND(t.total_fuel_spend, 2) AS fuel_spend,
    ROUND(t.estimated_tax_liability, 2) AS tax_due,
    -- Projecting end-of-year costs
    ROUND((t.estimated_tax_liability / 10) * 12, 2) AS projected_annual_tax
FROM TaxCalculations t
JOIN crm_customer_profiles c ON t.client_id = c.client_id
ORDER BY tax_due DESC;
