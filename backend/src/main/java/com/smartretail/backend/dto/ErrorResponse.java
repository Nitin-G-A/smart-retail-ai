package com.smartretail.backend.dto;

/**
 * Error body for failed requests: { "message": "..." }.
 * js/api.js shows this message to the user.
 */
public record ErrorResponse(String message) {
}
