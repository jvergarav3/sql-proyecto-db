-- =====================================================
-- MetaFit | 10_joins_subconsultas.sql
-- 6.1 INNER JOIN | 6.2 LEFT / RIGHT JOIN | 6.3 Subconsultas
-- =====================================================
USE metafit;

-- ---------- 6.1 INNER JOIN: ventas con el usuario que las registro ----------
SELECT v.id AS venta, v.fecha_venta, v.total, v.metodo_pago, u.nombre AS registrado_por, u.rol
FROM ventas v
INNER JOIN usuarios u ON u.id = v.usuario_id
ORDER BY v.fecha_venta;

-- INNER JOIN multiple: detalle de lo vendido
SELECT v.id AS venta, p.nombre AS producto, d.cantidad, d.precio_unitario, d.subtotal
FROM detalle_ventas d
INNER JOIN ventas v    ON v.id = d.venta_id
INNER JOIN productos p ON p.id = d.producto_id
ORDER BY v.id;

-- ---------- 6.2 LEFT JOIN / RIGHT JOIN ----------
-- Todos los productos, con o sin inventario
SELECT p.id, p.nombre, i.stock_actual, i.stock_minimo
FROM productos p
LEFT JOIN inventario i ON i.producto_id = p.id;

-- Solo productos SIN inventario
SELECT p.id, p.nombre
FROM productos p
LEFT JOIN inventario i ON i.producto_id = p.id
WHERE i.id IS NULL;

-- RIGHT JOIN equivalente: todos los productos a la derecha
SELECT i.id AS inventario_id, p.nombre, i.stock_actual
FROM inventario i
RIGHT JOIN productos p ON p.id = i.producto_id;

-- Miembros con y sin membresias
SELECT CONCAT(m.nombre,' ',m.apellido) AS miembro, ms.id AS membresia, ms.estado, ms.fecha_fin
FROM miembros m
LEFT JOIN membresias ms ON ms.miembro_id = m.id
ORDER BY m.id;

-- Solo miembros SIN membresias
SELECT CONCAT(m.nombre,' ',m.apellido) AS miembro_sin_membresia
FROM miembros m
LEFT JOIN membresias ms ON ms.miembro_id = m.id
WHERE ms.id IS NULL;

-- ---------- 6.3 Subconsultas ----------
-- Productos con precio superior al promedio
SELECT nombre, precio_venta
FROM productos
WHERE precio_venta > (SELECT AVG(precio_venta) FROM productos)
ORDER BY precio_venta DESC;

-- Productos que se han vendido al menos una vez
SELECT id, nombre FROM productos
WHERE id IN (SELECT DISTINCT producto_id FROM detalle_ventas WHERE producto_id IS NOT NULL);

-- Productos que nunca se han vendido
SELECT id, nombre FROM productos
WHERE id NOT IN (SELECT producto_id FROM detalle_ventas WHERE producto_id IS NOT NULL);

-- Ventas con total mayor al promedio de ventas
SELECT id, total FROM ventas WHERE total > (SELECT AVG(total) FROM ventas);
