CREATE DATABASE IF NOT EXISTS mechanix_db;
USE mechanix_db;

-- 1. tipo_documento
CREATE TABLE tipo_documento (
    id_tipo_doc INT AUTO_INCREMENT PRIMARY KEY,
    nombre_doc VARCHAR(50) NOT NULL
);

-- 2. tipo_servicio
CREATE TABLE tipo_servicio (
    id_tipo_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL,
    descripcion TEXT
);

-- 3. tipo_venta
CREATE TABLE tipo_venta (
    id_tipo_venta INT AUTO_INCREMENT PRIMARY KEY,
    nombre_venta VARCHAR(50) NOT NULL
);

-- 4. estado_servicio
CREATE TABLE estado_servicio (
    id_estado INT AUTO_INCREMENT PRIMARY KEY,
    nombre_estado VARCHAR(50) NOT NULL
);

-- 5. impuestos
CREATE TABLE impuestos (
    id_impuesto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_impuesto VARCHAR(50),
    porcentaje DECIMAL(5,2) NOT NULL
);

-- 6. usuarios
CREATE TABLE usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    rol VARCHAR(50) DEFAULT 'Empleado'
);

-- 7. clientes
CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(100),
    apellido_cliente VARCHAR(100),
    documento_cliente VARCHAR(20) UNIQUE,
    id_tipo_doc INT,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    direccion VARCHAR(150),
    FOREIGN KEY (id_tipo_doc) REFERENCES tipo_documento(id_tipo_doc)
);

-- 8. empleados
CREATE TABLE empleados (
    id_empleado INT AUTO_INCREMENT PRIMARY KEY,
    nombre_empleado VARCHAR(100),
    apellido_empleado VARCHAR(100),
    documento_empleado VARCHAR(20) UNIQUE,
    id_tipo_doc INT,
    telefono VARCHAR(20),
    correo VARCHAR(100),
    cargo VARCHAR(50),
    FOREIGN KEY (id_tipo_doc) REFERENCES tipo_documento(id_tipo_doc)
);

-- 9. proveedores
CREATE TABLE proveedores (
    id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
    nombre_proveedor VARCHAR(100),
    telefono VARCHAR(20),
    correo VARCHAR(100),
    direccion VARCHAR(150)
);

-- 10. maestro_servicios
CREATE TABLE maestro_servicios (
    id_servicio INT AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL,
    id_tipo_servicio INT,
    estado VARCHAR(20) DEFAULT 'Activo',
    FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio(id_tipo_servicio)
);

-- 11. vehiculos
CREATE TABLE vehiculos (
    id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT,
    placa VARCHAR(10) UNIQUE NOT NULL,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    anio INT,
    tipo_vehiculo VARCHAR(50),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- 12. citas_servicio
CREATE TABLE citas_servicio (
    id_cita INT AUTO_INCREMENT PRIMARY KEY,
    id_vehiculo INT,
    fecha_cita DATETIME,
    motivo TEXT,
    estado VARCHAR(50) DEFAULT 'Pendiente',
    FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id_vehiculo)
);

-- 13. ventas
CREATE TABLE ventas (
    id_venta INT AUTO_INCREMENT PRIMARY KEY,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_cliente INT,
    id_empleado INT,
    id_tipo_venta INT,
    total_venta DECIMAL(12,2),
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES empleados(id_empleado),
    FOREIGN KEY (id_tipo_venta) REFERENCES tipo_venta(id_tipo_venta)
);

-- 14. detalle_factura
CREATE TABLE detalle_factura (
    id_detalle INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT,
    id_servicio INT,
    cantidad INT DEFAULT 1,
    precio_unitario DECIMAL(10,2),
    id_impuesto INT,
    valor_impuesto DECIMAL(10,2),
    valor_total DECIMAL(12,2),
    id_estado INT,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    FOREIGN KEY (id_servicio) REFERENCES maestro_servicios(id_servicio),
    FOREIGN KEY (id_impuesto) REFERENCES impuestos(id_impuesto),
    FOREIGN KEY (id_estado) REFERENCES estado_servicio(id_estado)
);

-- 15. historial_servicios
CREATE TABLE historial_servicios (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_vehiculo INT,
    id_servicio INT,
    fecha_servicio DATETIME,
    descripcion TEXT,
    id_estado INT,
    FOREIGN KEY (id_vehiculo) REFERENCES vehiculos(id_vehiculo),
    FOREIGN KEY (id_servicio) REFERENCES maestro_servicios(id_servicio),
    FOREIGN KEY (id_estado) REFERENCES estado_servicio(id_estado)
);

-- 16. pagos
CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT,
    metodo_pago VARCHAR(50),
    monto_pagado DECIMAL(12,2),
    fecha_pago DATETIME DEFAULT CURRENT_TIMESTAMP,
    observaciones TEXT,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta)
);

-- 17. configuracion_taller
CREATE TABLE configuracion_taller (
    id_config INT AUTO_INCREMENT PRIMARY KEY,
    nombre_taller VARCHAR(100),
    nit VARCHAR(20),
    direccion VARCHAR(150),
    telefono VARCHAR(20),
    correo VARCHAR(100),
    porcentaje_iva DECIMAL(5,2) DEFAULT 0.00
);

-- 18. bitacora_usuarios
CREATE TABLE bitacora_usuarios (
    id_bitacora INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT,
    accion VARCHAR(100),
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    ip_usuario VARCHAR(45),
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
);

-- 19. repuestos
CREATE TABLE repuestos (
    id_repuesto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_repuesto VARCHAR(100) NOT NULL,
    descripcion TEXT,
    stock INT DEFAULT 0,
    precio_unitario DECIMAL(10,2) NOT NULL,
    id_proveedor INT,
    estado VARCHAR(20) DEFAULT 'Activo',
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);
