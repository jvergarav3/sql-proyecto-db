-- =====================================================
-- MetaFit | 05_insert.sql
-- 3.1 INSERT (>= 5 registros en varias tablas)
-- Nota: ventas.total se inserta en 0 y lo recalcula el
-- trigger al insertar detalle_ventas.
-- =====================================================
USE metafit;
SET NAMES utf8mb4;

INSERT INTO usuarios (id, nombre, email, password_hash, rol, activo, fecha_creacion) VALUES
(1,'Carlos Mendoza','carlos@metafit.com','$2b$12$hash_admin_demo','administrador',TRUE,'2026-01-05 08:00:00'),
(2,'Laura Pérez','laura@metafit.com','$2b$12$hash_laura_demo','trabajador',TRUE,'2026-01-10 08:30:00'),
(3,'Andrés Gómez','andres@metafit.com','$2b$12$hash_andres_demo','trabajador',TRUE,'2026-02-01 09:00:00'),
(4,'Marta Ruiz','marta@metafit.com','$2b$12$hash_marta_demo','auditor',TRUE,'2026-03-15 10:00:00'),
(5,'Julián Torres','julian@metafit.com','$2b$12$hash_julian_demo','trabajador',FALSE,'2026-04-01 09:00:00');

INSERT INTO tipos_membresia (id, nombre, precio, duracion_dias) VALUES
(1,'Diaria',10000,1),
(2,'Semanal',35000,7),
(3,'Mensual',90000,30),
(4,'Trimestral',240000,90),
(5,'Anual',800000,365);

INSERT INTO miembros (id, nombre, apellido, email, telefono, fecha_nacimiento, fecha_registro) VALUES
(1,'Valentina','Rojas','valentina.rojas@mail.com','3001112233','1995-04-12','2026-01-15'),
(2,'Santiago','Herrera','santiago.h@mail.com','3002223344','1990-09-30','2026-02-01'),
(3,'Camila','Díaz','camila.diaz@mail.com','3003334455','1998-01-22','2026-03-10'),
(4,'Mateo','Vargas','mateo.vargas@mail.com','3004445566','1988-07-05','2026-03-15'),
(5,'Isabella','Castro',NULL,'3005556677','2001-11-18','2026-10-25'),
(6,'Sebastián','Moreno','sebas.moreno@mail.com',NULL,'1993-06-09','2026-05-02'),
(7,'Daniela','Ortega','dani.ortega@mail.com','3007778899',NULL,'2026-06-20'),
(8,'Felipe','Navarro','felipe.n@mail.com','3008889900','1997-12-03','2026-10-28');

-- Los miembros 3 y 6 se dejan 'activa' aunque ya vencieron (se corrige con UPDATE en 06)
INSERT INTO membresias (id, miembro_id, tipo_membresia_id, fecha_inicio, fecha_fin, estado) VALUES
(1,1,3,'2026-10-01','2026-10-31','activa'),
(2,2,4,'2026-08-01','2026-10-30','activa'),
(3,3,3,'2026-09-01','2026-10-01','activa'),
(4,4,5,'2026-03-15','2027-03-15','activa'),
(5,5,2,'2026-10-25','2026-11-01','activa'),
(6,6,3,'2026-08-10','2026-09-09','activa'),
(7,7,3,'2026-09-20','2026-10-20','cancelada'),
(8,1,3,'2026-09-01','2026-10-01','vencida');
-- El miembro 8 queda sin membresia a proposito (LEFT JOIN en 10)

INSERT INTO productos (id, nombre, descripcion, categoria, precio_venta, precio_costo) VALUES
(1,'Proteína Whey 1kg','Proteína de suero sabor vainilla','suplementos',120000,85000),
(2,'Creatina 300g','Creatina monohidratada','suplementos',80000,52000),
(3,'Pre-entreno 250g','Energía y enfoque','suplementos',95000,60000),
(4,'Agua 600ml','Agua mineral','bebidas',3000,1500),
(5,'Bebida isotónica','Reposición de electrolitos','bebidas',6000,3500),
(6,'Batido proteico','Batido listo para tomar','bebidas',12000,7000),
(7,'Camiseta MetaFit','Camiseta deportiva dry-fit','ropa',45000,25000),
(8,'Gorra MetaFit','Gorra con logo','ropa',30000,15000),
(9,'Guantes de gimnasio','Guantes antideslizantes','accesorios',35000,18000),
(10,'Shaker 700ml','Vaso mezclador','accesorios',25000,12000),
(11,'Cinturón lumbar','Soporte para levantamiento','accesorios',70000,40000);
-- El producto 11 queda sin inventario a proposito (LEFT JOIN en 10)

INSERT INTO inventario (producto_id, stock_actual, stock_minimo) VALUES
(1,18,5),(2,14,5),(3,4,5),(4,120,30),(5,60,20),
(6,30,10),(7,15,5),(8,20,5),(9,8,3),(10,25,8);

INSERT INTO ventas (id, miembro_id, fecha_venta, total, metodo_pago, referencia_pago, usuario_id) VALUES
(1,1,'2026-10-01 08:30:00',0,'tarjeta','TRX-1001',2),
(2,5,'2026-10-25 17:10:00',0,'efectivo',NULL,3),
(3,NULL,'2026-10-26 12:45:00',0,'efectivo',NULL,2),
(4,2,'2026-10-27 19:00:00',0,'transferencia','TRF-2044',3),
(5,4,'2026-10-28 10:20:00',0,'tarjeta','TRX-1010',2),
(6,NULL,'2026-10-29 15:30:00',0,'efectivo',NULL,3),
(7,6,'2026-10-29 18:05:00',0,'tarjeta','TRX-1015',2),
(8,3,'2026-10-30 09:10:00',0,'efectivo',NULL,3);

INSERT INTO detalle_ventas (venta_id, producto_id, cantidad, precio_unitario, tipo_venta) VALUES
(1,NULL,1,90000,'membresia'),(1,4,2,3000,'productos'),
(2,NULL,1,35000,'membresia'),(2,6,1,12000,'productos'),
(3,4,3,3000,'productos'),(3,5,2,6000,'productos'),
(4,1,1,120000,'productos'),(4,2,1,80000,'productos'),
(5,7,2,45000,'productos'),(5,8,1,30000,'productos'),
(6,10,1,25000,'productos'),(6,4,1,3000,'productos'),
(7,3,1,95000,'productos'),(7,9,1,35000,'productos'),
(8,5,1,6000,'productos');

-- inventario_id coincide con producto_id (se insertaron en orden 1..10)
INSERT INTO movimientos_inventario (inventario_id, tipo_movimiento, cantidad, fecha, motivo, venta_id) VALUES
(1,'entrada',20,'2026-09-28 10:00:00','compra_proveedor',NULL),
(3,'entrada',10,'2026-09-28 10:05:00','compra_proveedor',NULL),
(4,'entrada',100,'2026-09-28 10:10:00','compra_proveedor',NULL),
(4,'salida',2,'2026-10-15 16:00:00','merma',NULL),
(2,'ajuste',1,'2026-10-20 18:00:00','conteo_fisico',NULL),
(4,'salida',2,'2026-10-01 08:30:00','venta',1),
(6,'salida',1,'2026-10-25 17:10:00','venta',2),
(4,'salida',3,'2026-10-26 12:45:00','venta',3),
(5,'salida',2,'2026-10-26 12:45:00','venta',3),
(1,'salida',1,'2026-10-27 19:00:00','venta',4),
(2,'salida',1,'2026-10-27 19:00:00','venta',4),
(7,'salida',2,'2026-10-28 10:20:00','venta',5),
(8,'salida',1,'2026-10-28 10:20:00','venta',5),
(10,'salida',1,'2026-10-29 15:30:00','venta',6),
(4,'salida',1,'2026-10-29 15:30:00','venta',6),
(3,'salida',1,'2026-10-29 18:05:00','venta',7),
(9,'salida',1,'2026-10-29 18:05:00','venta',7),
(5,'salida',1,'2026-10-30 09:10:00','venta',8);

-- Verificacion
SELECT 'usuarios' AS tabla, COUNT(*) AS filas FROM usuarios
UNION ALL SELECT 'tipos_membresia', COUNT(*) FROM tipos_membresia
UNION ALL SELECT 'miembros', COUNT(*) FROM miembros
UNION ALL SELECT 'membresias', COUNT(*) FROM membresias
UNION ALL SELECT 'productos', COUNT(*) FROM productos
UNION ALL SELECT 'inventario', COUNT(*) FROM inventario
UNION ALL SELECT 'ventas', COUNT(*) FROM ventas
UNION ALL SELECT 'detalle_ventas', COUNT(*) FROM detalle_ventas
UNION ALL SELECT 'movimientos_inventario', COUNT(*) FROM movimientos_inventario;

SELECT id, fecha_venta, total FROM ventas;  -- totales calculados por el trigger
