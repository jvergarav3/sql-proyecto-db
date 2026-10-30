-- =====================================================
-- MetaFit | 08_select_basicos.sql
-- 4.1 WHERE | 4.2 Operaciones y alias | 4.3 ORDER BY/LIMIT | 4.4 Funciones
-- =====================================================
USE metafit;

-- ---------- 4.1 SELECT con WHERE ----------
SELECT * FROM productos WHERE categoria = 'suplementos' AND precio_venta > 90000;
SELECT id, nombre, apellido, email FROM miembros WHERE email IS NULL OR telefono IS NULL;
SELECT id, miembro_id, estado, fecha_fin FROM membresias WHERE estado = 'activa' AND fecha_fin BETWEEN '2026-10-30' AND '2026-12-31';
SELECT id, nombre FROM usuarios WHERE rol = 'trabajador' AND activo = TRUE;
SELECT id, nombre FROM productos WHERE nombre LIKE '%MetaFit%';

-- ---------- 4.2 Operaciones y alias: margen de ganancia ----------
SELECT nombre,
       precio_costo,
       precio_venta,
       (precio_venta - precio_costo)                              AS margen_unitario,
       ROUND((precio_venta - precio_costo) / precio_venta * 100,2) AS margen_porcentaje
FROM productos
ORDER BY margen_porcentaje DESC;

SELECT d.id, d.cantidad, d.precio_unitario,
       d.cantidad * d.precio_unitario AS subtotal_calculado,
       d.subtotal                     AS subtotal_almacenado
FROM detalle_ventas d
LIMIT 10;

-- ---------- 4.3 ORDER BY y LIMIT ----------
SELECT nombre, categoria, precio_venta FROM productos ORDER BY precio_venta DESC LIMIT 5;   -- 5 mas caros
SELECT nombre, categoria, precio_venta FROM productos ORDER BY precio_venta ASC  LIMIT 3;   -- 3 mas baratos

-- ---------- 4.4 Funciones integradas ----------
SELECT UPPER(nombre) AS producto_mayusculas, LOWER(categoria) AS categoria FROM productos LIMIT 5;

SELECT CONCAT(nombre, ' ', apellido) AS nombre_completo,
       LENGTH(CONCAT(nombre, ' ', apellido)) AS caracteres
FROM miembros;

SELECT nombre, ROUND(precio_venta / 1000, 1) AS precio_en_miles FROM productos;

SELECT m.id,
       CONCAT(mi.nombre, ' ', mi.apellido)            AS miembro,
       DATEDIFF(m.fecha_fin, m.fecha_inicio)          AS duracion_dias,
       DATEDIFF(m.fecha_fin, '2026-10-30')            AS dias_restantes
FROM membresias m
JOIN miembros mi ON mi.id = m.miembro_id
WHERE m.estado = 'activa';

SELECT id, DATE_FORMAT(fecha_venta, '%d/%m/%Y %H:%i') AS fecha, YEAR(fecha_venta) AS anio, MONTH(fecha_venta) AS mes
FROM ventas;
