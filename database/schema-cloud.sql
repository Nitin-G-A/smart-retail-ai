-- database/schema-cloud.sql — tables only, for a hosted MySQL such as Aiven (free plan).
-- Hosted MySQL gives you an admin user already, so there is no CREATE USER here.
-- Run it while connected to the server, then run mall-of-asia-data.sql.

CREATE DATABASE IF NOT EXISTS smart_retail CHARACTER SET utf8mb4;
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
    floor_uncertain BOOLEAN NOT NULL DEFAULT FALSE,
    shop_number     VARCHAR(20) NULL,
    min_price       DECIMAL(10,2) NOT NULL,
    max_price       DECIMAL(10,2) NOT NULL,
    description     VARCHAR(255) NULL,
    rating          DECIMAL(2,1) NULL,
    is_demo         BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (shop_id),
    UNIQUE KEY uq_shops_shop_number (shop_number),
    KEY idx_shops_category_min_price (category_id, min_price),
    CONSTRAINT fk_shops_category FOREIGN KEY (category_id) REFERENCES categories (category_id),
    CONSTRAINT chk_shops_min_price CHECK (min_price >= 0),
    CONSTRAINT chk_shops_max_price CHECK (max_price >= min_price),
    CONSTRAINT chk_shops_rating CHECK (rating IS NULL OR (rating >= 0 AND rating <= 5))
    );
