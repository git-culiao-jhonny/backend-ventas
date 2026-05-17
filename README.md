# Backend Ventas

API REST Spring Boot para administrar compras/ventas.

## Que hace

Este servicio permite:

- crear una venta
- listar ventas
- consultar una venta por ID
- actualizar una venta
- eliminar una venta

Forma parte del sistema de despacho junto con el frontend y el backend de despachos.

## Estructura principal

- `src/main/java/com/citt/controller/VentaController.java`: endpoints REST
- `src/main/java/com/citt/persistence/entity/Venta.java`: entidad JPA
- `src/main/java/com/citt/persistence/repository/VentaRepository.java`: acceso a datos
- `src/main/java/com/citt/persistence/services/VentaServiceImpl.java`: logica de negocio
- `src/main/resources/application.properties`: configuracion de Spring
- `Dockerfile`: imagen multi-stage
- `docker-compose.yml`: stack local del servicio

## Modelo de datos

La entidad `Venta` contiene:

- `idVenta`
- `direccionCompra`
- `valorCompra`
- `fechaCompra`
- `despachoGenerado`

Los datos se validan con anotaciones JPA y Bean Validation.

## Endpoints

Base path:

```text
/api/v1/ventas
```

Endpoints:

- `POST /api/v1/ventas`
- `GET /api/v1/ventas`
- `GET /api/v1/ventas/{idVenta}`
- `PUT /api/v1/ventas/{idVenta}`
- `DELETE /api/v1/ventas/{idVenta}`

## Requisitos

- Java 17
- Maven Wrapper incluido en el repositorio
- Docker y Docker Compose, si se ejecuta con contenedores

## Ejecucion local sin Docker

```powershell
./mvnw spring-boot:run
```

En Windows PowerShell:

```powershell
.\mvnw.cmd spring-boot:run
```

## Base de datos

El servicio usa MySQL mediante variables de entorno:

- `DB_ENDPOINT`
- `DB_PORT`
- `DB_NAME`
- `DB_USERNAME`
- `DB_PASSWORD`

En Docker Compose, la base de datos se llama `db-ventas`.

## Ejecucion con Docker

Construccion y prueba local:

```powershell
docker compose up --build
```

Servicios:

- API ventas: `http://localhost:8080`
- Swagger: `http://localhost:8080/swagger-ui.html`
- MySQL ventas: `localhost:3307`

## Logica de negocio

La actualizacion de una venta conserva los campos que no llegan en la solicitud, para evitar borrar informacion ya guardada.

Eso se implementa en `VentaServiceImpl`.

## Dockerfile

El `Dockerfile` usa multi-stage:

1. Build stage con Maven para generar el JAR.
2. Runtime stage con una imagen JRE liviana.
3. Usuario no root para ejecutar la app.

## Despliegue

En CI/CD, este repo usa GitHub Actions para:

1. construir la imagen
2. publicarla en Docker Hub
3. conectarse por SSH a la EC2 del backend
4. ejecutar `docker compose pull` y `docker compose up -d`

Los secrets esperados estan documentados en [deploy/README.md](../../deploy/README.md).
