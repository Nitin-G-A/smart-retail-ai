package com.smartretail.backend.dto;

import com.smartretail.backend.entity.Shop;

import java.math.BigDecimal;

/**
 * The JSON shape sent to the frontend. Field names match what js/app.js reads
 * (shopName, shopNumber, minPrice, ...). A record is a short class whose fields are fixed.
 */
public record ShopResponse(
        Integer shopId,
        String shopName,
        String category,
        String floor,
        boolean floorUncertain,
        String shopNumber,
        BigDecimal minPrice,
        BigDecimal maxPrice,
        String description,
        BigDecimal rating,
        boolean demo) {

    /** Converts a database entity into the response shape. */
    public static ShopResponse from(Shop shop) {
        return new ShopResponse(
                shop.getShopId(),
                shop.getShopName(),
                shop.getCategory().getCategoryName(),
                shop.getFloor(),
                shop.isFloorUncertain(),
                shop.getShopNumber(),
                shop.getMinPrice(),
                shop.getMaxPrice(),
                shop.getDescription(),
                shop.getRating(),
                shop.isDemo());
    }
}
