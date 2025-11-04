# --- Stage 1: Build mit Maven ---
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY SimpleBankingSystem .
RUN mvn clean verify

RUN mkdir -p ~/coverage && cp target/site/jacoco/jacoco.xml ~/coverage/jacoco.xml
RUN mvn clean package -X

# ---- ADD FRONTEND BUILD ----
FROM node:18 AS frontend
WORKDIR /app/frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend .
RUN npm run build

# ---- BACK TO MAVEN BUILD ----
FROM maven:3.9.6-eclipse-temurin-21 AS build-with-frontend
WORKDIR /app
COPY SimpleBankingSystem .
# Copy the frontend build into Spring Boot’s static folder BEFORE packaging
COPY --from=frontend app/frontend/dist ./src/main/resources/static/
RUN mvn clean package -DskipTests

# --- Stage 3: Run Jar ---
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/SimpleBankingSystem-0.0.1-SNAPSHOT.jar app.jar
COPY --from=frontend /app/frontend/dist ./frontend-dist
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

