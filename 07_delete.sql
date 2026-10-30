-- =====================================================
-- MetaFit | 07_delete.sql
-- 3.3 DELETE respetando claves foraneas
-- Se elimina la venta 8 (registrada por error). Orden:
--   movimientos_inventario -> detalle_ventas -> ventas
-- (primero los hijos, luego el padre)
-- =====================================================
USE metafit;

-- ANTES
SELECT * FROM ventas                  WHERE id = 8;
SELECT * FROM detalle_ventas          WHERE venta_id = 8;
SELECT * FROM movimientos_inventario  WHERE venta_id = 8;

-- Intento en orden incorrecto (falla por la FK): descomentar para evidenciar el error
-- DELETE FROM ventas WHERE id = 8;

-- SCRIPT
DELETE FROM movimientos_inventario WHERE venta_id = 8;
DELETE FROM detalle_ventas         WHERE venta_id = 8;
DELETE FROM ventas                 WHERE id = 8;

-- DESPUES
SELECT * FROM ventas                  WHERE id = 8;
SELECT * FROM detalle_ventas          WHERE venta_id = 8;
SELECT * FROM movimientos_inventario  WHERE venta_id = 8;
SELECT COUNT(*) AS ventas_restantes FROM ventas;
