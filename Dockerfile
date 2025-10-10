# --- Stage 1: Build mit Maven ---
FROM maven:3.9.6-eclipse-temurin-21 AS build
WORKDIR /app
COPY SimpleBankingSystem .
RUN mvn clean verify

RUN ls -l target/site/jacoco || echo "No coverage report generated"

 RUN apt-get update && apt-get install -y unzip curl \
     && curl -sSLo sonar-scanner.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip \
     && unzip sonar-scanner.zip -d /opt \
     && /opt/sonar-scanner-*/bin/sonar-scanner \
        -Dsonar.host.url=http://host.docker.internal:9000 \
        -Dsonar.projectKey=simplebankingsystem \
        -Dsonar.sources=src/main/java \
        -Dsonar.java.binaries=target/classes \
        -Dsonar.coverage.jacoco.xmlReportPaths=target/site/jacoco/jacoco.xml


RUN mvn clean package -X

# --- Stage 2: Run Jar ---
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/SimpleBankingSystem-0.0.1-SNAPSHOT.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
