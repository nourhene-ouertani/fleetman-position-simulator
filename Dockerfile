FROM eclipse-temurin:17-jre
LABEL maintainer="Nourhene Ouertani"
ADD target/positionsimulator-0.0.1-SNAPSHOT.jar webapp.jar
CMD ["java","-jar","webapp.jar"]
