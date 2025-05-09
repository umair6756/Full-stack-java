# Stage 1: Build with Maven
FROM maven:3.8.5-openjdk-8 AS builder

# Set workdir inside the container
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src
COPY WebContent ./WebContent

# Package the WAR file
RUN mvn clean package

# Stage 2: Use Tomcat to deploy the WAR
FROM tomcat:9.0-jdk8

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file from builder stage
COPY --from=builder /app/target/PlantPlaces.war /usr/local/tomcat/webapps/PlantPlaces.war

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
