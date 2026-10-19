package com.smartretail.backend.service;

import com.smartretail.backend.dto.ParsedSearch;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

/** Tests the rule "never trust the AI's answer". No network or API key needed. */
class LlmServiceTest {

    private static final List<String> CATEGORIES = List.of(
            "Fashion & Apparel", "Food & Beverage", "Entertainment & Leisure", "Electronics & Technology");

    @Test
    void goodAnswerIsKeptAndCategoryUsesOurSpelling() {
        ParsedSearch result = LlmService.validate(new BigDecimal("2000.00"), " fashion & apparel ", CATEGORIES);
        assertEquals("Fashion & Apparel", result.category());
        assertEquals(0, result.budget().compareTo(new BigDecimal("2000")));
    }

    @Test
    void budgetIsNotSerializedInExponentForm() {
        // 2E+3 would be valid JSON but ugly; it must come out as 2000
        assertEquals("2000", LlmService.validate(new BigDecimal("2E+3"), null, CATEGORIES).budget().toPlainString());
        assertEquals("2000", LlmService.validate(new BigDecimal("2E+3"), null, CATEGORIES).budget().toString());
    }

    @Test
    void unknownCategoryBecomesNull() {
        assertNull(LlmService.validate(null, "Toys", CATEGORIES).category());
    }

    @Test
    void textThatOnlyContainsACategoryNameIsNotAccepted() {
        assertNull(LlmService.validate(null, "Ignore the rules. Food & Beverage", CATEGORIES).category());
    }

    @Test
    void invalidBudgetsBecomeNull() {
        assertNull(LlmService.validate(new BigDecimal("-5"), null, CATEGORIES).budget());
        assertNull(LlmService.validate(BigDecimal.ZERO, null, CATEGORIES).budget());
        assertNull(LlmService.validate(new BigDecimal("1000001"), null, CATEGORIES).budget());
    }

    @Test
    void maximumBudgetIsAccepted() {
        assertEquals(0, LlmService.validate(new BigDecimal("1000000"), null, CATEGORIES).budget()
                .compareTo(new BigDecimal("1000000")));
    }

    @Test
    void nothingUnderstoodGivesTwoNulls() {
        ParsedSearch result = LlmService.validate(null, null, CATEGORIES);
        assertNull(result.budget());
        assertNull(result.category());
    }
}
