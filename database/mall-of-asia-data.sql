-- database/mall-of-asia-data.sql
-- Phoenix Mall of Asia, Bellary Road, Byatarayanapura, Bengaluru (compiled 2026-10-18).
--
-- WHAT IS REAL AND WHAT IS NOT
--   * Shop names and floors: taken from third-party public directories (explorebangalore.com,
--     mallsinbangalore.com) and cross-checked against district.in and magicpin.in.
--     The mall's own website blocks automated access, so it was NOT used. Directories can be
--     out of date, so confirm at the mall. floor_uncertain = TRUE marks stores whose floor
--     differs between directories.
--   * shop_number: NO source publishes unit numbers, so these are PLACEHOLDERS (floor code +
--     running number, e.g. G-01, UG-03). They are NOT the mall's real unit numbers; the app
--     labels them "sample". INOX has no floor, so no number. Replace with real ones if you get them.
--   * min_price / max_price: ESTIMATES by brand positioning (budget / mid / upper-mid /
--     premium / luxury), not prices published by the shops. The app labels every real-shop price "est.".
--     For food they are typical spend per person; for entertainment, per visit.
--   * rating: no reliable data, so NULL.
--   * Categories: the app has four categories. Beauty, jewellery, watches, luggage and home
--     stores are filed under "Fashion & Apparel" (see each shop's description). PlayStation is
--     filed under "Electronics & Technology". Sawasdee Spa is filed under "Entertainment & Leisure".
--
-- Run in MySQL Workbench AFTER schema.sql and migrations/001 and 002.
-- Safe to run more than once: it replaces ALL rows in shops.

USE smart_retail;

INSERT IGNORE INTO categories (category_name) VALUES
  ('Fashion & Apparel'),
  ('Food & Beverage'),
  ('Entertainment & Leisure'),
  ('Electronics & Technology');

-- "AND shop_id > 0" is only there so Workbench's safe-update mode allows the DELETE.
DELETE FROM shops WHERE shop_id > 0;
ALTER TABLE shops AUTO_INCREMENT = 1;

INSERT INTO shops
(shop_name, category_id, floor, floor_uncertain, shop_number, min_price, max_price, description, rating, is_demo)
VALUES

    -- Fashion & Apparel
    ('Bata Premium', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-02', 1499, 7999, 'Footwear (premium range).', NULL, FALSE),
    ('Beverly Hills Polo Club (BHPC)', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-03', 1499, 7999, 'Casual apparel and accessories.', NULL, FALSE),
    ('Blackberrys', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-04', 1499, 7999, 'Menswear.', NULL, FALSE),
    ('Celio', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-05', 799, 3999, 'Men''s casualwear.', NULL, FALSE),
    ('ColorPlus', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-07', 799, 3999, 'Menswear.', NULL, FALSE),
    ('Columbia', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-08', 1499, 7999, 'Outdoor apparel and footwear.', NULL, FALSE),
    ('FCUK', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-09', 1499, 7999, 'Fashion label FCUK (French Connection).', NULL, FALSE),
    ('Fit Flop', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-10', 1499, 7999, 'Comfort footwear.', NULL, FALSE),
    ('Fizzy Goblet', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-11', 799, 3999, 'Women''s fashion.', NULL, FALSE),
    ('Force IX', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-12', 799, 3999, 'Activewear and sportswear.', NULL, FALSE),
    ('Gioia', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-13', 799, 3999, 'Fashion store.', NULL, FALSE),
    ('Hamster London', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-14', 999, 7999, 'Handbags and accessories.', NULL, FALSE),
    ('Helios', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-15', 15000, 200000, 'Multi-brand watch boutique.', NULL, FALSE),
    ('House of Delsey', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-16', 1999, 14999, 'Delsey luggage and bags.', NULL, FALSE),
    ('House of Rare', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-17', 1499, 7999, 'Fashion store.', NULL, FALSE),
    ('Inc 5 & Atesber', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-18', 1499, 7999, 'Fashion store.', NULL, FALSE),
    ('Jack & Jones', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-19', 799, 3999, 'Menswear.', NULL, FALSE),
    ('Just In Time', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-20', 3000, 20000, 'Multi-brand watch and accessories retailer.', NULL, FALSE),
    ('La Martina', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-21', 3999, 19999, 'Polo-inspired apparel.', NULL, FALSE),
    ('La Vie En Rose', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-22', 799, 3999, 'Lingerie and sleepwear.', NULL, FALSE),
    ('Lamy', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-23', 999, 7999, 'Pens and writing instruments.', NULL, FALSE),
    ('Louis Philippe Sport', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-24', 799, 3999, 'Casual menswear.', NULL, FALSE),
    ('Made to Measure', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-25', 1499, 7999, 'Made-to-measure clothing.', NULL, FALSE),
    ('Make Your Own Perfume', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-26', 499, 3999, 'Build-your-own perfume experience.', NULL, FALSE),
    ('Malabar Gold & Diamonds', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-27', 5000, 300000, 'Gold, diamond and silver jewellery.', NULL, FALSE),
    ('Mango Man', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-28', 1499, 7999, 'Menswear.', NULL, FALSE),
    ('Metro', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-29', 799, 3999, 'Footwear and bags.', NULL, FALSE),
    ('Miniso', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-30', 99, 2999, 'Value lifestyle products: accessories, stationery and home items.', NULL, FALSE),
    ('Mokobara', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-31', 999, 7999, 'Travel luggage and bags.', NULL, FALSE),
    ('Nike', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-32', 1499, 7999, 'Sportswear and sneakers.', NULL, FALSE),
    ('Parcos Luxe', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-33', 1500, 9999, 'Fragrance and beauty retail.', NULL, FALSE),
    ('Samsonite Black Label', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-35', 3999, 29999, 'Premium luggage.', NULL, FALSE),
    ('Van Heusen Women', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-38', 799, 3999, 'Workwear and casualwear for women.', NULL, FALSE),
    ('Zivame', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Ground Floor', FALSE, 'G-39', 799, 3999, 'Lingerie and activewear.', NULL, FALSE),
    ('Bershka', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-01', 799, 3999, 'Youth fashion.', NULL, FALSE),
    ('Boss', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-02', 3999, 19999, 'Premium menswear.', NULL, FALSE),
    ('Brooks Brothers', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-03', 3999, 19999, 'American menswear.', NULL, FALSE),
    ('COS', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-04', 3999, 19999, 'Contemporary minimalist fashion.', NULL, FALSE),
    ('Dolce & Gabbana Beauty', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-05', 4000, 40000, 'Luxury cosmetics.', NULL, FALSE),
    ('Emporio Armani', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-06', 20000, 150000, 'Luxury fashion.', NULL, FALSE),
    ('Golden Goose', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-07', 20000, 150000, 'Luxury sneakers and apparel.', NULL, FALSE),
    ('Jo Malone', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-08', 4000, 40000, 'Luxury fragrance.', NULL, FALSE),
    ('Kyomi', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-09', 2000, 50000, 'Jewellery.', NULL, FALSE),
    ('Massimo Dutti', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-10', 3999, 19999, 'Premium fashion.', NULL, FALSE),
    ('Next', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-11', 1499, 7999, 'Fashion and homeware.', NULL, FALSE),
    ('Nicobar', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-12', 1499, 7999, 'Indian lifestyle brand: clothing and home.', NULL, FALSE),
    ('Off-White', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-13', 20000, 150000, 'Luxury streetwear.', NULL, FALSE),
    ('PMJ Jewels', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-14', 5000, 300000, 'Jewellery.', NULL, FALSE),
    ('Runway', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-15', 3999, 19999, 'Fashion store.', NULL, FALSE),
    ('Steve Madden', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-16', 1499, 7999, 'Footwear and handbags.', NULL, FALSE),
    ('Tissot', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-17', 15000, 200000, 'Swiss watches.', NULL, FALSE),
    ('TUMI', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-18', 15000, 150000, 'Premium luggage and bags.', NULL, FALSE),
    ('Uniqlo', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Upper Ground Floor', FALSE, 'UG-19', 799, 3999, 'Japanese casualwear and basics.', NULL, FALSE),
    ('Accessorize', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-01', 999, 7999, 'Fashion accessories, bags and jewellery.', NULL, FALSE),
    ('Adidas Originals', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-02', 1499, 7999, 'Sneakers and streetwear.', NULL, FALSE),
    ('Aldo Accessories', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-03', 1999, 14999, 'Bags and accessories.', NULL, FALSE),
    ('Allen Solly Women', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', TRUE, '1-04', 799, 3999, 'Women''s workwear and casualwear.', NULL, FALSE),
    ('Armani Exchange', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-06', 3999, 19999, 'Contemporary fashion.', NULL, FALSE),
    ('Bric''s', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-07', 15000, 150000, 'Italian luxury luggage and bags.', NULL, FALSE),
    ('Calvin Klein Underwear', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-08', 1499, 7999, 'Innerwear and loungewear.', NULL, FALSE),
    ('Clinique', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-09', 1500, 9999, 'Skincare and makeup.', NULL, FALSE),
    ('Colorbar', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-10', 499, 3999, 'Makeup.', NULL, FALSE),
    ('Daniel Wellington', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-11', 3000, 20000, 'Minimalist watches and accessories.', NULL, FALSE),
    ('Forest Essentials', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-12', 1500, 9999, 'Luxury Ayurvedic skincare.', NULL, FALSE),
    ('Geox', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-13', 1499, 7999, 'Footwear and apparel.', NULL, FALSE),
    ('Guess', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-14', 1499, 7999, 'Fashion and accessories.', NULL, FALSE),
    ('H&M', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-15', 799, 3999, 'Fashion for women, men and kids.', NULL, FALSE),
    ('H&M Home', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-16', 499, 9999, 'Home decor and furnishings.', NULL, FALSE),
    ('Jack & Jones Premium & Selected', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-17', 1499, 7999, 'Premium menswear.', NULL, FALSE),
    ('Kama Ayurveda', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-18', 1500, 9999, 'Ayurvedic skincare and wellness.', NULL, FALSE),
    ('L''Occitane', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-19', 1500, 9999, 'Skincare and fragrance.', NULL, FALSE),
    ('Lacoste', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-20', 3999, 19999, 'Polo shirts and sportswear.', NULL, FALSE),
    ('Laura Mercier', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-21', 1500, 9999, 'Makeup.', NULL, FALSE),
    ('Longines', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-22', 80000, 1000000, 'Swiss watches.', NULL, FALSE),
    ('MAC', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-23', 1500, 9999, 'Makeup.', NULL, FALSE),
    ('Marks & Spencer', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-25', 1499, 7999, 'Clothing and innerwear.', NULL, FALSE),
    ('Masaba', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-26', 3999, 19999, 'Designer fashion.', NULL, FALSE),
    ('Max', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-27', 299, 1999, 'Value fashion for the whole family.', NULL, FALSE),
    ('Melissa', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-28', 1499, 7999, 'Brazilian jelly shoes.', NULL, FALSE),
    ('Nykaa Luxe', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-30', 1500, 9999, 'Luxury beauty retail.', NULL, FALSE),
    ('Only', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-31', 799, 3999, 'Women''s fashion.', NULL, FALSE),
    ('Seiko', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-32', 15000, 200000, 'Japanese watches.', NULL, FALSE),
    ('Sephora', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-33', 1500, 9999, 'Multi-brand beauty retailer.', NULL, FALSE),
    ('Shantnu & Nikhil', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-34', 20000, 150000, 'Designer couture and menswear.', NULL, FALSE),
    ('The Body Shop', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-35', 499, 3999, 'Skincare, bath and body.', NULL, FALSE),
    ('Tommy Hilfiger', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-36', 3999, 19999, 'American casualwear.', NULL, FALSE),
    ('Vero Moda', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-37', 799, 3999, 'Women''s fashion.', NULL, FALSE),
    ('Zara', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'First Floor', FALSE, '1-38', 1499, 7999, 'Fashion for women, men and kids.', NULL, FALSE),
    ('Amukti', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-02', 799, 3999, 'Women''s apparel.', NULL, FALSE),
    ('De Royal', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-08', 799, 3999, 'Fashion store.', NULL, FALSE),
    ('Ethnix by Raymond', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-10', 1499, 7999, 'Ethnic menswear.', NULL, FALSE),
    ('Health and Glow', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-11', 199, 1499, 'Health, wellness and beauty retail.', NULL, FALSE),
    ('House of Pataudi', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-12', 3999, 19999, 'Menswear label.', NULL, FALSE),
    ('House of Raisons', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-13', 799, 3999, 'Fashion store.', NULL, FALSE),
    ('Jack & Jones', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-15', 799, 3999, 'Menswear.', NULL, FALSE),
    ('Jack & Jones Junior', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-16', 799, 3999, 'Kidswear.', NULL, FALSE),
    ('Kate & Oscar', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-17', 799, 3999, 'Fashion store.', NULL, FALSE),
    ('Koskii', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-18', 799, 3999, 'Women''s ethnic wear.', NULL, FALSE),
    ('Kushal''s', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-20', 499, 4999, 'Fashion jewellery.', NULL, FALSE),
    ('Mango Kids', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-22', 1499, 7999, 'Kidswear.', NULL, FALSE),
    ('Meena Bazaar', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-23', 799, 3999, 'Ethnic wear.', NULL, FALSE),
    ('Mohey', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-25', 1499, 7999, 'Women''s ethnic wear.', NULL, FALSE),
    ('Peora', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-26', 499, 4999, 'Fashion jewellery.', NULL, FALSE),
    ('Shaya', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-31', 2000, 50000, 'Jewellery.', NULL, FALSE),
    ('Taneira', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-32', 3999, 19999, 'Sarees and ethnic wear.', NULL, FALSE),
    ('Tanishq', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-33', 5000, 300000, 'Gold, diamond and silver jewellery.', NULL, FALSE),
    ('Taruni', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-34', 799, 3999, 'Ethnic wear.', NULL, FALSE),
    ('Tommy Kids + USPA Kids', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-35', 1499, 7999, 'Kidswear.', NULL, FALSE),
    ('Trends', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-36', 299, 1999, 'Value fashion.', NULL, FALSE),
    ('W', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Second Floor', FALSE, '2-37', 799, 3999, 'Women''s ethnic and western wear.', NULL, FALSE),
    ('Bagline', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Third Floor', FALSE, '3-02', 999, 7999, 'Bags and accessories.', NULL, FALSE),
    ('IT Luggage', (SELECT category_id FROM categories WHERE category_name = 'Fashion & Apparel'), 'Third Floor', FALSE, '3-18', 999, 7999, 'Luggage.', NULL, FALSE),

    -- Food & Beverage
    ('Aubree', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Ground Floor', TRUE, 'G-01', 250, 800, 'Cafe and desserts.', NULL, FALSE),
    ('Chaayos', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Ground Floor', FALSE, 'G-06', 100, 400, 'Chai, snacks and light meals.', NULL, FALSE),
    ('Perch', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Ground Floor', FALSE, 'G-34', 500, 1500, 'Cafe and restaurant.', NULL, FALSE),
    ('Starbucks', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Ground Floor', FALSE, 'G-36', 250, 800, 'Coffee chain.', NULL, FALSE),
    ('Third Wave Coffee', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Ground Floor', FALSE, 'G-37', 250, 800, 'Specialty coffee.', NULL, FALSE),
    ('Magnolia Bakery', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'First Floor', FALSE, '1-24', 250, 800, 'Bakery: cupcakes and banana pudding.', NULL, FALSE),
    ('Movenpick', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'First Floor', FALSE, '1-29', 250, 800, 'Ice cream and desserts.', NULL, FALSE),
    ('Badmaash', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Second Floor', FALSE, '2-03', 500, 1500, 'Modern Indian restaurant and bar.', NULL, FALSE),
    ('Burma Burma', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Second Floor', FALSE, '2-04', 1000, 3500, 'Burmese vegetarian restaurant.', NULL, FALSE),
    ('Cafe Noir', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Second Floor', FALSE, '2-05', 250, 800, 'Cafe.', NULL, FALSE),
    ('Caffé Allora', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Second Floor', FALSE, '2-06', 250, 800, 'Cafe.', NULL, FALSE),
    ('Eight', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Second Floor', FALSE, '2-09', 1000, 3500, 'Chinese and Japanese restaurant.', NULL, FALSE),
    ('Krispy Kreme', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Second Floor', TRUE, '2-19', 250, 800, 'Doughnuts and coffee.', NULL, FALSE),
    ('Kylin Experience', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Second Floor', FALSE, '2-21', 1000, 3500, 'Chinese restaurant.', NULL, FALSE),
    ('Punjab Grill', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Second Floor', TRUE, '2-28', 1000, 3500, 'North Indian fine dining.', NULL, FALSE),
    ('Asia Seven', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-01', 200, 700, 'Chinese food.', NULL, FALSE),
    ('Baskin Robbins', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-03', 100, 400, 'Ice cream.', NULL, FALSE),
    ('Bhartiya Jalpan', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-04', 100, 450, 'Indian snacks and street food.', NULL, FALSE),
    ('Biggies Burger', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-05', 100, 450, 'Burgers.', NULL, FALSE),
    ('Biryani Queen', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-06', 250, 700, 'Biryani restaurant.', NULL, FALSE),
    ('Boba Tree', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-07', 100, 400, 'Bubble tea and drinks.', NULL, FALSE),
    ('Buffalo Wild Wings', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-08', 500, 1500, 'Wings and sports bar.', NULL, FALSE),
    ('Burger King', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-09', 100, 450, 'Burgers.', NULL, FALSE),
    ('Cha Cha Cha', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-10', 500, 1500, 'Dim sum, sushi and stir fry.', NULL, FALSE),
    ('Dessert Works', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-11', 100, 400, 'Desserts.', NULL, FALSE),
    ('Dobaraa', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-12', 500, 1500, 'Restaurant.', NULL, FALSE),
    ('Domino''s Pizza', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-13', 100, 450, 'Pizza.', NULL, FALSE),
    ('Fyole', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-15', 500, 1500, 'Restaurant.', NULL, FALSE),
    ('Haagen-Dazs', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-16', 250, 800, 'Ice cream.', NULL, FALSE),
    ('Ishaara', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-17', 500, 1500, 'Restaurant.', NULL, FALSE),
    ('KFC', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-19', 100, 450, 'Fried chicken.', NULL, FALSE),
    ('Konfo', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-20', 500, 1500, 'Restaurant.', NULL, FALSE),
    ('Louisiana Kitchen', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-21', 500, 1500, 'Restaurant.', NULL, FALSE),
    ('Mad Over Donuts', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-22', 100, 400, 'Doughnuts.', NULL, FALSE),
    ('Melting Hearts', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-23', 100, 400, 'Food and dessert outlet.', NULL, FALSE),
    ('Milkshake & Co.', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-24', 100, 400, 'Milkshakes and desserts.', NULL, FALSE),
    ('Naga''s', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-25', 500, 1500, 'Restaurant.', NULL, FALSE),
    ('Nando''s', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-26', 500, 1500, 'Peri-peri chicken.', NULL, FALSE),
    ('Pizza Express', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-27', 500, 1500, 'Pizza restaurant.', NULL, FALSE),
    ('Pizza Hut', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-28', 100, 450, 'Pizza.', NULL, FALSE),
    ('Plaka', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-29', 200, 700, 'Food court outlet.', NULL, FALSE),
    ('Roastea', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-30', 100, 400, 'Tea and coffee.', NULL, FALSE),
    ('Sally By 1522', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-31', 1000, 3500, 'North Indian restaurant.', NULL, FALSE),
    ('Shiv Sagar', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-32', 250, 700, 'Vegetarian restaurant.', NULL, FALSE),
    ('Smoke - The Sizzler House', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-33', 500, 1500, 'Sizzlers and grills.', NULL, FALSE),
    ('Street Food by Punjab Grill', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-34', 200, 700, 'Street food.', NULL, FALSE),
    ('Udupi Kitchen', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-36', 100, 450, 'South Indian food.', NULL, FALSE),
    ('Wow China', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-37', 100, 450, 'Chinese fast food.', NULL, FALSE),
    ('WOW! Momo', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-38', 100, 450, 'Momos and Asian fast food.', NULL, FALSE),
    ('YouMee', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-39', 1000, 3500, 'Chinese restaurant.', NULL, FALSE),
    ('Ó', (SELECT category_id FROM categories WHERE category_name = 'Food & Beverage'), 'Third Floor', FALSE, '3-40', 500, 1500, 'Restaurant.', NULL, FALSE),

    -- Entertainment & Leisure
    ('Sawasdee Spa', (SELECT category_id FROM categories WHERE category_name = 'Entertainment & Leisure'), 'Second Floor', FALSE, '2-30', 1000, 6000, 'Thai spa and wellness.', NULL, FALSE),
    ('Funcity', (SELECT category_id FROM categories WHERE category_name = 'Entertainment & Leisure'), 'Third Floor', FALSE, '3-14', 200, 1500, 'Family entertainment and games zone.', NULL, FALSE),
    ('The Entertainment Store', (SELECT category_id FROM categories WHERE category_name = 'Entertainment & Leisure'), 'Third Floor', FALSE, '3-35', 200, 1500, 'Entertainment outlet.', NULL, FALSE),
    ('INOX Megaplex', (SELECT category_id FROM categories WHERE category_name = 'Entertainment & Leisure'), 'Floor not confirmed', TRUE, NULL, 200, 1500, 'Multiplex cinema.', NULL, FALSE),

    -- Electronics & Technology
    ('Apple Hebbal', (SELECT category_id FROM categories WHERE category_name = 'Electronics & Technology'), 'First Floor', FALSE, '1-05', 2000, 250000, 'Apple Store: iPhone, iPad, Mac, Watch and accessories.', NULL, FALSE),
    ('Acer Mall Exclusive Store', (SELECT category_id FROM categories WHERE category_name = 'Electronics & Technology'), 'Second Floor', FALSE, '2-01', 1000, 150000, 'Laptops, monitors and accessories.', NULL, FALSE),
    ('Croma', (SELECT category_id FROM categories WHERE category_name = 'Electronics & Technology'), 'Second Floor', FALSE, '2-07', 1000, 150000, 'Electronics and appliances retailer.', NULL, FALSE),
    ('HP World', (SELECT category_id FROM categories WHERE category_name = 'Electronics & Technology'), 'Second Floor', FALSE, '2-14', 1000, 150000, 'Laptops, printers and accessories.', NULL, FALSE),
    ('Mobikins', (SELECT category_id FROM categories WHERE category_name = 'Electronics & Technology'), 'Second Floor', FALSE, '2-24', 299, 5000, 'Mobile phones and accessories.', NULL, FALSE),
    ('PlayStation', (SELECT category_id FROM categories WHERE category_name = 'Electronics & Technology'), 'Second Floor', FALSE, '2-27', 1000, 150000, 'PlayStation consoles, games and accessories.', NULL, FALSE),
    ('Reliance Digital', (SELECT category_id FROM categories WHERE category_name = 'Electronics & Technology'), 'Second Floor', FALSE, '2-29', 1000, 150000, 'Electronics and appliances retailer.', NULL, FALSE);

-- Quick checks
SELECT COUNT(*) AS total_shops FROM shops;
SELECT c.category_name, COUNT(*) AS shops
FROM shops s JOIN categories c ON c.category_id = s.category_id
GROUP BY c.category_name ORDER BY c.category_id;
