# STAGE 1 BUILD STAGE 
FROM eclipse-temurin:21-jdk AS BUILD_STAGE

WORKDIR /app

COPY mvnw . 
COPY .mvn .mvn 
COPY pom.xml .

RUN ./mvnw dependency:go-offline

COPY src ./src

RUN ./mvnw clean  package -DskipTests


# STAGE 2 RUNNING SATGE

FROM eclipse-temurin:21-jre 

WORKDIR /app 

COPY --from=BUILD_STAGE /app/target/*.jar app.jar 

EXPOSE 8080 

ENTRYPOINT ["java", "-jar", "app.jar"]