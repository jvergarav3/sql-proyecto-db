-- =====================================================
-- MetaFit | 06_update.sql
-- 3.2 UPDATE (3 actualizaciones con WHERE distintos)
-- =====================================================
USE metafit;
SET SQL_SAFE_UPDATES = 0;

-- 1) WHERE por categoria: ajuste de 5% a los suplementos
SELECT id, nombre, precio_venta FROM productos WHERE categoria = 'suplementos';
UPDATE productos
   SET precio_venta = ROUND(precio_venta * 1.05, 0)
 WHERE categoria = 'suplementos';
SELECT id, nombre, precio_venta FROM productos WHERE categoria = 'suplementos';

-- 2) WHERE compuesto (estado + fecha): marcar como vencidas las membresias activas ya expiradas
SELECT id, miembro_id, fecha_fin, estado FROM membresias
 WHERE estado = 'activa' AND fecha_fin < '2026-10-30';
UPDATE membresias
   SET estado = 'vencida'
 WHERE estado = 'activa' AND fecha_fin < '2026-10-30';
SELECT id, miembro_id, fecha_fin, estado FROM membresias ORDER BY id;

-- 3) WHERE con IN: subir el stock minimo de las bebidas (ids 4, 5, 6)
SELECT producto_id, stock_actual, stock_minimo FROM inventario WHERE producto_id IN (4,5,6);
UPDATE inventario
   SET stock_minimo = stock_minimo + 5
 WHERE producto_id IN (4,5,6);
SELECT producto_id, stock_actual, stock_minimo FROM inventario WHERE producto_id IN (4,5,6);

SET SQL_SAFE_UPDATES = 1;
