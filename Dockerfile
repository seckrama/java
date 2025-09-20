# ============================
# Étape 1 : Build avec Maven
# ============================
FROM maven:3.9.6-eclipse-temurin-17 AS build

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers pom.xml et télécharger les dépendances
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copier tout le projet et construire l'application
COPY . .
RUN mvn clean package -DskipTests

# ============================
# Étape 2 : Image d’exécution
# ============================
FROM eclipse-temurin:17-jdk-jammy

WORKDIR /app

# Copier uniquement le JAR depuis l'étape de build
COPY --from=build /app/target/*.jar app.jar

# Exposer le port (par défaut pour Spring Boot ou ton app)
EXPOSE 8080

# Commande de lancement
ENTRYPOINT ["java", "-jar", "app.jar"]
