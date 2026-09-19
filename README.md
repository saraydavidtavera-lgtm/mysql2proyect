# Pizzería Don Piccolo — Sistema de Gestión de Pedidos y Domicilios

## 1. Descripción del proyecto

Este proyecto implementa una base de datos relacional en **MySQL** para la
Pizzería Don Piccolo, con el objetivo de reemplazar el manejo manual de
pedidos por un sistema que permita controlar de forma centralizada:

- Registro de clientes y su historial de pedidos.
- Catálogo de pizzas y sus ingredientes.
- Control de stock de ingredientes.
- Registro de pedidos, su detalle (pizzas solicitadas) y su estado.
- Asignación de repartidores y seguimiento de domicilios.
- Registro de pagos.

Además de las tablas, el proyecto incluye **funciones**, **triggers** y
**vistas** que automatizan cálculos y consultas frecuentes del negocio
(total de un pedido, ganancia diaria, disponibilidad de repartidores,
reportes de desempeño, etc.).

---

## 2. Estructura de tablas y relaciones

El esquema se llama `mydb` y está compuesto por las siguientes tablas:

| Tabla | Descripción | Relación principal |
|---|---|---|
| `clientes` | Datos de cada cliente (nombre, teléfono, dirección, correo). | Un cliente puede tener muchos `pedidos`. |
| `pizzas` | Catálogo de pizzas (nombre, tamaño, precio base, tipo). | Se relaciona con `ingredientes` a través de `pizzas_ingredientes`, y con `pedidos` a través de `detalle_pedido`. |
| `ingredientes` | Insumos usados en las pizzas (stock, medida, costo). | Se relaciona con `pizzas` a través de `pizzas_ingredientes`. |
| `pizzas_ingredientes` | Tabla intermedia: qué ingredientes lleva cada pizza y en qué cantidad. | Une `pizzas` con `ingredientes` (relación muchos a muchos). |
| `metodopago` | Formas de pago disponibles (efectivo, tarjeta, app). | Un `pedido` usa un método de pago. |
| `estadopedido` | Estados posibles de un pedido (pendiente, en preparación, entregado, cancelado). | Un `pedido` tiene un estado. |
| `pedidos` | Encabezado del pedido: cliente, fecha/hora, método de pago, estado, total. | Se relaciona con `clientes`, `metodopago`, `estadopedido`, y es padre de `detalle_pedido`, `domicilios` y `pagos`. |
| `detalle_pedido` | Líneas del pedido: qué pizzas y cuántas unidades de cada una. | Une `pedidos` con `pizzas` (relación muchos a muchos). |
| `repartidores` | Personal de reparto (nombre, zona asignada, estado). | Un repartidor puede estar asignado a varios `domicilios`. |
| `domicilios` | Información de entrega de un pedido: hora de salida, hora de entrega, costo de envío. | Se relaciona con `pedidos` y con `repartidores`. |
| `pagos` | Registro de pagos asociados a un pedido. | Un pedido puede tener uno o más registros de pago. |

**Relaciones clave (llaves foráneas):**

```
clientes 1 ──< pedidos >── 1 metodopago
                 │
                 ├──< estadopedido (1)
                 │
                 ├──< detalle_pedido >── 1 pizzas >──< pizzas_ingredientes >── 1 ingredientes
                 │
                 ├──< domicilios >── 1 repartidores
                 │
                 └──< pagos
```

---

## 3. Objetos de base de datos incluidos

**Funciones**
- `calcular_total_pedido(p_pedido_id INT)` → suma pizzas + envío + IVA (19%).
- `calcular_ganancia_neta_diaria(p_fecha DATE)` → ventas del día − costo de ingredientes usados.

**Triggers**
- `trg_repartidor_disponible` → al registrarse la hora de entrega de un domicilio, el repartidor asociado vuelve a estado `'disponible'`.

**Vistas**
- `vista_desempeno_repartidores` → número de entregas, tiempo promedio de entrega y zona por repartidor.
- `vista_stock_bajo_minimo` → ingredientes con stock por debajo del mínimo permitido.

---

## 4. Ejemplos de consultas

**Total calculado de un pedido (usando la función):**
```sql
SELECT id, total_pedido AS total_guardado, calcular_total_pedido(id) AS total_calculado
FROM pedidos;
```

**Ganancia neta de un día específico:**
```sql
SELECT calcular_ganancia_neta_diaria('2025-06-01');
```

**Pizzas más vendidas (GROUP BY y COUNT):**
```sql
SELECT p.nombre AS pizza, COUNT(dp.id) AS veces_pedida
FROM detalle_pedido dp
INNER JOIN pizzas p ON dp.pizza_fk = p.id
GROUP BY p.id, p.nombre
ORDER BY veces_pedida DESC;
```

**Búsqueda parcial de pizza por nombre (LIKE):**
```sql
SELECT id, nombre, tamaño, precio_base, tipo
FROM pizzas
WHERE nombre LIKE '%queso%';
```

**Pedidos por repartidor (JOIN):**
```sql
SELECT r.nombre AS repartidor, p.id AS pedido_id, p.fecha_hora, p.total_pedido
FROM repartidores r
JOIN domicilios d ON d.repartidor_fk = r.id
JOIN pedidos p ON p.id = d.pedido_fk
ORDER BY r.nombre;
```

**Consultar las vistas:**
```sql
SELECT * FROM vista_desempeno_repartidores ORDER BY numero_entregas DESC;
SELECT * FROM vista_stock_bajo_minimo;
```

**Probar el trigger de repartidor disponible:**
```sql
UPDATE domicilios
SET hora_entrega = '2025-06-03 14:20:00'
WHERE id = 2;

SELECT id, nombre, estado FROM repartidores WHERE id = 2;
```

---

## 5. Instrucciones para ejecutar el script

1. **Abrir MySQL Workbench** y conectarte a tu servidor local.
2. **Crear el esquema y las tablas**: ejecuta primero el script de creación de tablas (`CREATE SCHEMA`, `CREATE TABLE`, llaves foráneas). Este script debe correrse **una sola vez**, ya que contiene `DROP SCHEMA IF EXISTS` y `DROP TABLE IF EXISTS`, por lo que si lo vuelves a correr, se borran y recrean las tablas (perdiendo los datos).
3. **Insertar los datos de prueba**: abre `inserts_don_piccolo.sql`, pégalo en una pestaña nueva con el esquema `mydb` activo, y ejecútalo completo (⚡ con subrayado / `Ctrl+Shift+Enter`). Respeta el orden del archivo, ya que las tablas tienen llaves foráneas entre sí.
4. **Crear las funciones**: ejecuta `funcion_calcular_total_pedido.sql` y `funcion_ganancia_neta_diaria.sql`. Cada una debe pegarse completa, incluyendo las líneas `DELIMITER`, para que MySQL no confunda los `;` internos del `BEGIN...END` con el final de la sentencia.
5. **Crear las vistas**: ejecuta los `CREATE OR REPLACE VIEW` de `vista_desempeno_repartidores` y `vista_stock_bajo_minimo`.
6. **Crear los triggers**: ejecuta `trigger_repartidor_disponible.sql` (y los demás triggers que se vayan agregando), también completos con sus `DELIMITER`.
7. **Verificar que todo quedó creado**: en el panel izquierdo (Navigator), dentro de `mydb`, revisa las carpetas `Tables`, `Functions`, `Views` y `Triggers` (haz clic derecho sobre el esquema → `Refresh All` si no aparecen de inmediato).
8. **Probar con las consultas de ejemplo** de la sección 4 de este README para confirmar que funciones, vistas y triggers responden correctamente.

**Orden recomendado de ejecución:**
```
1. Script de tablas (DDL)
2. inserts_don_piccolo.sql
3. funcion_calcular_total_pedido.sql
4. funcion_ganancia_neta_diaria.sql
5. Vistas (vista_desempeno_repartidores, vista_stock_bajo_minimo)
6. trigger_repartidor_disponible.sql
```

