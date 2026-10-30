-- =====================================================
-- MetaFit | 11_vistas_indices.sql
-- 7.1 VIEW | 7.2 INDEX
-- =====================================================
USE metafit;

-- ---------- 7.1 VIEW: ventas con usuario, miembro y metodo de pago ----------
CREATE OR REPLACE VIEW vista_ventas_detalle AS
SELECT v.id                                           AS venta_id,
       v.fecha_venta,
       u.nombre                                       AS registrado_por,
       COALESCE(CONCAT(m.nombre,' ',m.apellido),
                'Cliente ocasional')                  AS cliente,
       v.metodo_pago,
       v.referencia_pago,
       v.total
FROM ventas v
INNER JOIN usuarios u ON u.id = v.usuario_id
LEFT JOIN  miembros m ON m.id = v.miembro_id;

SELECT * FROM vista_ventas_detalle ORDER BY fecha_venta;
SELECT metodo_pago, SUM(total) AS total FROM vista_ventas_detalle GROUP BY metodo_pago;  -- la vista se consulta como tabla

-- ---------- 7.2 INDEX ----------
-- categoria se usa en WHERE y GROUP BY (catalogo, reportes) y aun no tenia indice
SHOW INDEX FROM productos;
EXPLAIN SELECT * FROM productos WHERE categoria = 'bebidas';   -- ANTES

CREATE INDEX idx_productos_categoria ON productos (categoria);

SHOW INDEX FROM productos;
EXPLAIN SELECT * FROM productos WHERE categoria = 'bebidas';   -- DESPUES (key = idx_productos_categoria)

-- metodo_pago se usa en filtros y reportes de ventas
CREATE INDEX idx_ventas_metodo_pago ON ventas (metodo_pago);
SHOW INDEX FROM ventas;
