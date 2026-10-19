-- database/migrations/002-drop-price-is-estimate.sql
-- Run ONCE after 001. Every real-shop price is an estimate, so the column carried no information.
-- The app now always labels real-shop prices "est.".
USE smart_retail;
ALTER TABLE shops DROP COLUMN price_is_estimate;
DESCRIBE shops;
