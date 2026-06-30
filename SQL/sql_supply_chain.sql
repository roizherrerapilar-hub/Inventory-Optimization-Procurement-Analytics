CREATE DATABASE supply_chain_control_tower;
USE supply_chain_control_tower;

SHOW TABLES;

RENAME TABLE `dataset_final+api`
TO supply_chain;

SELECT COUNT(*)
FROM supply_chain;

DESCRIBE supply_chain;

-- Query 1: Which suppliers concentrate the highest procurement spend?
SELECT
    supplier_id,
    ROUND(SUM(procurement_spend), 2) AS total_spend
FROM supply_chain
GROUP BY supplier_id
ORDER BY total_spend DESC
LIMIT 5;

-- SUP_7 and SUP_8 stand out as the suppliers with the highest procurement spend, each exceeding 2.7 million.
-- This indicates that a significant share of purchasing activity depends on a limited number of suppliers,
-- which should be considered from an operational risk perspective.

-- Query 2: Which warehouses concentrate the highest inventory value?
SELECT
    warehouse_id,
    ROUND(SUM(inventory_value), 2) AS total_inventory_value
FROM supply_chain
GROUP BY warehouse_id
ORDER BY total_inventory_value DESC;

-- The analysis shows relevant differences in inventory value across warehouses.
-- WH_2 holds more than 12 million in inventory value, while WH_3 remains below 10 million.
-- This may indicate a higher stock requirement in that location or an opportunity to review inventory distribution.

-- Query 3: Which suppliers have the longest lead times?
SELECT
    supplier_id,
    ROUND(AVG(supplier_lead_time_days), 2) AS avg_lead_time
FROM supply_chain
GROUP BY supplier_id
ORDER BY avg_lead_time DESC;

-- Supplier lead times vary between 6.96 and 8.64 days.
-- When combined with procurement spend, this information helps identify strategic suppliers with higher operational exposure.
-- Monitoring spend and lead time together supports supplier risk prioritization.

-- Query 4: Which regions have the highest inventory coverage compared to forecast demand?
SELECT
    region,
    ROUND(AVG(inventory_coverage), 2) AS avg_inventory_coverage
FROM supply_chain
GROUP BY region
ORDER BY avg_inventory_coverage DESC;

-- Average inventory coverage is relatively similar across regions, ranging from 43.92 to 45.91.
-- This suggests a balanced planning strategy, with inventory levels consistently aligned with forecast demand across regions.

-- Query 5: In which regions is demand forecasting less accurate?
SELECT
    region,
    ROUND(AVG(abs_forecast_error), 2) AS avg_forecast_error
FROM supply_chain
GROUP BY region
ORDER BY avg_forecast_error DESC;

SELECT
    region,
    MIN(abs_forecast_error) AS min_forecast_error,
    MAX(abs_forecast_error) AS max_forecast_error,
    ROUND(AVG(abs_forecast_error), 2) AS avg_forecast_error
FROM supply_chain
GROUP BY region;

-- Forecast error remains very similar across regions, with an average absolute error of around 2.38 units.
-- This indicates stable forecast performance and no significant regional deviations requiring specific planning actions.

-- Query 6: Which suppliers generate the highest number of replenishment orders?
SELECT
    supplier_id,
    SUM(replenishment_flag) AS total_replenishments
FROM supply_chain
GROUP BY supplier_id
ORDER BY total_replenishments DESC;

-- SUP_7 and SUP_8 generate the highest number of replenishment orders, with 679 and 567 replenishments respectively.
-- These suppliers also show high procurement spend, making them strategic suppliers that require continuous monitoring.

-- Query 7: Which regions concentrate the highest demand volume?
SELECT
    region,
    ROUND(SUM(units_sold), 0) AS total_units_sold
FROM supply_chain
GROUP BY region
ORDER BY total_units_sold DESC;

-- Demand is evenly distributed across the analysed regions.
-- No region concentrates a significantly higher share of sales compared to the others.

-- Query 8: Which products concentrate the highest inventory value?
SELECT
    sku_id,
    ROUND(SUM(inventory_value), 2) AS total_inventory_value
FROM supply_chain
GROUP BY sku_id
ORDER BY total_inventory_value DESC
LIMIT 10;

-- Some products concentrate a significant share of total inventory value.
-- SKU_38 stands out as the product with the highest stored value, exceeding 16 million.
-- This suggests the need for inventory segmentation and prioritization based on financial impact.

-- Query 9: Which warehouses maintain the highest inventory coverage?
SELECT
    warehouse_id,
    ROUND(AVG(inventory_coverage), 2) AS avg_inventory_coverage
FROM supply_chain
GROUP BY warehouse_id
ORDER BY avg_inventory_coverage DESC;

-- WH_2 shows the highest average inventory coverage, reaching 50.65.
-- Combined with its high inventory value, this warehouse becomes a priority candidate for future inventory optimization initiatives.

-- Query 10: Which products show the highest deviations between forecast demand and actual demand?
SELECT
    sku_id,
    ROUND(AVG(abs_forecast_error), 2) AS avg_forecast_error
FROM supply_chain
GROUP BY sku_id
ORDER BY avg_forecast_error DESC
LIMIT 10;

-- Forecast error remains stable across the analysed SKUs.
-- No specific group of products shows significantly higher deviations, suggesting consistent forecast performance at SKU level.

-- Query 11: Which suppliers represent the highest operational risk?
-- Criteria: high procurement spend combined with high supplier lead time.
SELECT
    supplier_id,
    ROUND(SUM(procurement_spend), 2) AS total_spend,
    ROUND(AVG(supplier_lead_time_days), 2) AS avg_lead_time
FROM supply_chain
GROUP BY supplier_id
ORDER BY total_spend DESC;

-- Combining procurement spend and lead time helps identify strategic suppliers with higher operational exposure.
-- SUP_8 and SUP_4 stand out for combining high spend with above-average lead times.
-- This increases their potential impact on supply continuity.

-- Query 12: What is the total exchange rate impact on procurement spend?
SELECT
    ROUND(SUM(procurement_spend), 2) AS total_spend_usd,
    ROUND(SUM(procurement_spend_eur), 2) AS total_spend_eur,
    ROUND(SUM(fx_impact), 2) AS total_fx_impact
FROM supply_chain;

-- Converting procurement costs from USD to EUR generates an accumulated difference of approximately 1.59 million.
-- This shows that exchange rate fluctuations can have a relevant impact on reported procurement costs in international operations.

-- Query 13: Which suppliers have the highest exchange rate exposure?
SELECT
    supplier_id,
    ROUND(SUM(procurement_spend), 2) AS total_spend_usd,
    ROUND(SUM(procurement_spend_eur), 2) AS total_spend_eur,
    ROUND(SUM(fx_impact), 2) AS total_fx_impact
FROM supply_chain
GROUP BY supplier_id
ORDER BY total_fx_impact DESC;

-- Suppliers with the highest purchasing volume also generate the greatest FX exposure.
-- SUP_8 and SUP_7 stand out as the suppliers with the highest accumulated USD/EUR conversion impact.