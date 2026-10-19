// config.js — the ONLY file you edit to switch between demo data and the real backend.

const APP_CONFIG = {
    // true  = use built-in demo shops (no backend needed)
    // false = call the Spring Boot REST API at API_BASE_URL
    USE_DEMO_DATA: false,

    // Where the Spring Boot backend will run (Step 4). Proposed, not yet existing.
    API_BASE_URL: "http://localhost:8080",

    // Initial form values required by the project brief
    DEFAULT_BUDGET: 1500,
    DEFAULT_CATEGORY: "Food & Beverage",

    // Frontend validation limits (the backend must repeat these checks)
    MAX_BUDGET: 1000000,

    // The four supported categories. Later this list can come from GET /api/categories.
    CATEGORIES: [
        "Fashion & Apparel",
        "Food & Beverage",
        "Entertainment & Leisure",
        "Electronics & Technology",
    ],
};