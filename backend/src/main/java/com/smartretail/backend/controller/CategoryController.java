package com.smartretail.backend.controller;

import com.smartretail.backend.service.ShopService;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * GET /api/categories : the category names, e.g. ["Fashion & Apparel", "Food & Beverage", ...].
 */
@RestController
@RequestMapping("/api/categories")
public class CategoryController {

    private final ShopService shopService;

    public CategoryController(ShopService shopService) {
        this.shopService = shopService;
    }

    @GetMapping
    public List<String> getCategories() {
        return shopService.getCategoryNames();
    }
}
