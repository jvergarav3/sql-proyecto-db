-- =====================================================
-- MetaFit | 02_crear_tablas.sql
-- 2.1 CREATE TABLE (9 tablas) + triggers de ventas.total
-- Requiere MySQL 8.0.16+ (CHECK se aplica desde esa version)
-- =====================================================
USE metafit;
SET NAMES utf8mb4;

CREATE TABLE usuarios (
  id             INT AUTO_INCREMENT PRIMARY KEY,
  nombre         VARCHAR(100) NOT NULL,
  email          VARCHAR(120) NOT NULL UNIQUE,
  password_hash  VARCHAR(255) NOT NULL,
  rol            ENUM('administrador','trabajador','auditor') NOT NULL,
  activo         BOOLEAN NOT NULL DEFAULT TRUE COMMENT 'desactivar acceso sin borrar historial',
  fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_usuarios_rol (rol)
) ENGINE=InnoDB;

CREATE TABLE miembros (
  id               INT AUTO_INCREMENT PRIMARY KEY,
  nombre           VARCHAR(80) NOT NULL,
  apellido         VARCHAR(80) NOT NULL,
  email            VARCHAR(120) NULL UNIQUE,
  telefono         VARCHAR(20) NULL,
  fecha_nacimiento DATE NULL,
  fecha_registro   DATE NOT NULL,
  INDEX idx_miembros_nombre (apellido, nombre)
) ENGINE=InnoDB;

CREATE TABLE tipos_membresia (
  id            INT AUTO_INCREMENT PRIMARY KEY,
  nombre        VARCHAR(60) NOT NULL UNIQUE,
  precio        DECIMAL(10,2) NOT NULL,
  duracion_dias INT NOT NULL,
  CONSTRAINT chk_tipos_membresia_precio   CHECK (precio >= 0),
  CONSTRAINT chk_tipos_membresia_duracion CHECK (duracion_dias > 0)
) ENGINE=InnoDB;

CREATE TABLE membresias (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  miembro_id        INT NOT NULL,
  tipo_membresia_id INT NOT NULL,
  fecha_inicio      DATE NOT NULL,
  fecha_fin         DATE NOT NULL,
  estado            ENUM('activa','vencida','cancelada') NOT NULL,
  CONSTRAINT fk_membresias_miembro FOREIGN KEY (miembro_id)        REFERENCES miembros(id),
  CONSTRAINT fk_membresias_tipo    FOREIGN KEY (tipo_membresia_id) REFERENCES tipos_membresia(id),
  CONSTRAINT chk_membresias_fechas CHECK (fecha_fin >= fecha_inicio),
  INDEX idx_membresias_miembro (miembro_id),
  INDEX idx_membresias_tipo (tipo_membresia_id),
  INDEX idx_membresias_estado (estado),
  INDEX idx_membresias_fecha_fin (fecha_fin),
  INDEX idx_membresias_miembro_estado (miembro_id, estado)
) ENGINE=InnoDB;

CREATE TABLE productos (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  nombre       VARCHAR(80) NOT NULL,
  descripcion  TEXT NULL,
  categoria    ENUM('suplementos','bebidas','ropa','accesorios') NOT NULL,
  precio_venta DECIMAL(10,2) NOT NULL,
  precio_costo DECIMAL(10,2) NOT NULL,
  CONSTRAINT chk_productos_precio_venta CHECK (precio_venta >= 0),
  CONSTRAINT chk_productos_precio_costo CHECK (precio_costo >= 0),
  INDEX idx_productos_nombre (nombre)
) ENGINE=InnoDB;

CREATE TABLE inventario (
  id           INT AUTO_INCREMENT PRIMARY KEY,
  producto_id  INT NOT NULL UNIQUE COMMENT 'un producto tiene un solo registro de inventario',
  stock_actual INT NOT NULL,
  stock_minimo INT NOT NULL COMMENT 'para alertas de reabastecimiento',
  CONSTRAINT fk_inventario_producto FOREIGN KEY (producto_id) REFERENCES productos(id),
  CONSTRAINT chk_inventario_stock_actual CHECK (stock_actual >= 0),
  CONSTRAINT chk_inventario_stock_minimo CHECK (stock_minimo >= 0)
) ENGINE=InnoDB;

CREATE TABLE ventas (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  miembro_id      INT NULL COMMENT 'nullable: cliente ocasional',
  fecha_venta     DATETIME NOT NULL,
  total           DECIMAL(10,2) NOT NULL DEFAULT 0 COMMENT 'mantenido por TRIGGER sobre detalle_ventas',
  metodo_pago     ENUM('efectivo','tarjeta','transferencia') NOT NULL,
  referencia_pago VARCHAR(60) NULL COMMENT 'numero de transaccion, opcional para efectivo',
  usuario_id      INT NOT NULL COMMENT 'trabajador que registro la venta',
  CONSTRAINT fk_ventas_miembro FOREIGN KEY (miembro_id) REFERENCES miembros(id),
  CONSTRAINT fk_ventas_usuario FOREIGN KEY (usuario_id) REFERENCES usuarios(id),
  CONSTRAINT chk_ventas_total CHECK (total >= 0),
  INDEX idx_ventas_miembro (miembro_id),
  INDEX idx_ventas_fecha (fecha_venta),
  INDEX idx_ventas_usuario (usuario_id)
) ENGINE=InnoDB;

-- subtotal = cantidad * precio_unitario, calculado por el motor (columna generada)
CREATE TABLE detalle_ventas (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  venta_id        INT NOT NULL,
  producto_id     INT NULL,
  cantidad        INT NOT NULL,
  precio_unitario DECIMAL(10,2) NOT NULL COMMENT 'precio aplicado al momento de la venta',
  subtotal        DECIMAL(10,2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED,
  tipo_venta      ENUM('productos','membresia') NOT NULL,
  CONSTRAINT fk_detalle_venta    FOREIGN KEY (venta_id)    REFERENCES ventas(id),
  CONSTRAINT fk_detalle_producto FOREIGN KEY (producto_id) REFERENCES productos(id),
  CONSTRAINT chk_detalle_ventas_cantidad CHECK (cantidad > 0),
  CONSTRAINT chk_detalle_ventas_tipo_producto CHECK (
    (tipo_venta = 'productos' AND producto_id IS NOT NULL) OR
    (tipo_venta = 'membresia' AND producto_id IS NULL)),
  INDEX idx_detalle_venta (venta_id),
  INDEX idx_detalle_producto (producto_id)
) ENGINE=InnoDB;

CREATE TABLE movimientos_inventario (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  inventario_id   INT NOT NULL,
  tipo_movimiento ENUM('entrada','salida','ajuste') NOT NULL,
  cantidad        INT NOT NULL,
  fecha           DATETIME NOT NULL,
  motivo          ENUM('compra_proveedor','venta','merma','conteo_fisico') NOT NULL,
  venta_id        INT NULL COMMENT 'solo si es salida por venta',
  CONSTRAINT fk_movimientos_inventario FOREIGN KEY (inventario_id) REFERENCES inventario(id),
  CONSTRAINT fk_movimientos_venta      FOREIGN KEY (venta_id)      REFERENCES ventas(id),
  CONSTRAINT chk_movimientos_cantidad CHECK (cantidad > 0),
  INDEX idx_movimientos_fecha (fecha),
  INDEX idx_movimientos_venta (venta_id)
) ENGINE=InnoDB;

-- ---------- Triggers: mantienen ventas.total ----------
DELIMITER $$

CREATE TRIGGER trg_detalle_ventas_ai AFTER INSERT ON detalle_ventas
FOR EACH ROW
BEGIN
  UPDATE ventas
     SET total = (SELECT COALESCE(SUM(subtotal),0) FROM detalle_ventas WHERE venta_id = NEW.venta_id)
   WHERE id = NEW.venta_id;
END$$

CREATE TRIGGER trg_detalle_ventas_au AFTER UPDATE ON detalle_ventas
FOR EACH ROW
BEGIN
  UPDATE ventas
     SET total = (SELECT COALESCE(SUM(subtotal),0) FROM detalle_ventas WHERE venta_id = NEW.venta_id)
   WHERE id = NEW.venta_id;
  IF OLD.venta_id <> NEW.venta_id THEN
    UPDATE ventas
       SET total = (SELECT COALESCE(SUM(subtotal),0) FROM detalle_ventas WHERE venta_id = OLD.venta_id)
     WHERE id = OLD.venta_id;
  END IF;
END$$

CREATE TRIGGER trg_detalle_ventas_ad AFTER DELETE ON detalle_ventas
FOR EACH ROW
BEGIN
  UPDATE ventas
     SET total = (SELECT COALESCE(SUM(subtotal),0) FROM detalle_ventas WHERE venta_id = OLD.venta_id)
   WHERE id = OLD.venta_id;
END$$

DELIMITER ;

SHOW TABLES;
SHOW CREATE TABLE detalle_ventas;
