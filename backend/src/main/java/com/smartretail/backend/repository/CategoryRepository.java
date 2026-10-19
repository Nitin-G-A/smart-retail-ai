package com.smartretail.backend.repository;

import com.smartretail.backend.entity.Category;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * Database access for categories. Spring Data JPA writes the SQL from the method names.
 */
public interface CategoryRepository extends JpaRepository<Category, Integer> {

    /** SELECT ... FROM categories ORDER BY category_id */
    List<Category> findAllByOrderByCategoryIdAsc();

    /** True if a category with this exact name exists. */
    boolean existsByCategoryName(String categoryName);
}
