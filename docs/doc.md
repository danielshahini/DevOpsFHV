# DevOps Course - Project Documentation

[TOC]

## Introduction

This document captures the work completed as part of the DevOps course (024717050608).
The focus of the course is to build a small application as a team of 3 people, 
set up continuous integration/deployment and automate supporting tasks such as documentation generation, testing and code analysis. 
The documentation is versioned and will evolve as the project progresses.

---

---

# SimpleBankingSystem-SpringBoot

## API Endpoints(BASE-API: /api/v1)

* GET /accounts - Gets all accounts
* GET /accounts/{name} - Gets one account by name
* POST /accounts - Creates one account
* DELETE /accounts/{name} - Deletes an account by name
* POST /accounts/{name}/deposit - Puts money into account
* POST /accounts/{name}/withdraw - Gets money from account
* POST /accounts/{name}/transfer - Sends money to another existing account

## Entities

**Account**: 
- id 
- name
- balance

## Setup

docker run --name simpleBankingBankingSystem -e POSTGRES_USER=user -e POSTGRES_PASSWORD=password -e POSTGRES_DB=simpleBankingSystem -p 5432:5432 -d postgres

docker network create my-net
docker network connect my-net dein_postgres_container
docker network connect my-net dein_springboot_container


---

---

# Account Management Frontend

This is a **React + Vite** frontend application for managing bank accounts.  
It allows users to:

- View all accounts and their balances
- Create new accounts
- Deposit, withdraw, and transfer money

The frontend communicates with a backend REST API exposed under `/api/v1`.

## Routing:
- `/` → Accounts list
- `/new` → Create account form
- `/accounts/:name` → Account detail view

---

## Setup

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

# CI/CD Pipeline

## GitHub Actions Workflow (`.github/workflows/hello.yml`)

This workflow automates building, testing, quality analysis, and documentation deployment using a **self-hosted runner** and Docker-based steps.

---

## Workflow Overview

### Trigger
- Runs automatically on **push** to the `main` branch.

### Environment
- **Runner:** `self-hosted`
- **Core Tools:** Docker, SonarQube, MkDocs Material, Pandoc/LaTeX

---

## Steps Breakdown

### 🧹 Cleanup Phase
Removes all running/stopped containers, networks, and dangling images to ensure a clean environment before each build.

```bash
docker stop $(docker ps -aq) || true
docker rm $(docker ps -aq) || true
docker network prune -f || true
docker image prune -f || true
```

---

### 🧾 Checkout Repository
Uses the official `actions/checkout@v4` action to clone the project repository to the runner.

---

### 💬 Hello World Verification
A basic sanity check that confirms runner execution:

```bash
echo "Hello World from GitHub Actions Runner!"
```

---

### 🐳 Build Docker Image
Builds the backend service image with both a `latest` tag and a timestamp-based tag:

```bash
docker build .   --file Dockerfile   --tag simplebankingsystem:latest   --tag simplebankingsystem:$(date +%s)
```

---

### 🧱 Run Containers
1. **Run Docker Hello World**  
   Confirms Docker functionality:
   ```bash
   docker run hello-world
   ```

2. **Run SimpleBankingSystem**
   ```bash
   docker run -d      --name simplebankingsystem      --restart unless-stopped      --network host      -p 8080:8080      simplebankingsystem:latest
   ```

---

### 🧪 Integration Tests
Copies and executes a test script inside the container:

```bash
docker cp ./scripts/integration_test.sh simplebankingsystem:/integration_test.sh
docker exec simplebankingsystem chmod +x /integration_test.sh
docker exec simplebankingsystem /integration_test.sh
```

---

### 🏷️ Tag & Push Image
Tags the built image and pushes it to the private Docker registry:

```bash
docker tag simplebankingsystem:latest 10.0.40.193:5000/team191/simplebankingsystem:latest
docker push 10.0.40.193:5000/team191/simplebankingsystem:latest
```

---

### ⚙️ Build Stage Extraction
Builds a temporary **build-stage** image to extract compiled Java classes:

```bash
docker build . --target build -t simplebankingsystem-build
container_id=$(docker create simplebankingsystem-build)
mkdir -p target
docker cp "$container_id":/app/target/classes ./target/classes
docker rm "$container_id"
```

---

### 🔍 SonarQube Static Analysis
Runs a full SonarQube scan using Docker:

```bash
docker run --rm   -e SONAR_HOST_URL=http://10.0.40.193:9000/   -e SONAR_TOKEN=<SECRET_TOKEN>   -v $(pwd):/usr/src   sonarsource/sonar-scanner-cli:latest     -Dsonar.projectKey=simplebankingsystem     -Dsonar.sources=.     -Dsonar.java.binaries=target/classes
  -Dsonar.host.url=http://10.0.40.193:9000/
  -Dsonar.login=<SECRET_TOKEN>
```

This ensures **code quality**, **coverage**, and **security compliance** before deployment.

---

### 🔐 Permission Fix
Prevents permission conflicts when Docker creates root-owned files:

```bash
docker run --rm -v "${PWD}":/project bash:latest chown --recursive $(id -u):$(id -g) /project
```

---

### 📥 Repository Checkout (Docs Stage)
Refreshes the workspace before building the documentation site:

```yaml
uses: actions/checkout@v4
```

---

### 📚 Documentation Build (MkDocs)
Builds project documentation inside a `squidfunk/mkdocs-material` container:

```bash
docker run --rm \
  -u "$(id -u):$(id -g)" \
  -v "${PWD}:/docs" \
  -w /docs \
  squidfunk/mkdocs-material \
  build -d /docs/build/site

echo "📂 Inhalt von build/site nach MkDocs-Build:"
ls -R build/site
```

---

### ✅ Documentation Validation
Ensures documentation is properly generated:

```bash
if [ ! -f build/site/doc/index.html ]; then
  echo "❌ Documentation not built!"
  exit 1
fi
echo "✅ Documentation successfully built!"
```

---

### 📄 PDF Build (Pandoc/LaTeX)
Renders the documentation as a PDF using Pandoc with the LaTeX engine:

```bash
docker run --rm \
  -v "${PWD}:/data" \
  -w /data \
  pandoc/latex:latest \
  ./docs/doc.md \
    --from gfm \
    --toc --toc-depth=3 \
    --pdf-engine=xelatex \
    -V papersize=A4 \
    -V geometry:margin=20mm \
    --metadata title="Project Documentation" \
    -o build/site/documentation.pdf
```

---

### 🧾 PDF Validation
Verifies the PDF has been generated successfully:

```bash
test -f build/site/documentation.pdf || (echo "❌ PDF not found!"; exit 1)
echo "✅ PDF created: build/site/documentation.pdf"
```

---

### 🌐 Documentation Deployment
Builds and deploys an Nginx container serving the generated docs:

```bash
# Just to be safe: Remove eventually existing images.
docker image rm my-documentation || true

# Build the documentation image
docker build -f Dockerfile.nginx -t my-documentation .

# List images for diagnostics
docker image ls --all

# Run the documentation image
docker run --name mydoc -d --restart always -p 8081:80 my-documentation
```

---

### 🔬 Documentation Integration Test
Performs an automated integration test using curl inside an Alpine-based container:

```bash
docker run --name docintegrationtest --network host --rm   -v "${PWD}/integrationtest.sh:/integrationtest.sh:ro"   ellerbrock/alpine-bash-curl-ssl bash /integrationtest.sh
```

---


---
