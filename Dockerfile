# =========================
# STAGE 1 — BUILD STAGE
# =========================

FROM eclipse-temurin:21-jdk AS BUILD_STAGE

WORKDIR /app

RUN echo "========== BUILD STAGE STARTED =========="

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

RUN echo "========== Downloading Maven dependencies ==========" && \
    ./mvnw dependency:go-offline

COPY src ./src

RUN echo "========== Building Spring Boot application ==========" && \
    ./mvnw clean package -DskipTests

RUN echo "========== BUILD STAGE COMPLETED =========="


# =========================
# STAGE 2 — RUN STAGE
# =========================

FROM eclipse-temurin:21-jre

WORKDIR /app

RUN echo "========== RUN STAGE STARTED =========="

COPY --from=BUILD_STAGE /app/target/*.jar app.jar

EXPOSE 8080

RUN echo "========== Application JAR copied =========="

ENTRYPOINT ["java", "-jar", "app.jar"]