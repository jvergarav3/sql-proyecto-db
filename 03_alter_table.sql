-- =====================================================
-- MetaFit | 03_alter_table.sql
-- 2.2 ALTER TABLE (3 modificaciones reales)
-- =====================================================
USE metafit;

-- 1) ADD COLUMN: guardar la direccion del miembro
DESCRIBE miembros;
ALTER TABLE miembros ADD COLUMN direccion VARCHAR(150) NULL AFTER telefono;
DESCRIBE miembros;

-- 2) MODIFY COLUMN: nombres de producto mas largos (80 -> 120)
DESCRIBE productos;
ALTER TABLE productos MODIFY COLUMN nombre VARCHAR(120) NOT NULL;
DESCRIBE productos;

-- 3) ADD COLUMN: auditar el ultimo acceso de cada usuario
DESCRIBE usuarios;
ALTER TABLE usuarios ADD COLUMN ultimo_acceso DATETIME NULL;
DESCRIBE usuarios;
