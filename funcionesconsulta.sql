-- Función para calcular el total de un pedido
use mydb;
select * from ingredientes;
select * from domicilios;
select * from detalle_pedido;
DELIMITER //
 
CREATE FUNCTION `total_pedido` (p_pedido_id INT)
RETURNS DOUBLE
READS SQL DATA
DETERMINISTIC
BEGIN
    -- Variables pa todo lo que se usará en la función
    DECLARE v_subtotal_pizzas DOUBLE;
    DECLARE v_costo_envio DOUBLE;
    DECLARE v_iva DOUBLE;
    DECLARE v_total DOUBLE;
 
    -- ¡PARA RECORDAR!  este será el subtotal de todas las pizzas de ese pedido
    SELECT SUM(subtotal)
    INTO v_subtotal_pizzas
    FROM detalle_pedido
    WHERE pedido_fk = p_pedido_id;
 
    -- EL return si esta vacio o en ese caso sin pedidos de pizzas y el 0 no varía nuestra suma 
    IF v_subtotal_pizzas IS NULL THEN
        SET v_subtotal_pizzas = 0;
    END IF;
 
    
    SET v_costo_envio = (
        SELECT costo_envio
        FROM domicilios
        WHERE pedido_fk = p_pedido_id
        LIMIT 1
    );
 
    IF v_costo_envio IS NULL THEN
        SET v_costo_envio = 0;
    END IF;
 
    --  Calculamos el IVA (19%) SOLO sobre el valor de las pizzas, NO con costo envio.
    SET v_iva = v_subtotal_pizzas * 0.19;
 
    --  Sumar todo para total final
    SET v_total = v_subtotal_pizzas + v_costo_envio + v_iva;
 
    RETURN v_total;
END// 
DELIMITER ;


select total_pedido(3);

-- Función para calcular la ganancia neta diaria


use mydb;
select * from pedidos;
select * from detalle_pedido;
select * from ingredientes;
DELIMITER $$
 
CREATE FUNCTION `ganancia_diaria` (p_fecha DATE)
RETURNS DOUBLE
READS SQL DATA
DETERMINISTIC
BEGIN

    DECLARE v_ventas DOUBLE;
    DECLARE v_costos DOUBLE;
    DECLARE v_ganancia DOUBLE;
 
    -- el total de todos los
    -- pedidos cuya fecha coincide con la fecha recibida
    SELECT SUM(total_pedido)
    INTO v_ventas
    FROM pedidos
    WHERE DATE(fecha_hora) = p_fecha;
 

    IF v_ventas IS NULL THEN
        SET v_ventas = 0;
    END IF;
 
    -- Sumar el costo de los ingredientes usados ese día.
    -- Se recorren las pizzas vendidas (detalle_pedido), se
    -- buscan sus ingredientes (pizzas_ingredientes) y el
    -- costo de cada ingrediente (ingredientes) para establecerlos en variable costos y hacer la resta con varbiale ventas
    SELECT SUM(dp.cantidad * pi.cantidad * i.costo_unidad)
    INTO v_costos
    FROM detalle_pedido dp
    INNER JOIN pedidos p
        ON dp.pedido_fk = p.id
    INNER JOIN pizzas_ingredientes pi
        ON pi.pizza_fk = dp.pizza_fk
    INNER JOIN ingredientes i
        ON i.id = pi.ingredientes_fk
    WHERE DATE(p.fecha_hora) = p_fecha;
 

    IF v_costos IS NULL THEN
        SET v_costos = 0;
    END IF;
 
    -- ganancia neta
    SET v_ganancia = v_ventas - v_costos;
 
    RETURN v_ganancia;
END$$
 
DELIMITER ;

DROP FUNCTION ganancia_diaria;
select ganancia_diaria('2025-06-11');

-- CONSULTA SQL DE PIZZAS MÁS PEDIDAS

use mydb;
select * from detalle_pedido;
select * from pedidos;
select * from pizzas;
SELECT p.nombre AS pizza,
       COUNT(dp.id) AS veces_pedida
FROM detalle_pedido dp
INNER JOIN pizzas p
    ON dp.pizza_fk = p.id
GROUP BY p.id, p.nombre
ORDER BY veces_pedida DESC;

-- CONSULTA DE PALABRAS CON LIKE 
use mydb;

select * from pizzas;
SELECT id, nombre, tamaño, precio_base, tipo
FROM pizzas
WHERE nombre LIKE '%hawaiana%';

-- VISTA DE STOCK MINIMO 

use mydb;
CREATE OR REPLACE VIEW vista_stock_bajo_minimo AS
SELECT id, nombre, stock, medida, estado
FROM ingredientes
WHERE stock < 15;

-- CONSULTA DE PEDIDOS HECHOS POR REPARTIDORES 

use mydb;
select * from repartidores;
select * from pedidos;
select * from domicilios;
SELECT r.nombre AS repartidor,
       p.id AS pedido_id,
       p.fecha_hora,
       p.total_pedido
FROM repartidores r
JOIN domicilios d
    ON d.repartidor_fk = r.id
JOIN pedidos p
    ON p.id = d.pedido_fk
ORDER BY r.nombre;

-- DISPARADOR DE CAMBIO ESTADO REPARTUDORES 
 use mydb;
select * from repartidores;
select * from pedidos;
select * from domicilios;

DELIMITER //
 
CREATE TRIGGER repartidor_disponible
AFTER UPDATE ON domicilios
FOR EACH ROW
BEGIN
    DECLARE v_estado_actual VARCHAR(20);
 
    SELECT estado INTO v_estado_actual
    FROM repartidores
    WHERE id = NEW.repartidor_fk;
 
    IF NEW.hora_entrega <> OLD.hora_entrega AND v_estado_actual = 'ocupado' THEN
        UPDATE repartidores
        SET estado = 'disponible'
        WHERE id = NEW.repartidor_fk;
    END IF;
END//
 
DELIMITER ;

SELECT id, nombre, estado FROM repartidores WHERE id = 2; 
-- Debe aparece ocupado y así aparece, abajo le corremos una hora más tarde de las 2om a las 3pm ccon 20min
UPDATE domicilios SET hora_entrega = '2025-06-03 15:20:00' WHERE id = 2;
-- Al cambiarlo a una hora más tarde se cumple el disparador al cambiarlo a Disponible
SELECT id, nombre, estado FROM repartidores WHERE id = 2; 