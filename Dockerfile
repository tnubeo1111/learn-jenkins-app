FROM maven:3.9.0-eclipse-temurin-17 as build
WORKDIR /app
COPY . .
RUN mvn clean install 

FROM eclipse-temurin:17.0.6_10-jdk
WORKDIR /app
COPY --from=build /app/.m2/repository/org/example/org.example.codegen/0.0.1-SNAPSHOT/org.example.codegen-0.0.1-SNAPSHOT.jar /apps/
EXPOSE 8080
CMD [ "java", "-jar","org.example.codegen-0.0.1-SNAPSHOT.jar" ]