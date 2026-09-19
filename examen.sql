--Consulta de entregas realizadas por cada repartidor

use don_piccolo;
select * from domicilios;
select * from repartidores;
select * from pedidos;
SELECT r.nombre AS nombre_repartidor, COUNT(d.id_domicilio) AS cantidad_entregas,
SUM(p.total) AS total_acum
FROM repartidores r 
JOIN domicilios d ON r.id_repartidor=d.id_repartidor
JOIN pedidos p ON d.id_pedido=p.id_cliente
WHERE d.estado='entregado'
GROUP BY r.id_repartidor, r.nombre;


--Consulta de pedidos demorados

use don_piccolo;
select * from domicilios;
select * from repartidores;
select * from pedidos;
SELECT d.id_domicilio, d.id_pedido, r.nombre AS repartidor,
d.hora_salida, d.hora_entrega, TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega) AS tiempo_total
FROM domicilios d
JOIN repartidores r ON d.id_repartidor = r.id_repartidor
WHERE TIMESTAMPDIFF(MINUTE, d.hora_salida, d.hora_entrega) > 40;

-- Consulta de repartidores disponibles sin entregas

SELECT r.id_repartidor, r.nombre, r.zona_asignada, r.estado
FROM repartidores r
LEFT JOIN domicilios d ON r.id_repartidor=d.id_repartidor
WHERE r.estado ='disponible'
AND d.id_domicilio IS NULL;

--Vista resumen de desempeño
use don_piccolo;
select * from domicilios;
select * from repartidores;
select * from pedidos;
UPDATE domicilios SET estado='entregado' WHERE id_domicilio in (1,5,9,10,13,16,20,22,21,28,29);
CREATE VIEW gestion_repartidor AS
SELECT r.nombre AS nombre_repartidor, 
COUNT(d.id_domicilio) AS entregas_acum, 
AVG(TIMESTAMPDIFF(MINUTE,d.hora_salida, d.hora_entrega)) AS promedio_time
FROM repartidores r
LEFT JOIN domicilios d ON r.id_repartidor= d.id_repartidor AND d.estado ='entregado'
group by r.id_repartidor, r.nombre;
