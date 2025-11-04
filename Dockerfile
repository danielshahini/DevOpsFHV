# --- Stage 1: Build mit Maven ---
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY SimpleBankingSystem .
RUN mvn clean verify

RUN mkdir -p ~/coverage && cp target/site/jacoco/jacoco.xml ~/coverage/jacoco.xml
RUN mvn clean package -X

# --- Stage 2: Build Frontend mit Node ---
FROM node:18 AS frontend
WORKDIR /frontend
COPY frontend/package*.json ./
RUN npm ci
COPY frontend .
RUN npm run build

# --- Stage 2: Run Jar ---
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/SimpleBankingSystem-0.0.1-SNAPSHOT.jar app.jar
COPY --from=frontend /frontend/dist ./frontend-dist
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]

