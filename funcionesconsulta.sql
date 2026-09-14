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
 
    --  Calculamos el IVA (19%) solo sobre el valor de las pizzas
    SET v_iva = v_subtotal_pizzas * 0.19;
 
    --  Sumar todo para total final
    SET v_total = v_subtotal_pizzas + v_costo_envio + v_iva;
 
    RETURN v_total;
END// 
DELIMITER ;


select total_pedido(3);