# DevOps Course - Project Documentation

## Introduction

This document captures the work completed as part of the DevOps course (024717050608).
The focus of the course is to build a small application as a team of 3 people, 
set up continuous integration/deployment and automate supporting tasks such as documentation generation, testing and code analysis. 
The documentation is versioned and will evolve as the project progresses.

---

---

## SimpleBankingSystem-SpringBoot

### API Endpoints(BASE-API: /api/v1)

* GET /accounts - Gets all accounts
* GET /accounts/{name} - Gets one account by name
* POST /accounts - Creates one account
* DELETE /accounts/{name} - Deletes an account by name
* POST /accounts/{name}/deposit - Puts money into account
* POST /accounts/{name}/withdraw - Gets money from account
* POST /accounts/{name}/transfer - Sends money to another existing account

### Entities

**Account**: 
- id 
- name
- balance

### Setup

docker run --name simpleBankingBankingSystem -e POSTGRES_USER=user -e POSTGRES_PASSWORD=password -e POSTGRES_DB=simpleBankingSystem -p 5432:5432 -d postgres

docker network create my-net
docker network connect my-net dein_postgres_container
docker network connect my-net dein_springboot_container


---

---

## Account Management Frontend

This is a **React + Vite** frontend application for managing bank accounts.  
It allows users to:

- View all accounts and their balances
- Create new accounts
- Deposit, withdraw, and transfer money

The frontend communicates with a backend REST API exposed under `/api/v1`.

### Routing:
- `/` --> Accounts list
- `/new` --> Create account form
- `/accounts/:name` --> Account detail view

---

### Setup

1. **Clone the repository**
   ```bash
   git clone https://github.com/danielshahini/DevOpsFHV.git
   cd frontend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Start development server**
   ```bash
   npm run dev
   ```

   By default, the app runs on [http://localhost:5173](http://localhost:5173).

---

---

