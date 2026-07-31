# Stage 1: Build the Maven application
FROM maven:3.8.5-openjdk-17 AS builder
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Bundle the WAR into Tomcat
# FIX: Changed to a standard stable official tag (Tomcat 10.1 running on JDK 17)
FROM tomcat:10.1-jdk17-temurin
WORKDIR /usr/local/tomcat/webapps/

# Copy the built war from the builder stage
COPY --from=builder /app/target/*.war ./myapp.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
