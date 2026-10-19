package com.smartretail.backend.exception;

/**
 * Thrown when search input is invalid (bad budget, unknown category).
 * GlobalExceptionHandler turns it into an HTTP 400 response.
 */
public class InvalidSearchException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public InvalidSearchException(String message) {
        super(message);
    }
}
