package com.smartretail.backend.service;

import com.smartretail.backend.dto.ShopResponse;
import com.smartretail.backend.entity.Category;
import com.smartretail.backend.entity.Shop;
import com.smartretail.backend.exception.InvalidSearchException;
import com.smartretail.backend.repository.CategoryRepository;
import com.smartretail.backend.repository.ShopRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Comparator;
import java.util.List;

/**
 * Business logic: validates the search and ranks the shops.
 * Shop details always come from the database.
 */
@Service
@Transactional(readOnly = true)
public class ShopService {

    /** Same limit as MAX_BUDGET in the frontend config.js. */
    private static final BigDecimal MAX_BUDGET = new BigDecimal("1000000");

    private final ShopRepository shopRepository;
    private final CategoryRepository categoryRepository;

    public ShopService(ShopRepository shopRepository, CategoryRepository categoryRepository) {
        this.shopRepository = shopRepository;
        this.categoryRepository = categoryRepository;
    }

    /** Names of all categories, in database order. */
    public List<String> getCategoryNames() {
        return categoryRepository.findAllByOrderByCategoryIdAsc().stream()
                .map(Category::getCategoryName)
                .toList();
    }

    /** All shops, optionally limited to one category. */
    public List<ShopResponse> getShops(String category) {
        List<Shop> shops = shopRepository.findAllWithCategory();
        if (category == null || category.isBlank()) {
            return shops.stream().map(ShopResponse::from).toList();
        }
        String categoryName = requireKnownCategory(category);
        return shops.stream()
                .filter(shop -> shop.getCategory().getCategoryName().equalsIgnoreCase(categoryName))
                .map(ShopResponse::from)
                .toList();
    }

    /**
     * Recommends shops for a budget and category.
     * Rule: a shop is suitable when its lowest price is within the budget.
     * Ranking: shops whose whole price range fits come first, then higher rating
     * (shops with no rating last), then lower starting price.
     */
    public List<ShopResponse> recommend(BigDecimal budget, String category) {
        validateBudget(budget);
        String categoryName = requireKnownCategory(category);

        Comparator<Shop> ranking = Comparator
                .comparing((Shop shop) -> shop.getMaxPrice().compareTo(budget) <= 0 ? 0 : 1)
                .thenComparing(Shop::getRating, Comparator.nullsLast(Comparator.reverseOrder()))
                .thenComparing(Shop::getMinPrice);

        return shopRepository.findAffordableByCategory(categoryName, budget).stream()
                .sorted(ranking)
                .map(ShopResponse::from)
                .toList();
    }

    // ---------- validation (repeats the frontend checks, as the project rules require) ----------

    private void validateBudget(BigDecimal budget) {
        if (budget == null) {
            throw new InvalidSearchException("Budget is required.");
        }
        if (budget.signum() <= 0) {
            throw new InvalidSearchException("Budget must be greater than 0.");
        }
        if (budget.compareTo(MAX_BUDGET) > 0) {
            throw new InvalidSearchException("Budget cannot be more than " + MAX_BUDGET.toPlainString() + ".");
        }
    }

    /** Returns the trimmed category name, or throws if it is blank or not one of ours. */
    private String requireKnownCategory(String category) {
        if (category == null || category.isBlank()) {
            throw new InvalidSearchException("Category is required.");
        }
        String name = category.trim();
        if (!categoryRepository.existsByCategoryName(name)) {
            throw new InvalidSearchException(
                    "Unknown category '" + name + "'. Supported categories: " + String.join(", ", getCategoryNames()) + ".");
        }
        return name;
    }
}
