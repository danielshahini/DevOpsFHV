# DevOps Course - Project Documentation

## 1. Project Overview

The **Simple Banking System** is a full-stack web application designed to demonstrate modern software development practices and DevOps principles. The system provides a comprehensive banking solution that enables users to manage bank accounts and perform essential financial transactions through an intuitive web interface.

### Purpose

This project exists as an educational exercise for the DevOps course, serving as a practical implementation of:
- **Continuous Integration/Continuous Deployment (CI/CD)** pipelines
- **Automated testing** and code quality analysis
- **Containerization** with Docker
- **Modern full-stack development** practices
- **Collaborative development** workflows in a team environment

### Main Features

The Simple Banking System offers the following core banking functionalities:

- **Account Management**: 
  - Create new bank accounts with unique names
  - View all accounts and their current balances
  - Retrieve account details by name
  - Delete accounts when no longer needed

- **Financial Transactions**:
  - **Deposits**: Add money to an account, increasing the account balance
  - **Withdrawals**: Remove money from an account, decreasing the account balance
  - **Transfers**: Move money between two existing accounts, enabling peer-to-peer transactions

---

## 2. Architecture

The Simple Banking System follows a three-tier architecture pattern, separating the presentation layer, business logic layer, and data persistence layer. The system is designed with a clear separation of concerns, enabling maintainability and scalability.

### System Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         User Browser                            │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        │ HTTP Requests
                        │
┌───────────────────────▼─────────────────────────────────────────┐
│                    Frontend Layer                               │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  React Application (Vite)                                │   │
│  │  - AccountList.jsx                                       │   │
│  │  - AccountDetail.jsx                                     │   │
│  │  - NewAccount.jsx                                        │   │
│  │  Port: 5173                                              │   │
│  └────────────────────┬─────────────────────────────────────┘   │
│                       │                                         │
│                       │ API Proxy (/api/*)                      │
│                       │                                         │
└───────────────────────┼─────────────────────────────────────────┘
                        │
                        │ HTTP/REST API
                        │ (localhost:8080)
                        │
┌───────────────────────▼─────────────────────────────────────────┐
│                    Backend Layer (Spring Boot)                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  REST API Controller                                     │   │
│  │  - AccountController                                     │   │
│  │  - Base Path: /api/v1/accounts                           │   │
│  │  - CORS: http://localhost:5173                           │   │
│  └────────────────────┬─────────────────────────────────────┘   │
│                       │                                         │
│                       │ Service Layer                           │
│                       │                                         │
│  ┌────────────────────▼─────────────────────────────────────┐   │
│  │  Business Logic Service                                  │   │
│  │  - AccountService                                        │   │
│  │  - Transaction processing                                │   │
│  │  - Business rules validation                             │   │
│  └────────────────────┬─────────────────────────────────────┘   │
│                       │                                         │
│                       │ Repository Interface                    │
│                       │                                         │
│  ┌────────────────────▼─────────────────────────────────────┐   │
│  │  Data Access Layer                                       │   │
│  │  - AccountRepository (Spring Data JPA)                   │   │
│  │  - Custom queries for account operations                 │   │
│  └────────────────────┬─────────────────────────────────────┘   │
│                       │                                         │
│  Port: 8080           |                                         │
└───────────────────────┼─────────────────────────────────────────┘
                        │
                        │ JDBC (H2 Dialect)
                        │
┌───────────────────────▼─────────────────────────────────────────┐
│                    Database Layer                               │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  H2 In-Memory Database                                   │   │
│  │  - Database: BankDatabase                                │   │
│  │  - H2 Console: /h2-console                               │   │
│  │  - Embedded in Spring Boot application                   │   │
│  └──────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### Component Description

#### Frontend Layer (React + Vite)

The frontend is a single-page application built with React and Vite:

- **Technology**: React 18+ with Vite build tool
- **Port**: 5173 (development server)
- **Key Components**:
  - `AccountList.jsx`: Displays all accounts in a list view
  - `AccountDetail.jsx`: Shows individual account details and transaction options
  - `NewAccount.jsx`: Handles account creation form
- **API Communication**: Uses fetch API to communicate with the backend REST API
- **Proxy Configuration**: Vite development server proxies `/api/*` requests to `http://localhost:8080` to avoid CORS issues during development

**Frontend Routing:**
- `/` → Accounts list view
- `/new` → Create account form
- `/accounts/:name` → Account detail view with transaction options

#### Backend Layer (Spring Boot)

The backend is built using Spring Boot framework with a layered architecture:

**1. REST API Controller Layer**
- **Component**: `AccountController`
- **Base Path**: `/api/v1/accounts`
- **Port**: 8080 (default Spring Boot port)
- **CORS Configuration**: Allows cross-origin requests from `http://localhost:5173`
- **Responsibilities**:
  - Handles HTTP requests and responses
  - Maps HTTP methods to service operations
  - Returns appropriate HTTP status codes

**REST API Endpoints** (Base API: `/api/v1`):
- `GET /accounts` - Retrieves all accounts
- `GET /accounts/{name}` - Retrieves one account by name
- `POST /accounts/createAccount` - Creates a new account
- `DELETE /accounts/{name}` - Deletes an account by name
- `POST /accounts/{name}/deposit` - Deposits money into an account
- `POST /accounts/{name}/withdraw` - Withdraws money from an account
- `POST /accounts/{name}/transfer` - Transfers money from one account to another

**2. Service Layer**
- **Component**: `AccountService`
- **Responsibilities**:
  - Implements business logic
  - Validates business rules (e.g., sufficient balance for withdrawals)
  - Orchestrates transaction operations (deposits, withdrawals, transfers)
  - Converts between domain models and DTOs

**3. Data Access Layer**
- **Component**: `AccountRepository` (Spring Data JPA interface)
- **Responsibilities**:
  - Provides CRUD operations for Account entities
  - Implements custom queries for account lookups by name
  - Handles database transactions for account operations
  - Uses JPA/Hibernate for ORM mapping

#### Database Layer (H2)

- **Technology**: H2 in-memory database
- **Type**: Embedded database (runs within the Spring Boot application)
- **Configuration**:
  - Database URL: `jdbc:h2:mem:BankDatabase`
  - H2 Console enabled at `/h2-console` for database inspection
  - Uses H2 dialect for Hibernate
- **Characteristics**:
  - Data persists only during application runtime
  - Ideal for development and testing
  - No external database server required

#### Data Model

**Account Entity:**
- `id` (Long) - Unique identifier, auto-generated primary key
- `name` (String) - Account name, must be unique
- `balance` (BigDecimal) - Current account balance, default is 0

### Architecture Patterns

- **Layered Architecture**: Clear separation between presentation, business logic, and data layers
- **RESTful API**: Stateless HTTP-based communication between frontend and backend
- **Repository Pattern**: Abstraction of data access logic through Spring Data JPA
- **DTO Pattern**: Data Transfer Objects for clean API contracts between layers
- **Dependency Injection**: Spring's IoC container manages component dependencies

---

## 3. Build & Setup Guide

This section provides comprehensive instructions for building and setting up the Simple Banking System locally for development purposes.

### Prerequisites

Before building the system, ensure you have the following installed on your local machine:

**Backend Requirements:**
- **Java 21** or higher (JDK)
  - Check version: `java -version`
  - Download from: [Oracle JDK](https://www.oracle.com/java/technologies/downloads/) or [OpenJDK](https://openjdk.org/)
- **Maven 3.9.6** or higher (optional - the project includes Maven Wrapper)
  - Check version: `mvn -version`
  - The project includes `mvnw` (Linux/Mac) and `mvnw.cmd` (Windows) for automatic Maven usage

**Frontend Requirements:**
- **Node.js 18** or higher
  - Check version: `node -version`
  - Download from: [nodejs.org](https://nodejs.org/)
- **npm** (comes bundled with Node.js)
  - Check version: `npm -version`

**Development Tools:**
- **Git** (for cloning the repository)
  - Check version: `git --version`
- A terminal or command prompt
- A code editor (e.g., IntelliJ IDEA, VS Code, Eclipse)

### Manual Build Process

#### Building the Backend (Spring Boot)

The backend uses Maven for build management. You can use the included Maven Wrapper (`mvnw` or `mvnw.cmd`) which automatically downloads the correct Maven version, or use your system's Maven installation.

1. **Navigate to the backend directory:**
   ```bash
   cd SimpleBankingSystem
   ```

2. **Build the JAR file:**
   
   On Linux/Mac:
   ```bash
   ./mvnw clean package
   ```
   
   On Windows:
   ```bash
   mvnw.cmd clean package
   ```
   
   This creates an executable JAR file at `target/SimpleBankingSystem-0.0.1-SNAPSHOT.jar`

3. **Run the application:**
   
   ```bash
   java -jar target/SimpleBankingSystem-0.0.1-SNAPSHOT.jar
   ```
   
   The backend will start on `http://localhost:8080`. 

#### Building the Frontend (React + Vite)

1. **Navigate to the frontend directory:**
   ```bash
   cd frontend
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

   This installs all required dependencies listed in `package.json` into the `node_modules/` directory. This step is required before running or building the frontend.

3. **Start the development server:**
   ```bash
   npm run dev
   ```

   The frontend will start on `http://localhost:5173` with hot-reload enabled. Any changes you make to the source code will automatically refresh in the browser.



#### Running & accessing the Full Stack Locally

To run the complete application, you need both the backend and frontend running simultaneously.

- **Frontend Application**: [http://localhost:5173](http://localhost:5173)
- **Backend API**: [http://localhost:8080/api/v1/accounts](http://localhost:8080/api/v1/accounts)
- **H2 Database Console**: [http://localhost:8080/h2-console](http://localhost:8080/h2-console)
   - JDBC URL: `jdbc:h2:mem:BankDatabase`
   - Username: (leave empty)
   - Password: (leave empty)
   - Driver Class: `org.h2.Driver`

### Troubleshooting

**Common Issues:**

1. **Port already in use:**
   - Backend (8080): Stop other applications using port 8080 or change the port in `application.properties`
   - Frontend (5173): Stop other Vite servers or the port will auto-increment

2. **Maven Wrapper permission denied (Linux/Mac):**
   ```bash
   chmod +x mvnw
   ```

3. **npm install fails:**
   - Clear npm cache: `npm cache clean --force`
   - Delete `node_modules/` and `package-lock.json`, then run `npm install` again

4. **Backend fails to start:**
   - Check Java version: `java -version` (must be Java 21+)
   - Check if port 8080 is available
   - Review error logs in the console

5. **Frontend can't connect to backend:**
   - Ensure backend is running on `http://localhost:8080`
   - Check browser console for CORS errors
   - Verify `vite.config.js` proxy configuration

---

## 4. Test Strategy

Quality assurance is ensured through multiple testing layers and code analysis tools.

### Unit Tests

Unit tests are written using JUnit 5 and Spring Boot Test framework. Run all unit tests and generate coverage reports:

```bash
cd SimpleBankingSystem
./mvnw clean verify
```

This generates JaCoCo coverage reports in `target/site/jacoco/`. Coverage reports include line, branch, and method coverage metrics.

### Integration Tests

Integration tests verify end-to-end functionality through HTTP requests to the running backend. Run integration tests:

```bash
cd scripts
./integration_test.sh
```

The integration test script validates account creation, deposits, withdrawals, and balance updates.

### SonarQube Analysis

Static code analysis is performed using SonarQube to identify code smells, bugs, security vulnerabilities, and maintain code quality standards. SonarQube configuration is defined in `application.properties` and analysis runs automatically in the CI/CD pipeline.

---

## 5. CI/CD Pipeline

The project uses GitHub Actions for automated CI/CD. The pipeline triggers on every push to the `main` branch and consists of two main jobs.

### Build & Test Job

**1. Cleanup & Checkout**
- Cleans up existing Docker containers and images
- Checks out the repository code

**2. Build Test Image & Run Integration Tests**
- Builds Docker image for testing
- Runs container and executes integration tests via `scripts/integration_test.sh`

**3. Build Production Image**
- Builds production Docker image with tags: `latest` and timestamp
- Runs production container for validation

**4. Tag & Push**
- Tags Docker image for registry
- Pushes image to container registry (`10.0.40.193:5000/team191/simplebankingsystem:latest`)

**5. Extract Coverage Report**
- Extracts JaCoCo coverage report from build stage
- Copies coverage XML to `target/site/jacoco/`

**6. SonarQube Analysis**
- Runs SonarQube scanner to analyze code quality
- Uploads coverage reports and code metrics to SonarQube server

**7. Build Documentation**
- Builds MkDocs HTML site from `docs/doc.md`
- Generates PDF documentation using Pandoc
- Builds Nginx documentation container image
- Pushes documentation image to registry

### Deploy Job

**1. Setup SSH Connection**
- Creates SSH key from GitHub secrets
- Adds production server to known hosts

**2. Deploy Containers**
- Pulls latest images from registry
- Stops and removes old containers
- Deploys Spring Boot application container (port 1911)
- Deploys documentation container (port 1912)

**3. Verify Deployment**
- Performs health check on Spring Boot application
- Verifies documentation site is accessible

The pipeline ensures automated testing, code quality analysis, and deployment to production with almost zero-downtime updates.

---
