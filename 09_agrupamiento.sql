-- =====================================================
-- MetaFit | 09_agrupamiento.sql
-- 5.1 Agregaciones | 5.2 GROUP BY | 5.3 HAVING
-- =====================================================
USE metafit;

-- ---------- 5.1 Funciones de agregacion ----------
SELECT COUNT(*)            AS total_ventas,
       SUM(total)          AS ingresos_totales,
       ROUND(AVG(total),2) AS ticket_promedio,
       MAX(total)          AS venta_mayor,
       MIN(total)          AS venta_menor
FROM ventas;

SELECT COUNT(*) AS total_miembros, COUNT(email) AS con_email FROM miembros;  -- COUNT(col) ignora NULL
SELECT ROUND(AVG(precio_venta),2) AS precio_promedio, MAX(precio_venta) AS mas_caro, MIN(precio_venta) AS mas_barato FROM productos;

-- ---------- 5.2 GROUP BY (consultas separadas) ----------
-- Ventas por metodo de pago
SELECT metodo_pago, COUNT(*) AS num_ventas, SUM(total) AS total_recaudado, ROUND(AVG(total),2) AS promedio
FROM ventas
GROUP BY metodo_pago;

-- Productos por categoria
SELECT categoria, COUNT(*) AS num_productos, ROUND(AVG(precio_venta),2) AS precio_promedio,
       MAX(precio_venta) AS mas_caro, MIN(precio_venta) AS mas_barato
FROM productos
GROUP BY categoria;

-- ---------- 5.3 HAVING ----------
-- Metodos de pago que superan 100.000 recaudados
SELECT metodo_pago, SUM(total) AS total_recaudado
FROM ventas
GROUP BY metodo_pago
HAVING SUM(total) > 100000;

-- Categorias con 3 o mas productos
SELECT categoria, COUNT(*) AS num_productos
FROM productos
GROUP BY categoria
HAVING COUNT(*) >= 3;

-- Categorias con precio promedio mayor a 30.000
SELECT categoria, ROUND(AVG(precio_venta),2) AS precio_promedio
FROM productos
GROUP BY categoria
HAVING AVG(precio_venta) > 30000
ORDER BY precio_promedio DESC;
