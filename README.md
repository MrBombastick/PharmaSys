# PharmaSys - Sistema Farmacéutico

Este repositorio contiene la estructura inicial del backend y la base de datos para el sistema **PharmaSys** Hecho por y para Julian Montoya :D!

## Estructura del Proyecto

* `database/init.sql`: Script ejecutable para PostgreSQL con la creación de tablas, llaves primarias, foráneas, restricciones de integridad y datos semilla (*seeds*).
* `src/config/db.js`: Módulo de conexión a la base de datos PostgreSQL utilizando un *connection pool*.
* `src/index.js`: Servidor Express base con endpoints de verificación de salud y prueba de conexión a la BD.

## Instrucciones para Ejecutar la Base de Datos

1. Crear la base de datos en PostgreSQL:
   ```sql
   CREATE DATABASE pharmasys;
