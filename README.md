# Smart Retail AI: Mall Shop Finder

A web app that helps a shopper find shops in **Phoenix Mall of Asia, Bengaluru** by budget and category,
or by describing what they want in plain English ("casual clothes for college under 2000").
Each result shows the shop name, category, floor, shop number and price range.

> Student portfolio project. Not affiliated with the mall. See [Data and limitations](#data-and-limitations).

## Features
- Search by **budget (₹) + category** (Fashion & Apparel, Food & Beverage, Entertainment & Leisure, Electronics & Technology).
- **Describe it** tab: a sentence is turned into a budget and category by the Gemini API, then validated by the backend.
- Ranking: shops whose whole price range fits the budget come first, then higher rating, then lower starting price.
- Clear loading, empty, error and validation states. Budget is validated in the browser **and** again on the server.

## Tech stack
| Layer | Technology |
|---|---|
| Frontend | HTML, CSS, vanilla JavaScript (no framework) |
| Backend | Java 21, Spring Boot 4.0.8, Spring MVC (REST), Spring Data JPA / Hibernate |
| Database | MySQL 8 |
| AI | Google Gemini API (called only from the backend) |
| Build / tests | Maven, JUnit 5 |

## Architecture
```
Browser (frontend/) ──HTTP/JSON──► Controller ─► Service ─► Repository ─► MySQL
                                       │
                                       └─► LlmService ──► Gemini API   (text -> {budget, category} only)
```
- Controllers only handle HTTP. Business rules live in `ShopService`. SQL/JPA lives in the repositories.
- The AI never returns shops. It only parses the sentence. **All shop data comes from MySQL.**
- `GlobalExceptionHandler` returns every error as `{ "message": "..." }` with the right status code.

## Project structure
```
smart-retail-ai/
├── frontend/   index.html, css/styles.css, js/{config,api,app,demo-data}.js
├── backend/    pom.xml, src/main/java/com/smartretail/backend/{controller,service,repository,entity,dto,exception,config}
│               src/main/resources/application.properties, src/test/java/...
└── database/   schema.sql, mall-of-asia-data.sql, sample-data.sql (fictional), migrations/
```

## Setup

### 1. Database
In MySQL Workbench:
1. Edit `CHANGE_ME` in `database/schema.sql`, then run it.
2. Run `database/mall-of-asia-data.sql` (174 shops).

### 2. Backend
Set these **environment variables** (IntelliJ: Run > Edit Configurations > Environment variables, separated by `;`):

| Variable | Meaning |
|---|---|
| `DB_USERNAME` | `smartretail_app` |
| `DB_PASSWORD` | the password you chose |
| `LLM_API_KEY` | Gemini key from https://aistudio.google.com/apikey (optional: without it the Describe tab shows "AI search is not set up") |

Run `BackendApplication` (or `mvn spring-boot:run` inside `backend/`). It listens on http://localhost:8080.

### 3. Frontend
Open `frontend/index.html` with IntelliJ's "Open in Browser", or run `python -m http.server 5500` inside `frontend/`
and visit http://localhost:5500. Allowed browser origins are listed in `app.cors.allowed-origins`.
`frontend/js/config.js` has `USE_DEMO_DATA` (true = built-in fictional data, no backend needed).

## API
| Method | Path | Description |
|---|---|---|
| GET | `/api/categories` | The four category names |
| GET | `/api/shops?category=` | All shops, optionally one category |
| GET | `/api/shops/recommend?budget=1500&category=Food%20%26%20Beverage` | Shops with lowest price <= budget, ranked |
| POST | `/api/ai/parse-request` | Body `{"text":"..."}` returns `{"budget":2000,"category":"Fashion & Apparel"}`; either value can be `null` |

Errors: `400` invalid input (bad budget, unknown category, blank or over-300-character text), `503` AI unavailable.
All errors look like `{ "message": "..." }`.

## Deployment (free tier)
Frontend, backend and database each run on a free plan. No credit card was required by these services when this was written;
free plans change, so check each site.

| Part | Service | Notes |
|---|---|---|
| Code | GitHub | public repository |
| Database | Aiven for MySQL (free plan) | 1 GB, no time limit; may power off if unused |
| Backend | Render web service (Docker, free) | sleeps after 15 minutes idle; first request takes about a minute |
| Frontend | Vercel (or GitHub Pages) | static site, root directory `frontend` |

Backend environment variables on Render: `DB_URL`, `DB_USERNAME`, `DB_PASSWORD`, `LLM_API_KEY`, `CORS_ORIGINS` (the frontend URL).
`DB_URL` looks like `jdbc:mysql://HOST:PORT/smart_retail?sslMode=REQUIRED`. Use `database/schema-cloud.sql` instead of `schema.sql` on a hosted database.

## Tests
```
cd backend
mvn test
```
`ShopServiceTest` covers ranking, boundary budgets, validation and unknown categories using in-memory fakes (no database).
`LlmServiceTest` covers the rule that the AI's answer is never trusted (unknown category, negative or huge budget, injected text).
Not covered yet: controller (MockMvc) tests and an end-to-end test against a real MySQL.

## Data and limitations
Be honest about what is real:
- **Shop names and floors** come from public third-party mall directories and may be out of date. Five stores whose floor differs
  between sources are flagged "unconfirmed" in the database (`floor_uncertain`).
- **Shop numbers are placeholders** (floor code + running number, e.g. `2-11`). The mall's real unit numbers are not public.
- **Prices are estimates** by brand positioning, not prices published by the shops.
- **Ratings** are empty because no reliable source was available.
- Beauty, jewellery, watches, luggage and home stores are grouped under *Fashion & Apparel* because the app has four categories.
- The mall's own website was not used (it disallows automated access).

## Security notes
- Secrets (database password, Gemini key) come only from environment variables, never from code or the frontend.
- The app's MySQL user can only SELECT/INSERT/UPDATE/DELETE on one database.
- User text is length-limited, sent to the AI as data, and the AI's answer is validated before use.
- The frontend writes API data with `textContent`, so shop data cannot inject HTML.
- CORS allows only the listed local origins.

## Future scope
Real unit numbers and prices from the mall or shop owners, admin screen to edit shops, user accounts and favourites,
more malls, controller and integration tests, deployment (e.g. Render/Railway for the backend and Vercel for the frontend).
