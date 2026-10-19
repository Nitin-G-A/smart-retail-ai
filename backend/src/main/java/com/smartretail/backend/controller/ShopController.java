package com.smartretail.backend.controller;

import com.smartretail.backend.dto.ShopResponse;
import com.smartretail.backend.service.ShopService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.List;

/**
 * Shop endpoints. The controller only reads the request and calls the service;
 * all rules live in ShopService.
 *
 *   GET /api/shops                                  all shops (optional ?category=...)
 *   GET /api/shops/recommend?budget=1500&category=Food%20%26%20Beverage
 */
@RestController
@RequestMapping("/api/shops")
public class ShopController {

    private final ShopService shopService;

    public ShopController(ShopService shopService) {
        this.shopService = shopService;
    }

    @GetMapping
    public List<ShopResponse> getShops(@RequestParam(name = "category", required = false) String category) {
        return shopService.getShops(category);
    }

    @GetMapping("/recommend")
    public List<ShopResponse> recommend(@RequestParam("budget") BigDecimal budget,
                                        @RequestParam("category") String category) {
        return shopService.recommend(budget, category);
    }
}
