package com.smartretail.backend.exception;

import com.smartretail.backend.dto.ErrorResponse;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;

/**
 * One place that turns exceptions from any controller into clean JSON errors
 * with the right HTTP status code.
 */
@RestControllerAdvice
public class GlobalExceptionHandler {

    /** Our own validation errors (budget out of range, unknown category). */
    @ExceptionHandler(InvalidSearchException.class)
    public ResponseEntity<ErrorResponse> handleInvalidSearch(InvalidSearchException ex) {
        return ResponseEntity.badRequest().body(new ErrorResponse(ex.getMessage()));
    }

    /** For example budget=abc, which cannot be converted to a number. */
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    public ResponseEntity<ErrorResponse> handleTypeMismatch(MethodArgumentTypeMismatchException ex) {
        return ResponseEntity.badRequest()
                .body(new ErrorResponse("Invalid value for '" + ex.getName() + "'. Budget must be a number."));
    }

    /** For example a request that leaves out the budget or category entirely. */
    @ExceptionHandler(MissingServletRequestParameterException.class)
    public ResponseEntity<ErrorResponse> handleMissingParameter(MissingServletRequestParameterException ex) {
        return ResponseEntity.badRequest()
                .body(new ErrorResponse("Missing required parameter: " + ex.getParameterName()));
    }

    /** The AI request body failed validation (blank or too long text). */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleInvalidBody(MethodArgumentNotValidException ex) {
        String message = ex.getBindingResult().getFieldErrors().stream()
                .map(error -> error.getDefaultMessage())
                .findFirst()
                .orElse("Invalid request.");
        return ResponseEntity.badRequest().body(new ErrorResponse(message));
    }

    /** Missing or malformed JSON body. */
    @ExceptionHandler(HttpMessageNotReadableException.class)
    public ResponseEntity<ErrorResponse> handleUnreadableBody(HttpMessageNotReadableException ex) {
        return ResponseEntity.badRequest().body(new ErrorResponse("Request body must be JSON like {\"text\": \"...\"}."));
    }

    /** AI key missing, AI service down or busy: 503 with a message the frontend shows as-is. */
    @ExceptionHandler(AiUnavailableException.class)
    public ResponseEntity<ErrorResponse> handleAiUnavailable(AiUnavailableException ex) {
        return ResponseEntity.status(HttpStatus.SERVICE_UNAVAILABLE).body(new ErrorResponse(ex.getMessage()));
    }
}
