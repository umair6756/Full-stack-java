# Stage 1: Build with Maven
FROM maven:3.8.5-openjdk-8 AS builder

# Set working directory
WORKDIR /app

# Copy the complete project folder (assuming everything is inside PlantPlaces folder)
COPY PlantPlaces/pom.xml ./pom.xml
COPY PlantPlaces/src ./src
COPY PlantPlaces/WebContent ./WebContent

# Build the WAR file
RUN mvn clean package

# Stage 2: Use Tomcat to deploy the WAR
FROM tomcat:9.0-jdk8

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy WAR file from previous stage
COPY --from=builder /app/target/PlantPlaces.war /usr/local/tomcat/webapps/PlantPlaces.war

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
