# Use Java 8 since your pom.xml uses Java 1.8
FROM maven:3.8.6-openjdk-8 AS build

WORKDIR /app

# Copy pom.xml first for dependency caching
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build project
RUN mvn clean package -DskipTests

# Runtime image
FROM eclipse-temurin:8-jdk

WORKDIR /app

# Copy generated jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Run application
CMD ["java", "-jar", "app.jar"]