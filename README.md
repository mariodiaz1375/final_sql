# 🛒 E-Commerce Database & Analytics (PostgreSQL)

Proyecto de diseño, modelado e implementación de una base de datos relacional en **PostgreSQL** para una plataforma de e-commerce. Incluye la creación de la estructura, restricciones de integridad, carga de datos de prueba y un conjunto de consultas analíticas avanzadas utilizando Window Functions, agregaciones y manejo de JSONB.

---

## 🛠️ Estructura del Proyecto

El repositorio está organizado en dos scripts SQL principales que deben ejecutarse en un orden específico

---

## 🚀 Orden de Ejecución

Para garantizar la integridad referencial y evitar errores de llaves foráneas (`FOREIGN KEY`), sigue este orden:

### 1. Ejecutar `estructura.sql`
Este script realiza las siguientes operaciones en orden secuencial:
1. **Borrado preventivo:** Aplica `DROP TABLE IF EXISTS` en orden inverso a las dependencias.
2. **Creación de tablas independientes:** `clientes`, `categorias` y `provincias`.
3. **Creación de tablas dependientes:** `productos` (depende de `categorias`), `pedidos` (depende de `clientes` y `provincias`) y `detalle_pedido` (tabla intermedia muchos a muchos).
4. **Carga de datos (`INSERT`):** Puebla el catálogo con 24 provincias, 3 categorías, 24 clientes, 30 productos (con especificaciones en formato `JSONB`), 100 pedidos y más de 100 detalles de compra.

### 2. Ejecutar `analisis.sql`
Una vez poblada la base de datos, ejecuta este script para correr los reportes analíticos de negocio.

---

## 📊 Consultas e Insights o Hallazgos

### 1. Top 5 Clientes por Gasto Total
* **Técnica utilizada:** `INNER JOIN`, `GROUP BY`, `SUM()`, `COALESCE()` y `LIMIT`.
* **Propósito:** Identificar a los clientes de mayor valor (*VIP*) considerando únicamente pedidos válidos (excluyendo aquellos con estado `'Cancelado'`).

### 2. Ventas Totales del Mes Actual
* **Técnica utilizada:** `DATE_TRUNC()`, `TO_CHAR()`, filtro de rango de fechas y `GROUP BY`.
* **Propósito:** Calcular el volumen de ventas e ingresos totales del mes en curso de forma dinámica mediante funciones de fecha de PostgreSQL.

### 3. Bottom 3: Productos Menos Vendidos
* **Técnica utilizada:** `LEFT JOIN`, `COALESCE()`, `SUM(dp.cantidad)` y extracción de atributos desde columnas `JSONB` (`->> 'marca'`).
* **Propósito:** Detectar productos con bajo rotado o sin ventas (0 unidades) para tomar decisiones de liquidación de stock o marketing.

### 4. Ranking de Productos por Categoría
* **Técnica utilizada:** CTEs (`WITH`), `LEFT JOIN` múltiple y Window Function `RANK() OVER (PARTITION BY ... ORDER BY ...)`
* **Propósito:** Clasificar los productos más vendidos de forma independiente dentro de cada categoría del catálogo.

---

## 🛢️ Requisitos Técnicos
* **Motor de Base de Datos:** PostgreSQL 12+ (compatible con pgAdmin 4)
* **Tipos de Datos Destacados:** `JSONB` para atributos dinámicos de productos, `TIMESTAMP` para trazabilidad de pedidos y `NUMERIC(10,2)` para precisión monetaria.
