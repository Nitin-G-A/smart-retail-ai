// api.js — the ONLY place that talks to data (demo or real backend).
// app.js calls ShopApi.recommend() and ShopApi.parseRequest() and never needs to
// know which source is in use. Switching to the Spring Boot API = flip USE_DEMO_DATA.

const ShopApi = (function () {
    const delay = (ms) => new Promise((resolve) => setTimeout(resolve, ms));

    // Open the page with ?simulate=error to test the error state in demo mode.
    function simulateErrorRequested() {
        return new URLSearchParams(window.location.search).get("simulate") === "error";
    }

    /** Shared fetch wrapper: turns network failures and non-2xx responses into clear Errors. */
    async function request(path, options) {
        let response;
        try {
            response = await fetch(APP_CONFIG.API_BASE_URL + path, options);
        } catch (networkError) {
            throw new Error(
                "Could not reach the server. Make sure the backend is running at " +
                APP_CONFIG.API_BASE_URL + "."
            );
        }

        if (!response.ok) {
            // Proposed error format from the backend: { "message": "..." }
            let message = "The server returned an error (HTTP " + response.status + ").";
            try {
                const body = await response.json();
                if (body && body.message) message = body.message;
            } catch (ignored) { /* body was not JSON; keep the default message */ }
            const error = new Error(message);
            error.status = response.status;
            throw error;
        }
        return response.json();
    }

    /** GET /api/shops/recommend?budget=...&category=...  ->  array of shop objects */
    async function recommend(budget, category) {
        if (APP_CONFIG.USE_DEMO_DATA) {
            await delay(600); // pretend to be a network call so the loading state is visible
            if (simulateErrorRequested()) throw new Error("Simulated demo error: the server did not respond.");
            return DemoBackend.recommend(budget, category);
        }
        const query = new URLSearchParams({ budget: String(budget), category: category });
        return request("/api/shops/recommend?" + query.toString(), {
            headers: { Accept: "application/json" },
        });
    }

    /** POST /api/ai/parse-request  { "text": "..." }  ->  { budget, category } (proposed shape) */
    async function parseRequest(text) {
        if (APP_CONFIG.USE_DEMO_DATA) {
            await delay(500);
            if (simulateErrorRequested()) throw new Error("Simulated demo error: the server did not respond.");
            return DemoBackend.parseRequest(text);
        }
        return request("/api/ai/parse-request", {
            method: "POST",
            headers: { "Content-Type": "application/json", Accept: "application/json" },
            body: JSON.stringify({ text: text }),
        });
    }

    return { recommend: recommend, parseRequest: parseRequest };
})();