-- ─────────────────────────────────────────
-- load_data.sql
-- Loads all Olist CSV files into OlistRetail database
-- Update the file paths below to match your local folder
-- ─────────────────────────────────────────

USE OlistRetail;

-- ⚠️ UPDATE THIS PATH to where your CSV files are stored
-- Example: 'C:\olist\olist_customers_dataset.csv'

BULK INSERT customers
FROM 'YOUR\PATH\TO\olist_customers_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
PRINT 'customers loaded ✓';

BULK INSERT products
FROM 'YOUR\PATH\TO\olist_products_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
PRINT 'products loaded ✓';

BULK INSERT sellers
FROM 'YOUR\PATH\TO\olist_sellers_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
PRINT 'sellers loaded ✓';

BULK INSERT orders
FROM 'YOUR\PATH\TO\olist_orders_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
PRINT 'orders loaded ✓';

BULK INSERT order_items
FROM 'YOUR\PATH\TO\olist_order_items_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
PRINT 'order_items loaded ✓';

BULK INSERT order_payments
FROM 'YOUR\PATH\TO\olist_order_payments_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
PRINT 'order_payments loaded ✓';

BULK INSERT order_reviews
FROM 'YOUR\PATH\TO\olist_order_reviews_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', MAXERRORS = 9999, TABLOCK);
PRINT 'order_reviews loaded ✓';

BULK INSERT geolocation
FROM 'YOUR\PATH\TO\olist_geolocation_dataset.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', MAXERRORS = 9999, TABLOCK);
PRINT 'geolocation loaded ✓';

BULK INSERT product_category_translation
FROM 'YOUR\PATH\TO\product_category_name_translation.csv'
WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '0x0a', CODEPAGE = '65001', TABLOCK);
PRINT 'product_category_translation loaded ✓';

-- ─────────────────────────────────────────
-- Verify all tables loaded correctly
-- ─────────────────────────────────────────
SELECT 'customers' as table_name, COUNT(*) as row_count FROM customers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'sellers', COUNT(*) FROM sellers
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'order_payments', COUNT(*) FROM order_payments
UNION ALL SELECT 'order_reviews', COUNT(*) FROM order_reviews
UNION ALL SELECT 'geolocation', COUNT(*) FROM geolocation
UNION ALL SELECT 'product_category_translation', COUNT(*) FROM product_category_translation;
