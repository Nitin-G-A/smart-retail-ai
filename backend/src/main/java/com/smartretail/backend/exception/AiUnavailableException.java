package com.smartretail.backend.exception;

/** The AI service is not configured or could not be reached. GlobalExceptionHandler turns it into HTTP 503. */
public class AiUnavailableException extends RuntimeException {

    private static final long serialVersionUID = 1L;

    public AiUnavailableException(String message) {
        super(message);
    }
}
