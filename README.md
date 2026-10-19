# Smart Retail AI — Mall Shop Finder 🛍️

Find shops at **Phoenix Mall of Asia, Bengaluru**, based on your budget, shopping category, or a natural-language description.

For example, enter *"Find casual clothes for college under ₹2,000"* and get matching shop recommendations with their categories, floors, shop numbers, and estimated price ranges.

<p align="center">
  <a href="https://smart-retail-ai-frontend.vercel.app">
    <strong>🚀 Try the Live Demo</strong>
  </a>
  &nbsp; | &nbsp;
  <a href="https://github.com/Nitin-G-A/smart-retail-ai">
    <strong>📂 GitHub Repository</strong>
  </a>
</p>

> Student portfolio project. Not affiliated with Phoenix Mall of Asia. See [Data and Limitations](#data-and-limitations).

## 🌐 Live Demo

| Component | Link | Status |
|---|---|---|
| Frontend | [Open Smart Retail AI](https://smart-retail-ai-frontend.vercel.app) | Deployed on Vercel |
| Backend API | [View Categories API](https://smart-retail-ai-8ame.onrender.com/api/categories) | Deployed on Render |
| Shops API | [View Shops API](https://smart-retail-ai-8ame.onrender.com/api/shops) | Deployed on Render |
| Source Code | [GitHub Repository](https://github.com/Nitin-G-A/smart-retail-ai) | Public repository |

*Note: The free Render service may sleep after inactivity, so the first API request can take longer to respond.*

## 📸 Screenshots

### Smart Retail AI — Home Page

<!-- Add your screenshot at docs/screenshots/homepage.png -->
![Smart Retail AI Homepage](docs/screenshots/homepage.png)

### Shop Recommendations

<!-- Add your screenshot at docs/screenshots/recommendations.png -->
![Shop Recommendations](docs/screenshots/recommendations.png)

### Natural Language Search

<!-- Add your screenshot at docs/screenshots/natural-language-search.png -->
![Natural Language Search](docs/screenshots/natural-language-search.png)

To display these screenshots on GitHub, create a `docs/screenshots/` folder in your repository and upload the corresponding image files. Until you add them, these image links will not display.

## ✨ Features

- **Budget-based search:** Find shops that match your budget.
- **Category filtering:** Search across Fashion & Apparel, Food & Beverage, Entertainment & Leisure, and Electronics & Technology.
- **Natural-language search:** Describe what you need in plain English.
- **AI-powered parsing:** Google Gemini converts a natural-language request into structured search criteria, such as budget and category.
- **Backend validation:** Validates user input and AI-generated values before using them.
- **Shop recommendations:** Ranks matching shops using budget fit, rating, and starting price.
- **Shop details:** Displays shop name, category, floor, shop number, and estimated price range.
- **Responsive interface:** A simple web interface built with HTML, CSS, and JavaScript.
- **Error handling:** Includes loading, validation, empty-result, and error states.

## 🛠️ Tech Stack

| Layer | Technologies |
|---|---|
| Frontend | HTML5, CSS3, JavaScript |
| Backend | Java 21, Spring Boot, Spring MVC |
| Data access | Spring Data JPA, Hibernate |
| Database | MySQL 8 |
| AI integration | Google Gemini API |
| Build tool | Maven |
| Testing | JUnit 5 |
| Frontend deployment | Vercel |
| Backend deployment | Render |
| Database hosting | Aiven for MySQL |
| Version control | Git and GitHub |

## 🏗️ Architecture

```text
User
 │
 ▼
HTML / CSS / JavaScript Frontend
 │
 ├── Budget + Category Search
 │
 └── Natural-Language Search
             │
             ▼
       Spring Boot REST API
             │
       ┌─────┴──────┐
       ▼            ▼
   Shop Service   LLM Service
       │            │
       ▼            ▼
   Repository    Gemini API
       │
       ▼
      MySQL
```

**Design principles**

- Controllers handle HTTP requests and responses.
- Business rules and recommendation ranking are implemented in the service layer.
- Repositories manage database access.
- Gemini parses the user's request; it does not generate the shop database or independently choose the final recommendations.
- Shop information is retrieved from MySQL.
- API keys and database credentials are stored in environment variables rather than frontend code.

## 📁 Project Structure

```text
smart-retail-ai/
├── frontend/
│   ├── index.html
│   ├── css/
│   │   └── styles.css
│   └── js/
│       ├── config.js
│       ├── api.js
│       ├── app.js
│       └── demo-data.js
├── backend/
│   ├── pom.xml
│   └── src/
│       ├── main/
│       │   ├── java/com/smartretail/backend/
│       │   │   ├── controller/
│       │   │   ├── service/
│       │   │   ├── repository/
│       │   │   ├── entity/
│       │   │   ├── dto/
│       │   │   ├── exception/
│       │   │   └── config/
│       │   └── resources/
│       └── test/
└── database/
    ├── schema.sql
    ├── schema-cloud.sql
    ├── mall-of-asia-data.sql
    ├── sample-data.sql
    └── migrations/
```

## 🚀 Run Locally

### Prerequisites

- Java 21
- Maven
- MySQL 8
- Git
- An IDE such as IntelliJ IDEA
- A Gemini API key for natural-language AI search

### 1. Clone the repository

```bash
git clone https://github.com/Nitin-G-A/smart-retail-ai.git
cd smart-retail-ai
```

### 2. Set up the database

1. Open MySQL Workbench.
2. Run `database/schema.sql` to create the database and tables.
3. Run `database/mall-of-asia-data.sql` to insert the mall shop records.
4. Verify that the data was inserted successfully.

Use `database/schema-cloud.sql` for the hosted database setup when appropriate. Follow the SQL file's instructions for database users and permissions.

### 3. Configure the backend

Set these environment variables in IntelliJ IDEA under **Run → Edit Configurations → Environment variables**.

| Variable | Purpose |
|---|---|
| `DB_USERNAME` | MySQL username |
| `DB_PASSWORD` | MySQL password |
| `LLM_API_KEY` | Gemini API key |
| `DB_URL` | Hosted MySQL JDBC URL, when required by the deployment configuration |
| `CORS_ORIGINS` | Allowed frontend origin(s) on Render |

Use your own credentials. Never commit database passwords or API keys to GitHub.

For local development, use the JDBC URL configured for your local MySQL instance, for example:

```text
jdbc:mysql://localhost:3306/smart_retail
```

### 4. Start the backend

From the project root:

```bash
cd backend
mvn spring-boot:run
```

The backend should be available at:

```text
http://localhost:8080
```

### 5. Start the frontend

In another terminal, navigate to the frontend directory:

```bash
cd frontend
python -m http.server 5500
```

Open this URL in your browser:

```text
http://localhost:5500
```

Check `frontend/js/config.js` to confirm that `USE_DEMO_DATA` is set to `false` when using the real backend, and that `API_BASE_URL` points to the correct server.

## 🔌 REST API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| GET | `/api/categories` | Returns supported shopping categories |
| GET | `/api/shops` | Returns shops, optionally filtered by category |
| GET | `/api/shops/recommend?budget=1500&category=Food%20%26%20Beverage` | Returns budget-based recommendations |
| POST | `/api/ai/parse-request` | Parses a natural-language shopping request |

### Example: Parse a shopping request

**Request**

```http
POST /api/ai/parse-request
Content-Type: application/json
```

```json
{
  "text": "Find casual clothes for college under 2000"
}
```

**Example response**

```json
{
  "budget": 2000,
  "category": "Fashion & Apparel"
}
```

The response is an example of the expected format. Actual output depends on the request and AI service.

## ☁️ Deployment

The project is deployed using free-tier hosting options where available.

| Component | Service |
|---|---|
| Source code | GitHub |
| MySQL database | Aiven for MySQL |
| Spring Boot backend | Render |
| Static frontend | Vercel |

### Deployment configuration

- **Vercel:** Root directory is `frontend`.
- **Render:** Configure the backend build and start commands according to the repository's backend setup.
- **Database:** Configure the hosted MySQL connection using environment variables.
- **CORS:** Allow requests from the deployed frontend origin.
- **Gemini:** Configure the API key on the backend, not in frontend JavaScript.

Hosting providers may change their free-tier limits, so check their current plans.

## 🧪 Testing

Run the backend tests from the `backend/` directory:

```bash
mvn test
```

The project includes service-level tests for recommendation ranking and input validation, as well as AI-response validation tests. Controller and full end-to-end coverage may require additional tests.

## 📊 Data and Limitations

- Shop names and floor information are based on third-party mall directories and may be outdated.
- Shop numbers are placeholders rather than verified official unit numbers.
- Price ranges are estimates and are not guaranteed to reflect current store prices.
- Reliable shop ratings were not available for all entries.
- Some store types are grouped into the four supported categories.
- This is a student project and is not officially affiliated with the mall.

## 🔐 Security

- Database credentials and the Gemini API key are configured through environment variables.
- The database application user should have only the permissions it needs.
- Natural-language input and AI-generated values are validated by the backend.
- Frontend rendering should use safe text APIs such as `textContent` for data received from the server.
- CORS should allow only the origins needed by the application.

## 🔮 Future Improvements

- Verify official shop unit numbers and current prices.
- Add an admin dashboard to manage shop data.
- Add more malls and shopping categories.
- Improve recommendation personalization.
- Add controller and end-to-end integration tests.
- Add user accounts, favourites, and search history.

## 👨‍💻 Author

**Nitin G A**

B.Tech — Computer Science and Information Technology

[GitHub Profile](https://github.com/Nitin-G-A)

---

⭐ If you find this project interesting, consider starring the repository!
