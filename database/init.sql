-- ===================================================
-- SISTEMA PHARMASYS
-- Inicialización de Base de Datos
-- Motor: PostgreSQL
-- ===================================================

DROP TABLE IF EXISTS PAGO CASCADE;
DROP TABLE IF EXISTS DETALLE_VENTA CASCADE;
DROP TABLE IF EXISTS VENTA CASCADE;
DROP TABLE IF EXISTS RECETA_MEDICA CASCADE;
DROP TABLE IF EXISTS LOTE CASCADE;
DROP TABLE IF EXISTS ORDEN_COMPRA CASCADE;
DROP TABLE IF EXISTS PROVEEDOR CASCADE;
DROP TABLE IF EXISTS PRODUCTO CASCADE;
DROP TABLE IF EXISTS USUARIO CASCADE;

-- Tabla USUARIO
CREATE TABLE USUARIO (
    id_usuario SERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    contrasena_hash VARCHAR(255) NOT NULL,
    nombre_completo VARCHAR(100) NOT NULL,
    rol VARCHAR(30) NOT NULL CHECK (rol IN ('CAJERO', 'REGENTE', 'ADMIN')),
    estado BOOLEAN DEFAULT TRUE
);

-- Tabla PRODUCTO
CREATE TABLE PRODUCTO (
    id_producto SERIAL PRIMARY KEY,
    codigo_barras VARCHAR(50) UNIQUE NOT NULL,
    nombre_comercial VARCHAR(100) NOT NULL,
    principio_activo VARCHAR(100) NOT NULL,
    requiere_receta BOOLEAN DEFAULT FALSE,
    precio_venta DECIMAL(10,2) NOT NULL CHECK (precio_venta > 0),
    stock_total INT DEFAULT 0 CHECK (stock_total >= 0)
);

-- Tabla PROVEEDOR
CREATE TABLE PROVEEDOR (
    id_proveedor SERIAL PRIMARY KEY,
    nit VARCHAR(20) UNIQUE NOT NULL,
    razon_social VARCHAR(100) NOT NULL,
    telefono VARCHAR(20),
    email VARCHAR(100)
);

-- Tabla ORDEN_COMPRA
CREATE TABLE ORDEN_COMPRA (
    id_orden SERIAL PRIMARY KEY,
    id_proveedor INT NOT NULL,
    id_usuario INT NOT NULL,
    fecha_orden TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado_orden VARCHAR(30) DEFAULT 'PENDIENTE' CHECK (estado_orden IN ('PENDIENTE', 'RECIBIDA', 'CANCELADA')),
    total_compra DECIMAL(12,2) NOT NULL CHECK (total_compra >= 0),
    CONSTRAINT fk_orden_proveedor FOREIGN KEY (id_proveedor) REFERENCES PROVEEDOR(id_proveedor),
    CONSTRAINT fk_orden_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
);

-- Tabla LOTE 
CREATE TABLE LOTE (
    id_lote SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    id_orden INT,
    numero_lote VARCHAR(50) NOT NULL,
    fecha_fabricacion DATE NOT NULL,
    fecha_vencimiento DATE NOT NULL,
    cantidad_inicial INT NOT NULL CHECK (cantidad_inicial > 0),
    cantidad_disponible INT NOT NULL CHECK (cantidad_disponible >= 0),
    estado_lote VARCHAR(20) DEFAULT 'ACTIVO' CHECK (estado_lote IN ('ACTIVO', 'AGOTADO', 'VENCIDO')),
    CONSTRAINT fk_lote_producto FOREIGN KEY (id_producto) REFERENCES PRODUCTO(id_producto),
    CONSTRAINT fk_lote_orden FOREIGN KEY (id_orden) REFERENCES ORDEN_COMPRA(id_orden)
);

-- Tabla RECETA_MEDICA
CREATE TABLE RECETA_MEDICA (
    id_receta SERIAL PRIMARY KEY,
    numero_receta VARCHAR(50) UNIQUE NOT NULL,
    tarjeta_prof_medico VARCHAR(50) NOT NULL,
    nombre_medico VARCHAR(100) NOT NULL,
    nombre_paciente VARCHAR(100) NOT NULL,
    fecha_emision DATE NOT NULL,
    estado_validacion BOOLEAN DEFAULT TRUE
);

-- Tabla VENTA
CREATE TABLE VENTA (
    id_venta SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_receta INT,
    numero_factura VARCHAR(50) UNIQUE NOT NULL,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    impuesto DECIMAL(10,2) NOT NULL CHECK (impuesto >= 0),
    total DECIMAL(10,2) NOT NULL CHECK (total >= 0),
    estado_transaccion VARCHAR(20) DEFAULT 'COMMITTED' CHECK (estado_transaccion IN ('PENDIENTE', 'COMMITTED', 'ROLLED_BACK')),
    CONSTRAINT fk_venta_usuario FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario),
    CONSTRAINT fk_venta_receta FOREIGN KEY (id_receta) REFERENCES RECETA_MEDICA(id_receta)
);

-- Tabla DETALLE_VENTA
CREATE TABLE DETALLE_VENTA (
    id_detalle SERIAL PRIMARY KEY,
    id_venta INT NOT NULL,
    id_lote INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario > 0),
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    CONSTRAINT fk_detalle_venta FOREIGN KEY (id_venta) REFERENCES VENTA(id_venta) ON DELETE CASCADE,
    CONSTRAINT fk_detalle_lote FOREIGN KEY (id_lote) REFERENCES LOTE(id_lote)
);

-- Tabla PAGO
CREATE TABLE PAGO (
    id_pago SERIAL PRIMARY KEY,
    id_venta INT NOT NULL,
    metodo_pago VARCHAR(30) NOT NULL CHECK (metodo_pago IN ('EFECTIVO', 'TARJETA', 'TRANSFERENCIA')),
    monto_recibido DECIMAL(10,2) NOT NULL CHECK (monto_recibido >= 0),
    cambio DECIMAL(10,2) DEFAULT 0 CHECK (cambio >= 0),
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_pago_venta FOREIGN KEY (id_venta) REFERENCES VENTA(id_venta) ON DELETE CASCADE
);

-- Datos prueba

INSERT INTO USUARIO (usuario, contrasena_hash, nombre_completo, rol) VALUES
('admin_pharma', '$2b$10$e83921839218', 'Carlos Administrador', 'ADMIN'),
('cajero01', '$2b$10$e83921839219', 'María Pérez', 'CAJERO'),
('regente01', '$2b$10$e83921839220', 'Juan Regente', 'REGENTE');

INSERT INTO PRODUCTO (codigo_barras, nombre_comercial, principio_activo, requiere_receta, precio_venta, stock_total) VALUES
('7701234567890', 'Acetaminofén 500mg', 'Paracetamol', FALSE, 2500.00, 100),
('7709876543210', 'Amoxicilina 500mg', 'Amoxicilina', TRUE, 12000.00, 50);

INSERT INTO PROVEEDOR (nit, razon_social, telefono, email) VALUES
('900123456-1', 'Laboratorios Pharma S.A.', '6015551234', 'ventas@pharmasa.com');

INSERT INTO LOTE (id_producto, id_orden, numero_lote, fecha_fabricacion, fecha_vencimiento, cantidad_inicial, cantidad_disponible) VALUES
(1, NULL, 'LOT-2026-01', '2026-01-10', '2027-01-10', 100, 100),
(2, NULL, 'LOT-2026-02', '2026-02-01', '2026-11-30', 50, 50);
