-- =====================================================
-- MetaFit | 01_crear_bd.sql
-- 2.1 CREATE DATABASE
-- =====================================================
DROP DATABASE IF EXISTS metafit;

CREATE DATABASE metafit
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE metafit;

SELECT DATABASE() AS base_de_datos_activa;
SHOW DATABASES LIKE 'metafit';
