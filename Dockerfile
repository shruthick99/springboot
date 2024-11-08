# Step 1: Use the official OpenJDK image as the base image
FROM openjdk:17-jdk-slim

# Step 2: Set the working directory inside the container (optional, but recommended)
WORKDIR /app

# Step 3: Copy the Spring Boot application JAR into the container
# Use the correct path to the JAR file (demo-0.0.1-SNAPSHOT.jar)
COPY target/demo-0.0.1-SNAPSHOT.jar app.jar

# Step 4: Expose the application port (default port for Spring Boot)
EXPOSE 8080

# Step 5: Define the command to run the Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]
