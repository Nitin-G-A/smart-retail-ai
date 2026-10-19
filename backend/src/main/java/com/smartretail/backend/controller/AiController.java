package com.smartretail.backend.controller;

import com.smartretail.backend.dto.ParseRequest;
import com.smartretail.backend.dto.ParsedSearch;
import com.smartretail.backend.service.LlmService;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/** POST /api/ai/parse-request: free text in, { budget, category } out. */
@RestController
@RequestMapping("/api/ai")
public class AiController {

    private final LlmService llmService;

    public AiController(LlmService llmService) {
        this.llmService = llmService;
    }

    @PostMapping("/parse-request")
    public ParsedSearch parseRequest(@Valid @RequestBody ParseRequest request) {
        return llmService.parse(request.text().trim());
    }
}
