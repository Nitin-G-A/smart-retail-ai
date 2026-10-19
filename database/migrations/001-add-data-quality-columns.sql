-- database/migrations/001-add-data-quality-columns.sql
-- Run ONCE in MySQL Workbench, after schema.sql and before mall-of-asia-data.sql.
--
-- Why: real mall data is not as complete as demo data.
--   * Unit (shop) numbers are not published anywhere reliable  -> shop_number must allow NULL.
--   * Prices are estimates, not shop-published                 -> price_is_estimate flag.
--   * Some directories disagree about a store's floor          -> floor_uncertain flag.
-- The UNIQUE index on shop_number stays: MySQL allows many NULLs in a UNIQUE column.

USE smart_retail;

ALTER TABLE shops
    MODIFY COLUMN shop_number VARCHAR(20) NULL,
    ADD COLUMN floor_uncertain   BOOLEAN NOT NULL DEFAULT FALSE AFTER floor,
    ADD COLUMN price_is_estimate BOOLEAN NOT NULL DEFAULT TRUE  AFTER max_price;

-- Check the result
DESCRIBE shops;
