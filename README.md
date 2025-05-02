# Microservicios con Spring Cloud y Docker

Este proyecto demuestra una arquitectura de microservicios completamente containerizada construida con Spring Cloud, Spring Boot y Docker. Exhibe varios patrones clave de microservicios incluyendo descubrimiento de servicios, API gateway y almacenamiento de datos independiente.

## Descripción de la Arquitectura

La aplicación consta de los siguientes componentes:

- **Servidor Eureka**: Descubrimiento y registro de servicios
- **API Gateway**: Enrutamiento centralizado y balanceo de carga
- **Servicio A (Productos)**: Microservicio de gestión de productos
- **Servicio B (Órdenes)**: Microservicio de gestión de órdenes
- **Bases de datos MySQL**: Instancias separadas para cada servicio

```
┌─────────────────┐     ┌─────────────────┐
│                 │     │                 │
│   API Gateway   │────▶│   Servicio A    │
│   (Puerto 8080) │     │   (Puerto 8081) │
│                 │     │                 │
└────────┬────────┘     └────────┬────────┘
         │                       │
         │                       ▼
         │               ┌─────────────────┐
         │               │                 │
         │               │   MySQL A       │
┌────────▼────────┐      │   (Puerto 3307) │
│                 │      │                 │
│ Servidor Eureka │      └─────────────────┘
│  (Puerto 8761)  │
│                 │      ┌─────────────────┐
└────────┬────────┘      │                 │
         │               │   Servicio B    │
         │               │   (Puerto 8082) │
         │               │                 │
         │               └────────┬────────┘
         │                        │
         │                        ▼
         │                ┌─────────────────┐
         └───────────────▶│                 │
                          │   MySQL B       │
                          │   (Puerto 3308) │
                          │                 │
                          └─────────────────┘
```

## Características

- **Descubrimiento de Servicios**: Servidor Eureka para registro y descubrimiento automático
- **API Gateway**: Spring Cloud Gateway para enrutamiento inteligente y balanceo de carga
- **Containerización**: Docker y Docker Compose para orquestación de contenedores
- **Base de datos**: Instancias MySQL separadas para cada servicio, asegurando aislamiento de datos
- **Verificación de estado**: Monitoreo de salud de contenedores para una operación robusta
- **Aislamiento de red**: Los servicios se comunican a través de una red Docker definida
- **Almacenamiento persistente**: Volúmenes Docker para persistencia de datos

## Prerequisitos

- Java 17+
- Maven
- Docker y Docker Compose
- MySQL (solo para desarrollo local sin Docker)

## Inicio Rápido

### Compilación de la Aplicación

```bash
# Clonar el repositorio
git clone <url-repositorio>
cd microservices-example

# Compilar el proyecto con Maven
./build.sh
```

### Ejecución con Docker Compose

```bash
# Iniciar todos los servicios con Docker Compose
docker-compose up -d

# Ver logs (opcional)
docker-compose logs -f

# Detener todos los servicios
docker-compose down
```

## Endpoints de Servicios

Después de iniciar la aplicación, puedes acceder a los siguientes endpoints:

- **Panel de Eureka**: http://localhost:8761
- **API Gateway**: http://localhost:8080
- **API de Productos**: http://localhost:8080/api/products
- **API de Órdenes**: http://localhost:8080/api/orders

## Configuración de Docker

El proyecto utiliza Docker para containerizar todos los componentes con las siguientes características:

- **Construcción multi-etapa**: Creación eficiente de contenedores
- **Verificaciones de salud**: Los contenedores son monitoreados para su disponibilidad
- **Gestión de dependencias**: Los servicios esperan a que sus dependencias estén disponibles
- **Montaje de volúmenes**: Configuración y persistencia de datos
- **Aislamiento de red**: Red puente personalizada para comunicación segura
- **Restricciones de recursos**: Límites configurables de memoria y CPU

### Ventajas del Modelo Containerizado

1. **Aislamiento de Componentes**: Cada servicio y base de datos opera en su propio contenedor, evitando conflictos de dependencias.
   
2. **Portabilidad**: El sistema se ejecuta de manera consistente en cualquier entorno que soporte Docker.
   
3. **Escalabilidad**: Facilidad para escalar servicios individualmente según la demanda.
   
4. **Reproducibilidad**: Entornos de desarrollo, prueba y producción consistentes.
   
5. **Automatización**: Despliegue simplificado y automatizado con Docker Compose.
   
6. **Resilencia**: La configuración de health checks garantiza que los servicios se reinicien automáticamente en caso de fallo.

### Estructura de Docker Compose

El archivo `docker-compose.yml` orquesta todos los servicios:

1. **Secuencia de construcción**:
   - Primero, el servidor Eureka inicia y espera hasta estar saludable
   - Los contenedores de base de datos se inicializan con esquema y datos de ejemplo
   - Los microservicios inician una vez que sus dependencias están disponibles
   - El API Gateway inicia al final, después de que todos los servicios están registrados

2. **Montaje de configuración**:
   - Cada servicio tiene su propia configuración montada en `/app/application-docker.yml`
   - Los scripts de inicialización de base de datos están montados para los contenedores MySQL

3. **Redes**:
   - Todos los servicios se conectan a través de `microservices-network`
   - Los servicios se refieren entre sí usando nombres de contenedores como nombres de host

4. **Persistencia de datos**:
   - Los datos MySQL se almacenan en volúmenes Docker (`mysql-service-a-data` y `mysql-service-b-data`)

## Desarrollo

### Desarrollo Local

Para desarrollo local sin Docker:

1. Configura el `application.yml` de cada servicio para usar conexiones localhost
2. Inicia instancias MySQL en los puertos 3306 (o ajusta la configuración)
3. Inicia el servidor Eureka primero, luego todos los demás servicios

### Agregar Nuevos Servicios

Para agregar un nuevo microservicio:

1. Crea un nuevo módulo Spring Boot en el proyecto Maven
2. Agrega las dependencias necesarias (Spring Cloud, cliente Eureka, etc.)
3. Configura las propiedades del servicio
4. Actualiza los archivos Docker y Docker Compose
5. Registra las rutas en el API Gateway

## Estructura del Proyecto Containerizado

### Dockerfiles

Cada servicio tiene su propio Dockerfile con las siguientes características:

**Ejemplo de Dockerfile (Servicio):**
```dockerfile
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY target/service-a-*.jar app.jar

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "app.jar"]
```

Las imágenes Docker están basadas en Alpine Linux para minimizar el tamaño, utilizando una imagen JRE optimizada que es significativamente más pequeña que una imagen JDK completa.

### Verificaciones de Salud

Las verificaciones de salud están configuradas para todos los servicios con un enfoque de dependencia escalonada:

```yaml
healthcheck:
  test: ["CMD", "wget", "-q", "--spider", "http://localhost:8761/actuator/health"]
  interval: 30s
  timeout: 10s
  retries: 5
```

### Perfiles de Spring Boot

El sistema utiliza perfiles de Spring Boot para separar las configuraciones:

```yaml
environment:
  - SPRING_PROFILES_ACTIVE=docker
```

Cada servicio carga su configuración específica para Docker, permitiendo diferentes configuraciones por entorno.

### Scripts de Inicialización de Base de Datos

Los contenedores MySQL utilizan scripts montados para inicializar la base de datos:

```yaml
volumes:
  - ./init-service-a.sql:/docker-entrypoint-initdb.d/init.sql
```

## Comandos Docker Útiles

### Monitoreo de Contenedores

```bash
# Ver logs de un servicio específico
docker-compose logs -f service-a

# Ver estadísticas de uso de recursos
docker stats

# Inspeccionar la configuración de red
docker network inspect microservices-network
```

### Administración de Contenedores

```bash
# Reiniciar un servicio específico
docker-compose restart service-a

# Escalar un servicio (múltiples instancias)
docker-compose up -d --scale service-a=2

# Entrar a un contenedor 
docker exec -it service-a /bin/sh
```

### Administración de Datos

```bash
# Acceder a la base de datos MySQL
docker exec -it mysql-service-a mysql -umicro_user -pmicro_pass db_service_a

# Hacer backup de los datos
docker exec mysql-service-a sh -c 'exec mysqldump -umicro_user -pmicro_pass db_service_a' > backup.sql
```

## Consideraciones para Producción

Para despliegue en producción, considera:

- Usar Kubernetes para orquestación
- Implementar un registro de contenedores privado
- Configurar límites de recursos por contenedor
- Implementar monitoreo con Prometheus y Grafana
- Centralizar logs con ELK Stack o Graylog
- Configurar secretos seguros (no en archivos planos)
- Implementar Circuit Breakers con Resilience4j
- Configurar CI/CD específico para entornos containerizados

## Pruebas de API

### Ejemplos de Peticiones

**Obtener todos los productos:**
```bash
curl -X GET http://localhost:8080/api/products
```

**Crear un nuevo producto:**
```bash
curl -X POST http://localhost:8080/api/products \
  -H "Content-Type: application/json" \
  -d '{"name": "Nuevo Producto", "price": 299.99}'
```

**Obtener todas las órdenes:**
```bash
curl -X GET http://localhost:8080/api/orders
```

**Crear una nueva orden:**
```bash
curl -X POST http://localhost:8080/api/orders \
  -H "Content-Type: application/json" \
  -d '{"customerName": "Juan García", "productId": 1, "quantity": 3}'
```

## Solución de Problemas Comunes

### Problemas de Conexión entre Servicios

Si los servicios no pueden comunicarse entre sí:
```bash
# Verifica que todos los contenedores estén en la misma red
docker network inspect microservices-network

# Asegúrate que los nombres de host coincidan con los nombres de contenedor
docker-compose ps

# Verifica que Eureka muestre todos los servicios registrados
curl http://localhost:8761/eureka/apps
```

### Errores de Base de Datos

Si hay problemas con las conexiones a la base de datos:
```bash
# Verifica que los contenedores MySQL estén ejecutándose
docker ps | grep mysql

# Prueba la conexión directamente
docker exec -it mysql-service-a mysql -umicro_user -pmicro_pass -e "SHOW DATABASES;"

# Revisa los logs de MySQL
docker logs mysql-service-a
```

### Reinicio de Servicios

Si necesitas reiniciar todo el sistema después de cambios:
```bash
# Detener todos los servicios
docker-compose down

# Eliminar volúmenes (si has cambiado esquemas de BD)
docker-compose down -v

# Reconstruir las imágenes
docker-compose build

# Iniciar todo nuevamente
docker-compose up -d
```

### Verificar Logs de Servicios

Para diagnosticar problemas en servicios específicos:
```bash
# Ver logs del servidor Eureka
docker-compose logs eureka-server

# Ver logs del API Gateway
docker-compose logs gateway-service

# Ver logs de los microservicios
docker-compose logs service-a
docker-compose logs service-b
```
