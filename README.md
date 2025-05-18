# Microservices Orchestrated: Docker, Kubernetes & OCI

Este proyecto implementa una arquitectura de microservicios utilizando **Spring Boot**, **Docker**, **Kubernetes (OKE en OCI)** y **OCI Container Registry (OCIR)**. Incluye un **API Gateway**, un **servicio de catálogo de productos (Service A)**, un **servicio de órdenes (Service B)** y una base de datos MySQL para cada microservicio. La integración y las pruebas se realizan a través de **Postman**.


---

## 🚀 ¿Qué incluye este proyecto?

- **Despliegue en Kubernetes (OKE) sobre OCI**
- **Imágenes Docker almacenadas en OCIR**
- **Microservicios Java Spring Boot** (Service A, Service B, Gateway, Eureka)
- **Bases de datos MySQL** para cada servicio
- **API Gateway** centralizado
- **Service Discovery** con Eureka


---

## ☸️ Despliegue en Kubernetes (OKE) 🟢 ¡Ya está desplegado! ¿Cómo probarlo? ## 

### 1. Consulta la IP pública del Gateway

Tu Gateway está expuesto como tipo `LoadBalancer`.  
Ejemplo de IP (ajusta según tu salida real):

```
http://149.130.171.79
```


---

## 🧪 Pruebas con Postman 

- Haz clic en "Import" y selecciona el archivo JSON incluido.
- 📂 Archivo: `dockerized-springboot-microservices-architecture-on-kubernetes-and-oracle-cloud`

  
El proyecto incluye una colección Postman con peticiones organizadas para los servicios:

- Crear, obtener, actualizar y eliminar productos.
- Crear, obtener, actualizar y eliminar órdenes.



> Asegúrate de configurar la variable `{{baseUrl}}` con la IP pública del servicio `gateway-service` expuesto en Kubernetes.

---

## 🐳 Imágenes Docker (OCIR)

- `eureka-server:2025-05-17-101`
- `gateway-service:2025-05-17-202`
- `service-a:2025-05-17-303`
- `service-b:2025-05-17-404`

Todas almacenadas y desplegadas desde **Oracle Container Registry (sa-bogota-1.ocir.io/axv8ixlpasy5/...)**

---

