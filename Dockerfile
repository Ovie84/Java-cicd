# Stage 1: Cache dependecies and build

# FROM maven:3.9-eclipse-temurin-17 AS build
FROM maven:3.9-eclipse-temurin-17-alpine AS build
# FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY pom.xml .

# Downloads dependencies once and caches them

RUN mvn dependency:go-offline 
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Tiny final image

# FROM eclipse-temurin:17-jre-jammy
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
# ARG JAR_FILE=target/*.jar
# COPY ${JAR_FILE} app.jar
EXPOSE 8080
ENTRYPOINT [ "java", "-jar", "/app.jar" ]