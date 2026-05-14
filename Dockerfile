# ==================== STAGE 1: BUILD ====================
FROM maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copiar archivos Maven primero
COPY pom.xml .
COPY .mvn .mvn
COPY mvnw mvnw
RUN chmod +x mvnw

# Descargar dependencias (caching)
RUN ./mvnw dependency:go-offline -B

# Copiar código fuente
COPY src ./src

# Construir el JAR
RUN ./mvnw clean package -DskipTests

# ==================== STAGE 2: RUNTIME ====================
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Crear usuario no-root 
RUN addgroup -g 1001 -S spring && adduser -S -u 1001 spring
USER spring

# Copiar solo el JAR desde la etapa anterior
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080  
ENTRYPOINT ["java", "-jar", "app.jar"]