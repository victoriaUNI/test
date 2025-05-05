# 1) BUILD STAGE: gera o JAR dentro do container
FROM maven:3.8.3-openjdk-17 AS builder

WORKDIR /app

# copia apenas o necessário para cache de dependências
COPY pom.xml mvnw ./
COPY .mvn .mvn
RUN chmod +x mvnw \
    && ./mvnw dependency:go-offline -B

# copia o código‑fonte e empacota
COPY src ./src
RUN ./mvnw package -DskipTests

# 2) RUNTIME STAGE: imagem leve só com JRE e o JAR gerado
FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# pega o JAR que foi gerado na stage “builder”
COPY --from=builder /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
