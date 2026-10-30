-- =====================================================
-- MetaFit | 04_drop.sql
-- 2.3 DROP TABLE
-- Justificacion: pruebas_temporal se creo solo para ensayar
-- el despliegue; no forma parte del modelo, no tiene
-- relaciones y mantenerla ensuciaria el esquema.
-- =====================================================
USE metafit;

CREATE TABLE pruebas_temporal (
  id          INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(100) NOT NULL,
  creado      DATETIME DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO pruebas_temporal (descripcion) VALUES ('registro de prueba');

-- ANTES
SHOW TABLES;

DROP TABLE pruebas_temporal;

-- DESPUES
SHOW TABLES;
