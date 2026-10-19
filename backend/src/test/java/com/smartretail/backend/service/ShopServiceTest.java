package com.smartretail.backend.service;

import com.smartretail.backend.dto.ShopResponse;
import com.smartretail.backend.entity.Category;
import com.smartretail.backend.entity.Shop;
import com.smartretail.backend.exception.InvalidSearchException;
import com.smartretail.backend.repository.CategoryRepository;
import com.smartretail.backend.repository.ShopRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Proxy;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

/**
 * Unit tests for the search rules. No database and no Spring: the two repositories are small
 * in-memory fakes, so these tests run in milliseconds. Test data is invented ("Test ..." shops).
 */
class ShopServiceTest {

    private static final String FASHION = "Fashion & Apparel";
    private static final String FOOD = "Food & Beverage";

    private final List<Category> categories = new ArrayList<>();
    private final List<Shop> shops = new ArrayList<>();
    private ShopService service;

    @BeforeEach
    void setUp() throws Exception {
        categories.clear();
        shops.clear();
        Category fashion = category(1, FASHION);
        Category food = category(2, FOOD);

        // name, floor, min, max, rating
        shop(food, "Test Cafe", "Ground Floor", 100, 800, "4.2");
        shop(food, "Test Bites", "First Floor", 150, 600, null);
        shop(food, "Test Fine Dine", "Second Floor", 900, 3000, "4.5");
        shop(fashion, "Test Tees", "First Floor", 499, 2200, "4.1");
        shop(fashion, "Test Threads", "Ground Floor", 400, 3500, null);
        shop(fashion, "Test Denim", "First Floor", 800, 4000, "4.0");
        shop(fashion, "Test Budget Wear", "Ground Floor", 200, 900, null);

        ShopRepository shopRepository = fake(ShopRepository.class, (method, args) -> switch (method) {
            case "findAffordableByCategory" -> shops.stream()
                    .filter(s -> s.getCategory().getCategoryName().equals(args[0]))
                    .filter(s -> s.getMinPrice().compareTo((BigDecimal) args[1]) <= 0)
                    .sorted(Comparator.comparing(Shop::getMinPrice))
                    .toList();
            case "findAllWithCategory" -> shops.stream().sorted(Comparator.comparing(Shop::getShopName)).toList();
            default -> throw new UnsupportedOperationException(method);
        });
        CategoryRepository categoryRepository = fake(CategoryRepository.class, (method, args) -> switch (method) {
            case "findAllByOrderByCategoryIdAsc" -> categories;
            case "existsByCategoryName" -> categories.stream().anyMatch(c -> c.getCategoryName().equals(args[0]));
            default -> throw new UnsupportedOperationException(method);
        });
        service = new ShopService(shopRepository, categoryRepository);
    }

    // ---------- ranking ----------

    @Test
    void shopWhoseWholeRangeFitsComesFirstThenRatingThenLowestPrice() {
        // budget 1000. Whole range fits: Test Cafe (800), Test Bites (600). Cafe has the rating, so it is first.
        assertEquals(List.of("Test Cafe", "Test Bites", "Test Fine Dine"), names(service.recommend(bd(1000), FOOD)));
    }

    @Test
    void shopsWithoutRatingComeAfterRatedShopsWithinTheSameGroup() {
        // budget 1500. None of the fashion shops fit fully except Test Budget Wear (max 900).
        // Then rated: Tees 4.1, Denim 4.0; then unrated by lowest price: Threads (400).
        assertEquals(List.of("Test Budget Wear", "Test Tees", "Test Denim", "Test Threads"),
                names(service.recommend(bd(1500), FASHION)));
    }

    @Test
    void shopIsIncludedWhenItsLowestPriceEqualsTheBudget() {
        assertEquals(List.of("Test Cafe"), names(service.recommend(bd(100), FOOD)));
    }

    @Test
    void budgetBelowEveryLowestPriceGivesAnEmptyListNotAnError() {
        assertTrue(service.recommend(bd(50), FOOD).isEmpty());
    }

    @Test
    void categoryIsTrimmedBeforeLookup() {
        assertEquals(List.of("Test Cafe"), names(service.recommend(bd(100), "  " + FOOD + " ")));
    }

    @Test
    void responseCarriesTheShopFields() {
        ShopResponse first = service.recommend(bd(1000), FOOD).get(0);
        assertEquals("Test Cafe", first.shopName());
        assertEquals(FOOD, first.category());
        assertEquals("Ground Floor", first.floor());
        assertEquals(0, first.minPrice().compareTo(bd(100)));
        assertEquals(0, first.maxPrice().compareTo(bd(800)));
        assertEquals(0, first.rating().compareTo(new BigDecimal("4.2")));
    }

    // ---------- validation ----------

    @Test
    void rejectsMissingBudget() {
        assertEquals("Budget is required.", errorFor(null, FOOD));
    }

    @Test
    void rejectsZeroAndNegativeBudget() {
        assertEquals("Budget must be greater than 0.", errorFor(BigDecimal.ZERO, FOOD));
        assertEquals("Budget must be greater than 0.", errorFor(bd(-5), FOOD));
    }

    @Test
    void rejectsBudgetAboveTheMaximumButAcceptsTheMaximum() {
        assertEquals("Budget cannot be more than 1000000.", errorFor(bd(1_000_001), FOOD));
        service.recommend(bd(1_000_000), FOOD); // must not throw
    }

    @Test
    void rejectsMissingOrBlankCategory() {
        assertEquals("Category is required.", errorFor(bd(1500), null));
        assertEquals("Category is required.", errorFor(bd(1500), "   "));
    }

    @Test
    void rejectsUnknownCategoryAndListsTheSupportedOnes() {
        String message = errorFor(bd(1500), "Toys");
        assertTrue(message.startsWith("Unknown category 'Toys'."), message);
        assertTrue(message.contains(FASHION) && message.contains(FOOD), message);
    }

    // ---------- listing ----------

    @Test
    void getShopsReturnsAllOrOnlyTheRequestedCategory() {
        assertEquals(7, service.getShops(null).size());
        assertEquals(4, service.getShops(FASHION).size());
        assertThrows(InvalidSearchException.class, () -> service.getShops("Toys"));
    }

    @Test
    void getCategoryNamesKeepsDatabaseOrder() {
        assertEquals(List.of(FASHION, FOOD), service.getCategoryNames());
    }

    // ---------- helpers ----------

    private String errorFor(BigDecimal budget, String category) {
        return assertThrows(InvalidSearchException.class, () -> service.recommend(budget, category)).getMessage();
    }

    private static BigDecimal bd(long value) {
        return BigDecimal.valueOf(value);
    }

    private static List<String> names(List<ShopResponse> list) {
        return list.stream().map(ShopResponse::shopName).toList();
    }

    private interface Handler {
        Object handle(String method, Object[] args) throws Exception;
    }

    @SuppressWarnings("unchecked")
    private static <T> T fake(Class<T> type, Handler handler) {
        return (T) Proxy.newProxyInstance(type.getClassLoader(), new Class<?>[]{type},
                (proxy, method, args) -> handler.handle(method.getName(), args));
    }

    // Entities have a protected constructor and no setters (read-only app), so tests fill fields by reflection.
    private static <T> T create(Class<T> type) throws Exception {
        Constructor<T> constructor = type.getDeclaredConstructor();
        constructor.setAccessible(true);
        return constructor.newInstance();
    }

    private static void set(Object target, String field, Object value) throws Exception {
        Field f = target.getClass().getDeclaredField(field);
        f.setAccessible(true);
        f.set(target, value);
    }

    private Category category(int id, String name) throws Exception {
        Category c = create(Category.class);
        set(c, "categoryId", id);
        set(c, "categoryName", name);
        categories.add(c);
        return c;
    }

    private void shop(Category category, String name, String floor, long min, long max, String rating) throws Exception {
        Shop s = create(Shop.class);
        set(s, "shopId", shops.size() + 1);
        set(s, "shopName", name);
        set(s, "category", category);
        set(s, "floor", floor);
        set(s, "minPrice", bd(min));
        set(s, "maxPrice", bd(max));
        set(s, "rating", rating == null ? null : new BigDecimal(rating));
        shops.add(s);
    }
}
