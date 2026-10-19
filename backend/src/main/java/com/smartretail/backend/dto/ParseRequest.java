package com.smartretail.backend.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/** Body of POST /api/ai/parse-request: the customer's free-text request. */
public record ParseRequest(
        @NotBlank(message = "Please describe what you're looking for.")
        @Size(max = 300, message = "Description is too long (maximum 300 characters).")
        String text) {
}
