-- =====================================================
-- INSERTs de datos - Pizzería Don Piccolo
-- Base de datos: mydb
-- =====================================================

USE `mydb`;

-- -----------------------------------------------------
-- Tabla `clientes`
-- (id 1-5, AUTO_INCREMENT siguiente = 6)
-- Incluye a "Juan Pérez" con varios pedidos en el mes
-- para poder probar la regla de "cliente frecuente".
-- -----------------------------------------------------
INSERT INTO `mydb`.`clientes` (`id`, `nombre`, `telefono`, `direccion`, `correo`, `fecha_registro`) VALUES
(1, 'Juan Pérez',        '3001234567', 'Calle 10 #5-20',       'juan.perez@gmail.com',      '2025-01-15 10:30:00'),
(2, 'María Gómez',       '3007654321', 'Av. Siempre Viva 123', 'maria.gomez@hotmail.com',   '2025-02-10 14:00:00'),
(3, 'Carlos Rodríguez',  '3012345678', 'Cra 45 #12-34',        'carlos.rodriguez@yahoo.com','2025-03-05 09:15:00'),
(4, 'Ana Torres',        '3019876543', 'Calle 80 #22-10',      'ana.torres@gmail.com',      '2025-04-20 18:45:00'),
(5, 'Luis Martínez',     '3023456789', 'Cra 15 #8-90',         'luis.martinez@outlook.com', '2025-05-01 12:00:00');

-- -----------------------------------------------------
-- Tabla `estadopedido`
-- (id 1-4, AUTO_INCREMENT siguiente = 5)
-- -----------------------------------------------------
INSERT INTO `mydb`.`estadopedido` (`id`, `nombre`, `estadopedidocol`) VALUES
(1, 'Pendiente',       'PENDIENTE'),
(2, 'En preparación',  'EN_PREPARACION'),
(3, 'Entregado',       'ENTREGADO'),
(4, 'Cancelado',       'CANCELADO');

-- -----------------------------------------------------
-- Tabla `metodopago`
-- (id 1-3, AUTO_INCREMENT siguiente = 4)
-- -----------------------------------------------------
INSERT INTO `mydb`.`metodopago` (`id`, `nombre`) VALUES
(1, 'Efectivo'),
(2, 'Tarjeta'),
(3, 'App');

-- -----------------------------------------------------
-- Tabla `pizzas`
-- (id 1-5, AUTO_INCREMENT siguiente = 6)
-- -----------------------------------------------------
INSERT INTO `mydb`.`pizzas` (`id`, `nombre`, `tamaño`, `precio_base`, `tipo`) VALUES
(1, 'Margarita',           'mediana',  18000, 'clasica'),
(2, 'Hawaiana',             'grande',   25000, 'especial'),
(3, 'Vegetariana Deluxe',   'grande',   27000, 'vegetariana'),
(4, 'Pepperoni',            'familiar', 32000, 'clasica'),
(5, 'Cuatro Quesos',        'mediana',  22000, 'especial');

-- -----------------------------------------------------
-- Tabla `ingredientes`
-- (id 1-7, AUTO_INCREMENT siguiente = 8)
-- `stock` y `cantidad` (en pizzas_ingredientes) son DECIMAL
-- sin precisión/escala definida -> equivalen a DECIMAL(10,0),
-- por lo tanto se usan valores enteros.
-- -----------------------------------------------------
INSERT INTO `mydb`.`ingredientes` (`id`, `nombre`, `stock`, `medida`, `estado`, `costo_unidad`) VALUES
(1, 'Queso mozzarella',   50, 'kg',      'disponible', 8000),
(2, 'Salsa de tomate',    30, 'litros',  'disponible', 4000),
(3, 'Pepperoni',          20, 'kg',      'disponible', 15000),
(4, 'Piña',               15, 'kg',      'disponible', 3000),
(5, 'Jamón',              18, 'kg',      'disponible', 12000),
(6, 'Champiñones',        10, 'kg',      'disponible', 6000),
(7, 'Aceitunas',           5, 'kg',      'agotado',    9000);

-- -----------------------------------------------------
-- Tabla `pizzas_ingredientes`
-- (id 1-21, AUTO_INCREMENT siguiente = 22)
-- Relaciona cada pizza con los ingredientes que la componen.
-- -----------------------------------------------------
INSERT INTO `mydb`.`pizzas_ingredientes` (`id`, `ingredientes_fk`, `cantidad`, `pizza_fk`) VALUES
(1,  1, 2, 1),  -- Margarita: queso
(2,  2, 1, 1),  -- Margarita: salsa
(3,  1, 2, 2),  -- Hawaiana: queso
(4,  2, 1, 2),  -- Hawaiana: salsa
(5,  4, 1, 2),  -- Hawaiana: piña
(6,  5, 1, 2),  -- Hawaiana: jamón
(7,  1, 2, 3),  -- Vegetariana Deluxe: queso
(8,  2, 1, 3),  -- Vegetariana Deluxe: salsa
(9,  6, 1, 3),  -- Vegetariana Deluxe: champiñones
(10, 7, 1, 3),  -- Vegetariana Deluxe: aceitunas
(11, 1, 2, 4),  -- Pepperoni: queso
(12, 2, 1, 4),  -- Pepperoni: salsa
(13, 3, 1, 4),  -- Pepperoni: pepperoni
(14, 1, 3, 5),  -- Cuatro Quesos: queso
(15, 2, 1, 5),  -- Cuatro Quesos: salsa
(16, 5, 1, 5),  -- Cuatro Quesos: jamón
(17, 6, 1, 5),  -- Cuatro Quesos: champiñones
(18, 3, 1, 1),  -- Margarita: pepperoni extra
(19, 4, 1, 4),  -- Pepperoni: piña extra
(20, 6, 1, 2),  -- Hawaiana: champiñones extra
(21, 3, 1, 3);  -- Vegetariana Deluxe: pepperoni extra

-- -----------------------------------------------------
-- Tabla `repartidores`
-- (id 1-4, AUTO_INCREMENT siguiente = 5)
-- -----------------------------------------------------
INSERT INTO `mydb`.`repartidores` (`id`, `nombre`, `zonaasignada`, `estado`) VALUES
(1, 'Pedro Sánchez',   'Zona Norte',      'disponible'),
(2, 'Andrés López',    'Zona Sur',        'ocupado'),
(3, 'Diana Ramírez',   'Zona Centro',     'disponible'),
(4, 'Jorge Castillo',  'Zona Occidente',  'disponible');

-- -----------------------------------------------------
-- Tabla `pedidos`
-- (id 1-11, AUTO_INCREMENT siguiente = 12)
-- Cliente 1 (Juan Pérez) concentra varios pedidos en junio
-- para poder validar la consulta de "clientes frecuentes".
-- -----------------------------------------------------
INSERT INTO `mydb`.`pedidos` (`id`, `fecha_hora`, `cliente_fk`, `metodo_pago_fk`, `estado_pedido_fk`, `total_pedido`) VALUES
(1,  '2025-06-01 12:30:00', 1, 1, 3, 43000),
(2,  '2025-06-03 13:00:00', 1, 2, 3, 52000),
(3,  '2025-06-05 19:20:00', 1, 3, 3, 27000),
(4,  '2025-06-08 20:10:00', 1, 1, 3, 61000),
(5,  '2025-06-10 11:00:00', 1, 2, 2, 32000),
(6,  '2025-06-12 14:45:00', 1, 3, 1, 22000),
(7,  '2025-06-02 18:30:00', 2, 1, 3, 43000),
(8,  '2025-06-04 20:00:00', 3, 2, 3, 75000),
(9,  '2025-06-06 12:15:00', 4, 3, 4, 25000),
(10, '2025-06-09 19:40:00', 5, 1, 3, 54000),
(11, '2025-06-11 21:00:00', 2, 2, 3, 40000);

-- -----------------------------------------------------
-- Tabla `detalle_pedido`
-- (id 1-14, AUTO_INCREMENT siguiente = 15)
-- -----------------------------------------------------
INSERT INTO `mydb`.`detalle_pedido` (`id`, `pedido_fk`, `pizza_fk`, `cantidad`, `precio_unitario`, `subtotal`) VALUES
(1,  1,  1, 2, 18000, 36000),
(2,  2,  2, 1, 25000, 25000),
(3,  2,  1, 1, 18000, 18000),
(4,  3,  3, 1, 27000, 27000),
(5,  4,  4, 1, 32000, 32000),
(6,  4,  1, 1, 18000, 18000),
(7,  5,  5, 1, 22000, 22000),
(8,  6,  1, 1, 18000, 18000),
(9,  7,  2, 1, 25000, 25000),
(10, 8,  4, 2, 32000, 64000),
(11, 9,  3, 1, 27000, 27000),
(12, 10, 2, 1, 25000, 25000),
(13, 10, 5, 1, 22000, 22000),
(14, 11, 1, 1, 18000, 18000);

-- -----------------------------------------------------
-- Tabla `domicilios`
-- (id 1-6, AUTO_INCREMENT siguiente = 7)
-- Solo los pedidos ya entregados/en domicilio tienen registro.
-- -----------------------------------------------------
INSERT INTO `mydb`.`domicilios` (`id`, `hora_salida`, `hora_entrega`, `pedido_fk`, `repartidor_fk`, `costo_envio`) VALUES
(1, '2025-06-01 12:45:00', '2025-06-01 13:15:00', 1,  1, 5000),
(2, '2025-06-03 13:15:00', '2025-06-03 13:50:00', 2,  2, 6000),
(3, '2025-06-08 20:20:00', '2025-06-08 20:55:00', 4,  3, 5500),
(4, '2025-06-02 18:40:00', '2025-06-02 19:10:00', 7,  1, 4500),
(5, '2025-06-04 20:10:00', '2025-06-04 20:50:00', 8,  4, 7000),
(6, '2025-06-09 19:50:00', '2025-06-09 20:25:00', 10, 2, 6500);

-- -----------------------------------------------------
-- Tabla `pagos`
-- (id 1-11, AUTO_INCREMENT siguiente = 12)
-- Un pago por pedido; refleja pendientes/confirmados/rechazados.
-- -----------------------------------------------------
INSERT INTO `mydb`.`pagos` (`id`, `pedido_fk`, `monto`, `fecha_pago`, `estado_pago`) VALUES
(1,  1,  43000, '2025-06-01 12:35:00', 'confirmado'),
(2,  2,  52000, '2025-06-03 13:05:00', 'confirmado'),
(3,  3,  27000, '2025-06-05 19:25:00', 'confirmado'),
(4,  4,  61000, '2025-06-08 20:15:00', 'confirmado'),
(5,  5,  32000, '2025-06-10 11:05:00', 'pendiente'),
(6,  6,  22000, '2025-06-12 14:50:00', 'pendiente'),
(7,  7,  43000, '2025-06-02 18:35:00', 'confirmado'),
(8,  8,  75000, '2025-06-04 20:05:00', 'confirmado'),
(9,  9,  25000, '2025-06-06 12:20:00', 'rechazado'),
(10, 10, 54000, '2025-06-09 19:45:00', 'confirmado'),
(11, 11, 40000, '2025-06-11 21:05:00', 'confirmado');