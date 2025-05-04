FROM eclipse-temurin:17-jdk-alpine

WORKDIR /app

# Copia o pom, o wrapper e o diretório .mvn
COPY pom.xml mvnw ./
COPY .mvn .mvn

# Dá permissão de execução ao mvnw
RUN chmod +x mvnw

# Agora baixa dependências offline
RUN ./mvnw dependency:go-offline -B

# Copia o código‑fonte e empacota
COPY src src
RUN ./mvnw package -DskipTests

ARG JAR_FILE=target/*.jar
COPY ${JAR_FILE} app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","/app.jar"]
