-- Example calls for dynamic reports

-- Monthly Revenue Report
SELECT * FROM fn_monthly_revenue_report('2025-08-01', '2025-10-31', NULL);

-- Daily Revenue Report
SELECT * FROM fn_daily_revenue_report('2025-10-01', '2025-10-31', NULL);

-- Seller Performance Report
SELECT * FROM fn_seller_performance_report('2025-08-01', '2025-10-31');

-- Top Products per Brand
SELECT * FROM fn_top_products_per_brand_report('2025-08-01', '2025-10-31', 5);

-- Order Status Summary
SELECT * FROM fn_order_status_summary_report('2025-08-01', '2025-10-31', NULL);

-- Procedure usage: persist one status summary snapshot
CALL sp_snapshot_order_status_report('2025-08-01', '2025-10-31', NULL);

SELECT *
FROM report_snapshot
ORDER BY generated_at DESC
LIMIT 5;
