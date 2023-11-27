FROM maven:3.9.5-eclipse-temurin-17-alpine AS builder
WORKDIR /app
COPY . /app
RUN mvn clean package -DskipTests


FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY --from=builder /app/target/*.jar /app/poi-desk-api.jar
ENTRYPOINT ["java","-jar","/app/poi-desk-api.jar"]