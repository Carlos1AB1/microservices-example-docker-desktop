#!/bin/bash

# Asegúrate de que el script se detiene si hay errores
set -e

echo "Compilando el proyecto principal..."
./mvnw clean package -DskipTests

echo "Copiando archivos de configuración para Docker..."
# Crear directorios de recursos si no existen
mkdir -p eureka-server/src/main/resources/
mkdir -p gateway-service/src/main/resources/
mkdir -p service-a/src/main/resources/
mkdir -p service-b/src/main/resources/

# Copiar archivos de configuración Docker
cp eureka-server-application-docker.yml eureka-server/src/main/resources/application-docker.yml
cp gateway-application-docker.yml gateway-service/src/main/resources/application-docker.yml
cp service-a-application-docker.yml service-a/src/main/resources/application-docker.yml
cp service-b-application-docker.yml service-b/src/main/resources/application-docker.yml

echo "Preparando archivos Docker..."
cp eureka-server-dockerfile eureka-server/Dockerfile
cp gateway-dockerfile gateway-service/Dockerfile
cp service-a-dockerfile service-a/Dockerfile
cp service-b-dockerfile service-b/Dockerfile

echo "Build completado. Ahora puedes ejecutar 'docker-compose up'"
