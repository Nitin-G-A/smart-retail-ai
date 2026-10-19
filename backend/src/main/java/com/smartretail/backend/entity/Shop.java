package com.smartretail.backend.entity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;

import java.math.BigDecimal;

/**
 * Maps to the "shops" table. Each field matches one column.
 * The data is read-only in this app, so there are getters but no setters.
 */
@Entity
@Table(name = "shops")
public class Shop {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "shop_id")
    private Integer shopId;

    @Column(name = "shop_name", nullable = false, length = 100)
    private String shopName;

    // Many shops belong to one category (foreign key category_id)
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "category_id", nullable = false)
    private Category category;

    @Column(name = "floor", nullable = false, length = 30)
    private String floor;

    // Floor came from public directories that disagree with each other
    @Column(name = "floor_uncertain", nullable = false)
    private boolean floorUncertain;

    // Placeholder unit number (not the mall's real one); NULL when the floor is unknown
    @Column(name = "shop_number", unique = true, length = 20)
    private String shopNumber;

    @Column(name = "min_price", nullable = false, precision = 10, scale = 2)
    private BigDecimal minPrice;

    @Column(name = "max_price", nullable = false, precision = 10, scale = 2)
    private BigDecimal maxPrice;

    @Column(name = "description", length = 255)
    private String description;

    // NULL when there is no reliable rating
    @Column(name = "rating", precision = 2, scale = 1)
    private BigDecimal rating;

    // TRUE for fictional development data
    @Column(name = "is_demo", nullable = false)
    private boolean demo;

    /** JPA/Hibernate needs a no-argument constructor. */
    protected Shop() {
    }

    public Integer getShopId() {
        return shopId;
    }

    public String getShopName() {
        return shopName;
    }

    public Category getCategory() {
        return category;
    }

    public String getFloor() {
        return floor;
    }

    public String getShopNumber() {
        return shopNumber;
    }

    public BigDecimal getMinPrice() {
        return minPrice;
    }

    public BigDecimal getMaxPrice() {
        return maxPrice;
    }

    public String getDescription() {
        return description;
    }

    public BigDecimal getRating() {
        return rating;
    }

    public boolean isFloorUncertain() {
        return floorUncertain;
    }

    public boolean isDemo() {
        return demo;
    }
}
