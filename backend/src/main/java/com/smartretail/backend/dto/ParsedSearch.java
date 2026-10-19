package com.smartretail.backend.dto;

import java.math.BigDecimal;

/**
 * What the AI understood from the text. Either field can be null when the text did not say.
 * This is only a search request: shop details always come from the database, never from the AI.
 */
public record ParsedSearch(BigDecimal budget, String category) {
}
