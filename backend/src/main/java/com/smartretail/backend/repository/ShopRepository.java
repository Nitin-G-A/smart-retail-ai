package com.smartretail.backend.repository;

import com.smartretail.backend.entity.Shop;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.util.List;

/**
 * Database access for shops. The queries use named parameters (:budget, :categoryName),
 * so user input is never concatenated into SQL.
 */
public interface ShopRepository extends JpaRepository<Shop, Integer> {

    /**
     * Shops in one category whose cheapest items cost no more than the budget.
     * JOIN FETCH loads the category in the same query.
     */
    @Query("""
            SELECT s FROM Shop s JOIN FETCH s.category c
            WHERE c.categoryName = :categoryName AND s.minPrice <= :budget
            ORDER BY s.minPrice ASC
            """)
    List<Shop> findAffordableByCategory(@Param("categoryName") String categoryName,
                                        @Param("budget") BigDecimal budget);

    /** Every shop with its category loaded. */
    @Query("SELECT s FROM Shop s JOIN FETCH s.category ORDER BY s.shopName ASC")
    List<Shop> findAllWithCategory();
}
