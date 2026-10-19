// app.js — page behaviour: validation, search flow, and rendering of every UI state.
// Data comes only from ShopApi (api.js). Nothing here knows about MySQL, Spring or the LLM.

(function () {
    "use strict";

    const $ = (id) => document.getElementById(id);
    const els = {
        modeBanner: $("mode-banner"),
        tabForm: $("tab-form"), tabNl: $("tab-nl"),
        formSearch: $("form-search"), formNl: $("form-nl"),
        budget: $("budget"), budgetError: $("budget-error"),
        category: $("category"),
        nlText: $("nl-text"), nlError: $("nl-error"), nlHint: $("nl-hint"),
        btnForm: $("btn-form-search"), btnNl: $("btn-nl-search"),
        notice: $("notice"), state: $("state"),
        resultsHeader: $("results-header"), resultsTitle: $("results-title"),
        sourceBadge: $("source-badge"), grid: $("results-grid"),
    };

    const isDemo = APP_CONFIG.USE_DEMO_DATA;
    let busy = false;

    // ---------- Small helpers ----------

    /** Creates an element; text is set with textContent so API data can never inject HTML. */
    function el(tag, className, text) {
        const node = document.createElement(tag);
        if (className) node.className = className;
        if (text !== undefined && text !== null) node.textContent = text;
        return node;
    }

    function formatRupees(amount) {
        return "₹" + Number(amount).toLocaleString("en-IN");
    }

    // ---------- Validation ----------

    /** Returns { valid, value, message }. The backend must repeat these checks. */
    function validateBudget(raw) {
        const text = String(raw).trim();
        if (text === "") return { valid: false, message: "Please enter a valid budget." };
        const value = Number(text);
        if (!Number.isFinite(value)) return { valid: false, message: "Budget must be a number." };
        if (value <= 0) return { valid: false, message: "Budget must be greater than ₹0." };
        if (value > APP_CONFIG.MAX_BUDGET) {
            return { valid: false, message: "Budget cannot be more than " + formatRupees(APP_CONFIG.MAX_BUDGET) + "." };
        }
        return { valid: true, value: value };
    }

    function setFieldError(inputEl, errorEl, message) {
        errorEl.textContent = message || "";
        inputEl.closest(".field").classList.toggle("invalid", Boolean(message));
    }

    // ---------- Render: banner, tabs, notice ----------

    function renderModeBanner() {
        if (isDemo) {
            els.modeBanner.className = "mode-banner demo";
            els.modeBanner.textContent =
                "Demo mode: results come from built-in sample data. These shops and prices are fictional. The backend is not connected yet.";
            els.nlHint.textContent =
                "Demo mode: this uses simple keyword matching, not a real AI model.";
        } else {
            els.modeBanner.className = "mode-banner live";
            els.modeBanner.textContent = "Live mode: results come from the API at " + APP_CONFIG.API_BASE_URL + ".";
            els.nlHint.textContent = "Your description is sent to the backend, which turns it into a validated search.";
        }
    }

    function setActiveTab(name) {
        const nl = name === "nl";
        els.tabForm.classList.toggle("active", !nl);
        els.tabNl.classList.toggle("active", nl);
        els.tabForm.setAttribute("aria-selected", String(!nl));
        els.tabNl.setAttribute("aria-selected", String(nl));
        els.formSearch.hidden = nl;
        els.formNl.hidden = !nl;
    }

    function hideNotice() {
        els.notice.hidden = true;
        els.notice.replaceChildren();
    }

    function showNotice(text, actionLabel, actionHandler) {
        els.notice.replaceChildren(el("div", null, text));
        if (actionLabel && actionHandler) {
            const btn = el("button", "btn", actionLabel);
            btn.type = "button";
            btn.addEventListener("click", actionHandler);
            els.notice.append(btn);
        }
        els.notice.hidden = false;
    }

    // ---------- Render: results-area states ----------

    function clearResults() {
        els.state.className = "state";
        els.state.replaceChildren();
        els.resultsHeader.hidden = true;
        els.grid.replaceChildren();
    }

    function showState(kind, title, message, actionLabel, actionHandler) {
        clearResults();
        els.state.className = "state " + kind;
        if (kind === "loading") els.state.append(el("div", "spinner"));
        els.state.append(el("h3", null, title));
        if (message) els.state.append(el("p", null, message));
        if (actionLabel && actionHandler) {
            const btn = el("button", "btn primary", actionLabel);
            btn.type = "button";
            btn.addEventListener("click", actionHandler);
            els.state.append(btn);
        }
    }

    function renderIdle() {
        showState("idle", "Ready when you are", "Enter a budget and pick a category, then press Search.");
    }

    function renderLoading() {
        showState("loading", "Finding shops…");
    }

    function renderError(error, retryFn) {
        showState("error", "Something went wrong", error.message || "Unexpected error.", "Try again", retryFn);
    }

    function renderEmpty(budget, category) {
        showState(
            "empty",
            "No suitable shops found",
            "No " + category + " shops have items starting at or below " + formatRupees(budget) +
            ". Try a higher budget, a different category, or describe what you need.",
            "Change budget",
            function () {
                setActiveTab("form");
                els.budget.focus();
                els.budget.select();
            }
        );
    }

    function createShopCard(shop, budget) {
        const card = el("article", "shop-card");

        const top = el("div", "shop-card-top");
        top.append(el("span", "chip", shop.category));
        if (shop.rating !== null && shop.rating !== undefined) {
            top.append(el("span", "rating", "★ " + Number(shop.rating).toFixed(1)));
        }
        card.append(top);

        if (isDemo || shop.demo) card.append(el("span", "demo-tag", "DEMO SHOP"));
        card.append(el("h3", "shop-name", shop.shopName));
        if (shop.description) card.append(el("p", "shop-desc", shop.description));

        const details = el("dl", "shop-details");
        [
            ["Floor", shop.floor],
            ["Shop no.", shop.shopNumber],
            ["Price range", formatRupees(shop.minPrice) + " – " + formatRupees(shop.maxPrice)],
        ].forEach(function (pair) {
            const row = el("div");
            row.append(el("dt", null, pair[0]), el("dd", null, pair[1]));
            details.append(row);
        });
        card.append(details);

        // Display-only hint; the real filtering/ranking is done by the backend later.
        const fits = shop.maxPrice <= budget;
        card.append(
            el("p", "fit " + (fits ? "full" : "partial"),
                fits ? "Whole price range is within your budget" : "Some items are within your budget")
        );
        return card;
    }

    function renderResults(shops, budget, category) {
        if (!Array.isArray(shops)) throw new Error("The server sent an unexpected response.");
        if (shops.length === 0) { renderEmpty(budget, category); return; }

        clearResults();
        els.resultsTitle.textContent =
            shops.length + (shops.length === 1 ? " shop" : " shops") + " found in " + category +
            " within " + formatRupees(budget);
        els.sourceBadge.className = "badge " + (isDemo ? "demo" : "live");
        els.sourceBadge.textContent = isDemo ? "Demo data" : "Live API";
        els.resultsHeader.hidden = false;
        shops.forEach((shop) => els.grid.append(createShopCard(shop, budget)));
    }

    // ---------- Search flow ----------

    function setBusy(value) {
        busy = value;
        els.btnForm.disabled = value;
        els.btnNl.disabled = value;
        els.state.setAttribute("aria-busy", String(value));
    }

    /** Runs a task with the loading state, busy lock and error handling. Retry re-runs the same task. */
    async function withLoading(task) {
        if (busy) return;
        setBusy(true);
        renderLoading();
        try {
            await task();
        } catch (error) {
            renderError(error, function () { withLoading(task); });
        } finally {
            setBusy(false);
        }
    }

    /** Search with an already-validated budget and category. */
    function runSearch(budget, category) {
        return withLoading(async function () {
            const shops = await ShopApi.recommend(budget, category);
            renderResults(shops, budget, category);
        });
    }

    function onFormSubmit(event) {
        event.preventDefault();
        if (busy) return;
        hideNotice();

        const check = validateBudget(els.budget.value);
        if (!check.valid) {
            setFieldError(els.budget, els.budgetError, check.message);
            els.budget.focus();
            return;
        }
        setFieldError(els.budget, els.budgetError, "");
        runSearch(check.value, els.category.value);
    }

    function onNlSubmit(event) {
        event.preventDefault();
        if (busy) return;
        hideNotice();

        const text = els.nlText.value.trim();
        if (!text) {
            setFieldError(els.nlText, els.nlError, "Please describe what you're looking for.");
            els.nlText.focus();
            return;
        }
        setFieldError(els.nlText, els.nlError, "");

        const selectedCategory = els.category.value;

        withLoading(async function () {
            const parsed = await ShopApi.parseRequest(text);

            // 1. Category must be one of the four supported categories
            if (!parsed || APP_CONFIG.CATEGORIES.indexOf(parsed.category) === -1) {
                showState(
                    "empty",
                    "We couldn't match that to a shop category",
                    "This mall search covers Fashion & Apparel, Food & Beverage, Entertainment & Leisure and Electronics & Technology. Try something like \"casual clothes under 2000\" or \"pizza under 500\", or use Budget & category.",
                    "Use Budget & category",
                    function () { setActiveTab("form"); els.category.focus(); }
                );
                return;
            }

            // 2. Budget: use the one found in the text, otherwise the budget field
            let budget;
            let budgetFromText = false;
            if (parsed.budget !== null && parsed.budget !== undefined) {
                const check = validateBudget(parsed.budget);
                if (!check.valid) throw new Error("The budget in your request is not valid. " + check.message);
                budget = check.value;
                budgetFromText = true;
            } else {
                const check = validateBudget(els.budget.value);
                if (!check.valid) {
                    showState("empty", "We need a budget", "Add a budget to your description (e.g. \"under 2000\") or enter it in Budget & category.",
                        "Use Budget & category", function () { setActiveTab("form"); els.budget.focus(); });
                    return;
                }
                budget = check.value;
            }

            // 3. Keep the form in sync, and tell the user how the request was understood
            els.budget.value = budget;
            els.category.value = parsed.category;

            let message = "We understood your request as " + parsed.category + " with a budget of " +
                formatRupees(budget) + (budgetFromText ? "." : " (from the budget field).");
            if (parsed.category !== selectedCategory) {
                message += " This differs from the selected category (" + selectedCategory + ").";
                showNotice(message, "Search " + selectedCategory + " instead", function () {
                    hideNotice();
                    els.category.value = selectedCategory;
                    runSearch(budget, selectedCategory);
                });
            } else {
                showNotice(message);
            }

            const shops = await ShopApi.recommend(budget, parsed.category);
            renderResults(shops, budget, parsed.category);
        });
    }

    // ---------- Start-up ----------

    function init() {
        APP_CONFIG.CATEGORIES.forEach(function (name) {
            const option = el("option", null, name);
            option.value = name;
            els.category.append(option);
        });
        els.category.value = APP_CONFIG.DEFAULT_CATEGORY;
        els.budget.value = APP_CONFIG.DEFAULT_BUDGET;

        renderModeBanner();
        renderIdle();

        els.tabForm.addEventListener("click", function () { setActiveTab("form"); });
        els.tabNl.addEventListener("click", function () { setActiveTab("nl"); });
        els.formSearch.addEventListener("submit", onFormSubmit);
        els.formNl.addEventListener("submit", onNlSubmit);
        els.budget.addEventListener("input", function () { setFieldError(els.budget, els.budgetError, ""); });
        els.nlText.addEventListener("input", function () { setFieldError(els.nlText, els.nlError, ""); });
    }

    init();
})();