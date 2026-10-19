-- database/sample-data.sql
-- DEMO DATA ONLY. Every shop below is fictional (names start with "Demo") and the
-- floors, shop numbers and prices are invented for development. Do not present them
-- as real shops. Every row is flagged is_demo = TRUE.
--
-- Run this in MySQL Workbench AFTER schema.sql. It is safe to run more than once.

USE smart_retail;

-- The four supported categories (INSERT IGNORE skips ones that already exist)
INSERT IGNORE INTO categories (category_name) VALUES
  ('Fashion & Apparel'),
  ('Food & Beverage'),
  ('Entertainment & Leisure'),
  ('Electronics & Technology');

-- Remove old demo rows so re-running does not create duplicates.
-- ("AND shop_id > 0" is only there so Workbench's safe-update mode allows the DELETE.)
DELETE FROM shops WHERE is_demo = TRUE AND shop_id > 0;

INSERT INTO shops
(shop_name, category_id, floor, shop_number, min_price, max_price, description, rating, is_demo)
VALUES
    -- Food & Beverage
    ('Demo Cafe',
     (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'),
     'Ground Floor', 'GF-01', 100, 800, 'Coffee, sandwiches and desserts.', 4.2, TRUE),
    ('Demo Bites',
     (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'),
     'First Floor', 'FF-03', 150, 600, 'Quick-service burgers, wraps and fries.', NULL, TRUE),
    ('Demo Fine Dine',
     (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'),
     'Second Floor', 'SF-12', 900, 3000, 'Sit-down multi-cuisine restaurant.', 4.5, TRUE),

    -- Fashion & Apparel
    ('Demo Campus Casuals',
     (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'),
     'First Floor', 'FF-09', 499, 2200, 'Casual tees, joggers and hoodies for college.', 4.1, TRUE),
    ('Demo Threads',
     (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'),
     'Ground Floor', 'GF-07', 400, 3500, 'Everyday shirts, tops and dresses.', NULL, TRUE),
    ('Demo Denim Co.',
     (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'),
     'First Floor', 'FF-02', 800, 4000, 'Jeans, jackets and denim accessories.', 4.0, TRUE),
    ('Demo Ethnic Wear',
     (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'),
     'Second Floor', 'SF-05', 1500, 9000, 'Kurtas, sarees and festive wear.', NULL, TRUE),

    -- Entertainment & Leisure
    ('Demo Arcade Zone',
     (SELECT category_id FROM categories WHERE category_name = 'Entertainment & Leisure'),
     'Second Floor', 'SF-01', 200, 1500, 'Video games and arcade machines.', NULL, TRUE),
    ('Demo Cinema',
     (SELECT category_id FROM categories WHERE category_name = 'Entertainment & Leisure'),
     'Second Floor', 'SF-02', 250, 900, 'Movie screens with snack combos.', 4.3, TRUE),
    ('Demo Bowling Lanes',
     (SELECT category_id FROM categories WHERE category_name = 'Entertainment & Leisure'),
     'Second Floor', 'SF-08', 400, 1800, 'Bowling and group games.', NULL, TRUE),

    -- Electronics & Technology
    ('Demo Mobile Hub',
     (SELECT category_id FROM categories WHERE category_name = 'Electronics & Technology'),
     'Ground Floor', 'GF-12', 500, 60000, 'Phones, cases and chargers.', 4.1, TRUE),
    ('Demo Audio Store',
     (SELECT category_id FROM categories WHERE category_name = 'Electronics & Technology'),
     'First Floor', 'FF-14', 799, 15000, 'Earphones, headphones and speakers.', NULL, TRUE),
    ('Demo Gadget Bay',
     (SELECT category_id FROM categories WHERE category_name = 'Electronics & Technology'),
     'First Floor', 'FF-15', 299, 5000, 'Smartwatches, power banks and accessories.', 3.9, TRUE);

-- Quick check: should list 13 rows
SELECT s.shop_id, s.shop_name, c.category_name, s.floor, s.shop_number, s.min_price, s.max_price
FROM shops s JOIN categories c ON c.category_id = s.category_id
ORDER BY c.category_id, s.shop_id;
