# Stage 1: Build the application with Maven
FROM maven:3.8.8-eclipse-temurin-11 AS builder

WORKDIR /build

# Copy pom.xml and download dependencies (cache layer)
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy source code and build
COPY src ./src
RUN mvn package -DskipTests -B

# Stage 2: Run the application with Tomcat
FROM tomcat:10.1-jdk11-temurin

WORKDIR /usr/local/tomcat

# Remove default ROOT application
RUN rm -rf webapps/ROOT webapps/ROOT.war

# Copy the built WAR from the builder stage
COPY --from=builder /build/target/ROOT.war webapps/

# Expose port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]

