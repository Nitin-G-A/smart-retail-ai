-- database/schema.sql — FINAL schema for a fresh install (MySQL 8.0.16+).
-- Run in MySQL Workbench as an admin user (e.g. root). Then run mall-of-asia-data.sql.
--
-- Already have the older database? Don't run this; use database/migrations/001 and 002 instead.
-- Before running, change CHANGE_ME below to your own password and use the same one in DB_PASSWORD.

CREATE DATABASE IF NOT EXISTS smart_retail CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE smart_retail;

CREATE TABLE IF NOT EXISTS categories (
                                          category_id   INT NOT NULL AUTO_INCREMENT,
                                          category_name VARCHAR(50) NOT NULL,
    PRIMARY KEY (category_id),
    UNIQUE KEY uq_categories_name (category_name)
    );

CREATE TABLE IF NOT EXISTS shops (
                                     shop_id         INT NOT NULL AUTO_INCREMENT,
                                     shop_name       VARCHAR(100) NOT NULL,
    category_id     INT NOT NULL,
    floor           VARCHAR(30) NOT NULL,
    floor_uncertain BOOLEAN NOT NULL DEFAULT FALSE,   -- public sources disagree about the floor
    shop_number     VARCHAR(20) NULL,                 -- NULL = unknown (this project uses placeholders)
    min_price       DECIMAL(10,2) NOT NULL,
    max_price       DECIMAL(10,2) NOT NULL,
    description     VARCHAR(255) NULL,
    rating          DECIMAL(2,1) NULL,                -- NULL = no reliable rating
    is_demo         BOOLEAN NOT NULL DEFAULT TRUE,    -- TRUE = fictional development data
    PRIMARY KEY (shop_id),
    UNIQUE KEY uq_shops_shop_number (shop_number),
    KEY idx_shops_category_min_price (category_id, min_price),
    CONSTRAINT fk_shops_category FOREIGN KEY (category_id) REFERENCES categories (category_id),
    CONSTRAINT chk_shops_min_price CHECK (min_price >= 0),
    CONSTRAINT chk_shops_max_price CHECK (max_price >= min_price),
    CONSTRAINT chk_shops_rating CHECK (rating IS NULL OR (rating >= 0 AND rating <= 5))
    );

-- Least-privilege account used by the Spring Boot app (no DROP/ALTER rights)
CREATE USER IF NOT EXISTS 'smartretail_app'@'localhost' IDENTIFIED BY 'CHANGE_ME';
GRANT SELECT, INSERT, UPDATE, DELETE ON smart_retail.* TO 'smartretail_app'@'localhost';
FLUSH PRIVILEGES;
