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


-- Datos en cada tabla
-- 1. tipo_documento
INSERT INTO tipo_documento (nombre_doc) VALUES
('Cédula de Ciudadanía'),
('Cédula de Extranjería'),
('Pasaporte');

-- 2 tipo_servicio
INSERT INTO tipo_servicio (nombre_servicio, descripcion) VALUES
('Mecánica General', 'Servicios relacionados con el mantenimiento y reparación de componentes mecánicos'),
('Electricidad Automotriz', 'Diagnóstico y reparación del sistema eléctrico del vehículo'),
('Cambio de Aceite', 'Reemplazo de aceite y filtro de motor');

-- 3. tipo_venta
INSERT INTO tipo_venta (nombre_venta) VALUES
('Contado'),
('Crédito'),
('Transferencia');

-- 4. estado_servicio
INSERT INTO estado_servicio (nombre_estado) VALUES
('Pendiente'),
('En Proceso'),
('Finalizado'),
('Cancelado');

-- 5. impuestos
INSERT INTO impuestos (nombre_impuesto, porcentaje) VALUES
('IVA 19%', 19.00),
('IVA 5%', 5.00),
('Exento', 0.00);

--6. usuarios
INSERT INTO usuarios (id_usuario, nombre, apellido, correo, contraseña, telefono, rol) VALUES
(1, 'Andrés', 'Zambrano', 'andresz@mechanix.com', 'admin123', '3001234567', 'Administrador'),
(2, 'Andrea', 'Garnica', 'andreag@mechanix.com', 'conta123', '3001234568', 'Contadora'),
(3, 'Laura', 'García', 'laurag@mechanix.com', 'auxiliaradmin123', '3019876543', 'Auxiliar Administrativo'),
(4, 'Santiago', 'Lopez', 'santiagol@mechanix.com', 'cajero123', '3004567890', 'Cajero');
(5, 'Cristian', 'Arguello', 'cristiana@mechanix.com', 'asesor2001', '3024567833', 'Asesor Servicio'),
(6, 'Carlos', 'Martínez', 'carlosm@mechanix.com', 'mecanico2002', '3024567890', 'Mecánico'),
(7, 'Gregorio', 'Machado', 'gregoriom@mechanix.com', 'mecanico2003', '3024567898', 'Mecánico'),
(8, 'Cesar', 'Perez', 'cesarp@mechanix.com', 'electrico2004', '3024567896', 'Electrico'),
(9, 'Ernesto', 'Samper', 'ernestos@mechanix.com', 'latonero2005', '3024567899', 'Latonero');

--7. clientes
INSERT INTO clientes (nombre_cliente, apellido_cliente, documento_cliente, id_tipo_doc, telefono, correo, direccion) VALUES
('Ana', 'Ramírez', '1000123451', 1, '3001234567', 'ana.ramirez@gmail.com', 'Cra 1 #10-20'),
('Luis', 'González', '1000123452', 2, '3001234568', 'luis.gonzalez@yahoo.com', 'Calle 45 #67-89'),
('Camila', 'Torres', '1000123453', 3, '3019876543', 'camila.torres@hotmail.com', 'Av 68 #23-45'),
('Juan', 'Pérez', '1000123454', 1, '3123456789', 'juanperez@outlook.com', 'Calle 50 #11-22'),
('Sara', 'Martínez', '1000123455', 2, '3134567890', 'sara.martinez@gmail.com', 'Carrera 25 #70-15'),
('Andrés', 'Gómez', '1000123456', 3, '3145678901', 'andres.gomez@yahoo.com', 'Cra 12 #30-45'),
('María', 'López', '1000123457', 1, '3156789012', 'maria.lopez@live.com', 'Calle 8 #80-90'),
('Carlos', 'Rodríguez', '1000123458', 2, '3167890123', 'carlos.rodriguez@ymail.com', 'Av Suba #99-23'),
('Natalia', 'Castro', '1000123459', 3, '3178901234', 'natalia.castro@gmail.com', 'Calle 60 #13-56'),
('Felipe', 'Moreno', '1000123460', 1, '3189012345', 'felipe.moreno@yahoo.es', 'Cra 45 #20-50'),
('Lucía', 'Cruz', '1000123461', 2, '3190123456', 'lucia.cruz@hotmail.com', 'Transv 25 #44-67'),
('David', 'Ruiz', '1000123462', 3, '3201234567', 'david.ruiz@gmail.com', 'Calle 100 #30-40'),
('Juliana', 'Mendoza', '1000123463', 1, '3212345678', 'juliana.mendoza@yahoo.com', 'Cra 3 #10-12'),
('Esteban', 'Vargas', '1000123464', 2, '3223456789', 'esteban.vargas@outlook.com', 'Av Boyacá #55-66'),
('Valentina', 'Mejía', '1000123465', 3, '3234567890', 'valentina.mejia@gmail.com', 'Calle 80 #50-20'),
('Daniel', 'Sánchez', '1000123466', 1, '3245678901', 'daniel.sanchez@hotmail.com', 'Cra 20 #15-80'),
('Isabella', 'Ortiz', '1000123467', 2, '3256789012', 'isabella.ortiz@live.com', 'Av Caracas #70-22'),
('Sebastián', 'Ramos', '1000123468', 3, '3267890123', 'sebastian.ramos@yahoo.com', 'Calle 34 #20-20'),
('Laura', 'Delgado', '1000123469', 1, '3278901234', 'laura.delgado@gmail.com', 'Cra 10 #5-33'),
('Mateo', 'Castaño', '1000123470', 2, '3289012345', 'mateo.castano@ymail.com', 'Av 30 #90-10'),
('Diana', 'Herrera', '1000123471', 3, '3290123456', 'diana.herrera@yahoo.es', 'Calle 13 #6-14'),
('Santiago', 'Álvarez', '1000123472', 1, '3301234567', 'santiago.alvarez@hotmail.com', 'Cra 5 #50-60'),
('Paula', 'Patiño', '1000123473', 2, '3312345678', 'paula.patino@gmail.com', 'Av 1 #10-10'),
('Tomás', 'Nieto', '1000123474', 3, '3323456789', 'tomas.nieto@live.com', 'Cra 17 #9-11'),
('Luciana', 'Reyes', '1000123475', 1, '3334567890', 'luciana.reyes@hotmail.com', 'Calle 67 #11-22'),
('Samuel', 'Figueroa', '1000123476', 2, '3345678901', 'samuel.figueroa@gmail.com', 'Av Chile #30-31'),
('Mónica', 'Salazar', '1000123477', 3, '3356789012', 'monica.salazar@yahoo.com', 'Cra 9 #55-80'),
('Miguel', 'Valencia', '1000123478', 1, '3367890123', 'miguel.valencia@outlook.com', 'Calle 100 #8-10'),
('Adriana', 'Guerrero', '1000123479', 2, '3378901234', 'adriana.guerrero@gmail.com', 'Cra 80 #40-45'),
('Julián', 'Camargo', '1000123480', 3, '3389012345', 'julian.camargo@hotmail.com', 'Av El Dorado #13-44'),
('Nicole', 'Rivera', '1000123481', 1, '3390123456', 'nicole.rivera@yahoo.es', 'Calle 123 #45-60'),
('Ricardo', 'Navarro', '1000123482', 2, '3401234567', 'ricardo.navarro@gmail.com', 'Cra 70 #22-80'),
('Mariana', 'Acosta', '1000123483', 3, '3412345678', 'mariana.acosta@hotmail.com', 'Av Americas #80-90'),
('Diego', 'Espinosa', '1000123484', 1, '3423456789', 'diego.espinosa@live.com', 'Cra 2 #60-50'),
('Angélica', 'Ríos', '1000123485', 2, '3434567890', 'angelica.rios@gmail.com', 'Calle 91 #33-33'),
('Oscar', 'Barrios', '1000123486', 3, '3445678901', 'oscar.barrios@outlook.com', 'Cra 4 #10-80'),
('Viviana', 'Mora', '1000123487', 1, '3456789012', 'viviana.mora@yahoo.com', 'Av 68 #44-50'),
('Jorge', 'Peña', '1000123488', 2, '3467890123', 'jorge.pena@gmail.com', 'Calle 99 #20-21'),
('Nataly', 'Benítez', '1000123489', 3, '3478901234', 'nataly.benitez@hotmail.com', 'Cra 11 #77-78'),
('Kevin', 'Zapata', '1000123490', 1, '3489012345', 'kevin.zapata@live.com', 'Av 30 #20-40'),
('Daniela', 'Silva', '1000123491', 2, '3490123456', 'daniela.silva@gmail.com', 'Calle 22 #88-99'),
('Gabriel', 'Villalba', '1000123492', 3, '3501234567', 'gabriel.villalba@yahoo.com', 'Cra 15 #33-10'),
('Sandra', 'Chávez', '1000123493', 1, '3512345678', 'sandra.chavez@hotmail.com', 'Av 68 #13-90'),
('Raúl', 'Padilla', '1000123494', 2, '3523456789', 'raul.padilla@outlook.com', 'Cra 100 #21-34'),
('Elena', 'Montoya', '1000123495', 3, '3534567890', 'elena.montoya@gmail.com', 'Calle 7 #10-10'),
('Marco', 'Velásquez', '1000123496', 1, '3545678901', 'marco.velasquez@yahoo.es', 'Cra 66 #40-44'),
('Carolina', 'Núñez', '1000123497', 2, '3556789012', 'carolina.nunez@hotmail.com', 'Av Caracas #33-33'),
('Jhon', 'Murillo', '1000123498', 3, '3567890123', 'jhon.murillo@gmail.com', 'Cra 12 #15-67'),
('Tatiana', 'Bermúdez', '1000123499', 1, '3578901234', 'tatiana.bermudez@live.com', 'Calle 44 #55-66'),
('Pedro', 'Serrano', '1000123500', 2, '3589012345', 'pedro.serrano@hotmail.com', 'Cra 17 #10-88');

--8. empleados
INSERT INTO empleados (nombre_empleado, apellido_empleado, documentos_empleado, id_tipo_doc, telefono, correo, cargo) VALUES
('Andrés', 'Zambrano', '1001001001', 1, '3001234567', 'andresz@mechanix.com', 'Administrador'),
('Andrea', 'Garnica', '1001001002', 1, '3001234568', 'andreag@mechanix.com', 'Contadora'),
('Laura', 'García', '1001001003', 1, '3019876543', 'laurag@mechanix.com', 'Auxiliar Administrativo'),
('Santiago', 'Lopez', '1001001004', 1, '3004567890', 'santiagol@mechanix.com', 'Cajero'),
('Cristian', 'Arguello', '1001001004', 1, '3024567833', 'cristiana@mechanix.com', 'Asesor Servicio'),
('Carlos', 'Martínez', '1001001005', 1, '3024567890', 'carlosm@mechanix.com', 'Mecánico'),
('Gregorio', 'Machado', '1001001006', 1, '3024567898', 'gregoriom@mechanix.com', 'Mecánico'),
('Cesar', 'Perez', '1001001007', 1, '3024567896', 'cesarp@mechanix.com', 'Electrico'),
('Ernesto', 'Samper', '1001001008', 1, '3024567899', 'ernestos@mechanix.com', 'Latonero');

--9. proveedores
INSERT INTO proveedores (nombre_proveedor, direccion, telefono, correo, nit, tipo_proveedor, estado) VALUES
('Autopartes Colombia S.A.', 'Cra 10 #25-30', '3101234567', 'contacto@autopartesco.com', '900123456-1', 'Repuestos', 'Activo'),
('ServiMotor Ltda', 'Av Caracas #40-22', '3112345678', 'info@servimotor.com', '800234567-8', 'Servicios', 'Activo'),
('TecnoLub SAS', 'Calle 50 #45-10', '3123456789', 'ventas@tecnolub.com', '901345678-9', 'Repuestos', 'Activo'),
('Refacciones Express', 'Transv 60 #18-44', '3134567890', 'refacciones@express.com', '902456789-0', 'Repuestos', 'Inactivo'),
('Electricaribe Autos', 'Cra 45 #33-21', '3145678901', 'soporte@electricaribeautos.com', '803567890-1', 'Servicios', 'Activo'),
('Lubricantes Norte', 'Calle 15 #8-12', '3156789012', 'lubri@norte.com', '904678901-2', 'Repuestos', 'Activo'),
('Repuestos Rápidos S.A.S', 'Av Suba #80-60', '3167890123', 'ventas@repuestosrapidos.com', '905789012-3', 'Repuestos', 'Activo'),
('Pinturas del Valle', 'Cra 100 #10-55', '3178901234', 'contacto@pinturasvalle.com', '906890123-4', 'Servicios', 'Activo'),
('Soldaduras y más', 'Calle 77 #55-20', '3189012345', 'soldadurasymas@gmail.com', '907901234-5', 'Servicios', 'Inactivo'),
('AutoGlass Pro', 'Av Américas #90-10', '3190123456', 'autoglass@pro.com', '908012345-6', 'Repuestos', 'Activo');

--10. mestro_servicios
INSERT INTO maestro_servicios (nombre_servicio, descripcion, precio, id_tipo_servicio, estado) VALUES
('Cambio de aceite', 'Incluye cambio de aceite de motor y filtro', 80000, 1, 'Activo'),
('Alineación y balanceo', 'Servicio de alineación de ejes y balanceo de llantas', 120000, 1, 'Activo'),
('Diagnóstico eléctrico', 'Revisión y prueba del sistema eléctrico', 95000, 2, 'Activo'),
('Cambio de pastillas de freno', 'Reemplazo de pastillas delanteras y revisión de discos', 110000, 1, 'Activo'),
('Diagnóstico de motor', 'Lectura de códigos OBD y revisión de funcionamiento', 70000, 3, 'Activo'),
('Mantenimiento preventivo', 'Servicio por kilometraje: fluidos, filtros, correas', 150000, 1, 'Activo'),
('Servicio de suspensión', 'Inspección y reemplazo de amortiguadores y bujes', 180000, 1, 'Activo'),
('Chequeo del sistema de escape', 'Inspección de fugas, sensores y catalizador', 75000, 3, 'Activo'),
('Latonería y pintura', 'Reparación de golpes menores y aplicación de pintura', 300000, 4, 'Activo'),
('Sistema de frenos ABS', 'Diagnóstico y mantenimiento del sistema ABS', 125000, 2, 'Activo');


--11. vehiculos
INSERT INTO vehiculos (id_cliente, placa, marca, modelo, año, tipo_vehiculo) VALUES
(1, 'ABC123', 'Chevrolet', 'Sail', 2020, 'Sedán'),
(2, 'XYZ456', 'Renault', 'Duster', 2021, 'SUV'),
(3, 'JKL789', 'Mazda', 'CX-5', 2022, 'SUV'),
(4, 'LMN321', 'Toyota', 'Hilux', 2019, 'Pickup'),
(5, 'PQR654', 'Hyundai', 'Tucson', 2023, 'SUV'),
(6, 'STU987', 'Kia', 'Rio', 2018, 'Sedán'),
(7, 'VWX159', 'Ford', 'Escape', 2020, 'SUV'),
(8, 'YZA753', 'Volkswagen', 'Jetta', 2017, 'Sedán'),
(9, 'BCD951', 'Nissan', 'Frontier', 2022, 'Pickup'),
(10, 'EFG357', 'BMW', 'X3', 2023, 'SUV'),
(11, 'HIJ258', 'Mercedes-Benz', 'GLA', 2021, 'SUV'),
(12, 'KLM852', 'Peugeot', '2008', 2020, 'Crossover'),
(13, 'NOP456', 'Fiat', 'Argo', 2019, 'Hatchback'),
(14, 'QRS789', 'Chevrolet', 'Tracker', 2023, 'SUV'),
(15, 'TUV963', 'Honda', 'Civic', 2022, 'Sedán'),
(16, 'WXY741', 'Subaru', 'Forester', 2021, 'SUV'),
(17, 'ZAB369', 'Jeep', 'Renegade', 2020, 'SUV'),
(18, 'CDE258', 'Toyota', 'Corolla', 2022, 'Sedán'),
(19, 'FGH147', 'Mazda', '3', 2018, 'Sedán'),
(20, 'IJK369', 'Nissan', 'Sentra', 2019, 'Sedán'),
(21, 'LMO951', 'Renault', 'Logan', 2023, 'Sedán'),
(22, 'PQR753', 'Chevrolet', 'Onix', 2021, 'Hatchback'),
(23, 'STU159', 'Hyundai', 'Accent', 2020, 'Sedán'),
(24, 'VWX357', 'Ford', 'Ranger', 2022, 'Pickup'),
(25, 'YZA654', 'Suzuki', 'Vitara', 2023, 'SUV'),
(26, 'BCD852', 'Jeep', 'Compass', 2021, 'SUV'),
(27, 'EFG456', 'Honda', 'CR-V', 2019, 'SUV'),
(28, 'HIJ753', 'Chevrolet', 'Spark GT', 2020, 'Hatchback'),
(29, 'KLM159', 'Volkswagen', 'Tiguan', 2022, 'SUV'),
(30, 'NOP963', 'BMW', 'X1', 2021, 'SUV'),
(31, 'QRS741', 'Toyota', 'Yaris', 2018, 'Hatchback'),
(32, 'TUV258', 'Ford', 'Fiesta', 2019, 'Hatchback'),
(33, 'WXY357', 'Nissan', 'March', 2020, 'Hatchback'),
(34, 'ZAB456', 'Renault', 'Kwid', 2023, 'Hatchback'),
(35, 'CDE753', 'Mazda', 'BT-50', 2022, 'Pickup'),
(36, 'FGH951', 'Chevrolet', 'Captiva', 2020, 'SUV'),
(37, 'IJK147', 'Kia', 'Sportage', 2021, 'SUV'),
(38, 'LMO369', 'Hyundai', 'Creta', 2022, 'SUV'),
(39, 'PQR258', 'Fiat', 'Mobi', 2019, 'Hatchback'),
(40, 'STU456', 'Volkswagen', 'Gol', 2018, 'Hatchback'),
(41, 'VWX741', 'Chery', 'Tiggo 2', 2023, 'SUV'),
(42, 'YZA159', 'Ford', 'Explorer', 2021, 'SUV'),
(43, 'BCD369', 'Subaru', 'XV', 2020, 'SUV'),
(44, 'EFG258', 'Renault', 'Sandero', 2022, 'Hatchback'),
(45, 'HIJ456', 'Toyota', 'Rav4', 2023, 'SUV'),
(46, 'KLM753', 'Mazda', 'CX-30', 2021, 'Crossover'),
(47, 'NOP147', 'Kia', 'Cerato', 2019, 'Sedán'),
(48, 'QRS258', 'Nissan', 'Versa', 2020, 'Sedán'),
(49, 'TUV951', 'Chevrolet', 'N300', 2018, 'Van'),
(50, 'WXY456', 'Hyundai', 'HB20', 2021, 'Hatchback');

--11. vehiculos
INSERT INTO vehiculos (id_cliente, placa, marca, modelo, año, tipo_vehiculo) VALUES
(1, 'ABC123', 'Chevrolet', 'Sail', 2020, 'Sedán'),
(2, 'XYZ456', 'Renault', 'Duster', 2021, 'SUV'),
(3, 'JKL789', 'Mazda', 'CX-5', 2022, 'SUV'),
(4, 'LMN321', 'Toyota', 'Hilux', 2019, 'Pickup'),
(5, 'PQR654', 'Hyundai', 'Tucson', 2023, 'SUV'),
(6, 'STU987', 'Kia', 'Rio', 2018, 'Sedán'),
(7, 'VWX159', 'Ford', 'Escape', 2020, 'SUV'),
(8, 'YZA753', 'Volkswagen', 'Jetta', 2017, 'Sedán'),
(9, 'BCD951', 'Nissan', 'Frontier', 2022, 'Pickup'),
(10, 'EFG357', 'BMW', 'X3', 2023, 'SUV'),
(11, 'HIJ258', 'Mercedes-Benz', 'GLA', 2021, 'SUV'),
(12, 'KLM852', 'Peugeot', '2008', 2020, 'Crossover'),
(13, 'NOP456', 'Fiat', 'Argo', 2019, 'Hatchback'),
(14, 'QRS789', 'Chevrolet', 'Tracker', 2023, 'SUV'),
(15, 'TUV963', 'Honda', 'Civic', 2022, 'Sedán'),
(16, 'WXY741', 'Subaru', 'Forester', 2021, 'SUV'),
(17, 'ZAB369', 'Jeep', 'Renegade', 2020, 'SUV'),
(18, 'CDE258', 'Toyota', 'Corolla', 2022, 'Sedán'),
(19, 'FGH147', 'Mazda', '3', 2018, 'Sedán'),
(20, 'IJK369', 'Nissan', 'Sentra', 2019, 'Sedán'),
(21, 'LMO951', 'Renault', 'Logan', 2023, 'Sedán'),
(22, 'PQR753', 'Chevrolet', 'Onix', 2021, 'Hatchback'),
(23, 'STU159', 'Hyundai', 'Accent', 2020, 'Sedán'),
(24, 'VWX357', 'Ford', 'Ranger', 2022, 'Pickup'),
(25, 'YZA654', 'Suzuki', 'Vitara', 2023, 'SUV'),
(26, 'BCD852', 'Jeep', 'Compass', 2021, 'SUV'),
(27, 'EFG456', 'Honda', 'CR-V', 2019, 'SUV'),
(28, 'HIJ753', 'Chevrolet', 'Spark GT', 2020, 'Hatchback'),
(29, 'KLM159', 'Volkswagen', 'Tiguan', 2022, 'SUV'),
(30, 'NOP963', 'BMW', 'X1', 2021, 'SUV'),
(31, 'QRS741', 'Toyota', 'Yaris', 2018, 'Hatchback'),
(32, 'TUV258', 'Ford', 'Fiesta', 2019, 'Hatchback'),
(33, 'WXY357', 'Nissan', 'March', 2020, 'Hatchback'),
(34, 'ZAB456', 'Renault', 'Kwid', 2023, 'Hatchback'),
(35, 'CDE753', 'Mazda', 'BT-50', 2022, 'Pickup'),
(36, 'FGH951', 'Chevrolet', 'Captiva', 2020, 'SUV'),
(37, 'IJK147', 'Kia', 'Sportage', 2021, 'SUV'),
(38, 'LMO369', 'Hyundai', 'Creta', 2022, 'SUV'),
(39, 'PQR258', 'Fiat', 'Mobi', 2019, 'Hatchback'),
(40, 'STU456', 'Volkswagen', 'Gol', 2018, 'Hatchback'),
(41, 'VWX741', 'Chery', 'Tiggo 2', 2023, 'SUV'),
(42, 'YZA159', 'Ford', 'Explorer', 2021, 'SUV'),
(43, 'BCD369', 'Subaru', 'XV', 2020, 'SUV'),
(44, 'EFG258', 'Renault', 'Sandero', 2022, 'Hatchback'),
(45, 'HIJ456', 'Toyota', 'Rav4', 2023, 'SUV'),
(46, 'KLM753', 'Mazda', 'CX-30', 2021, 'Crossover'),
(47, 'NOP147', 'Kia', 'Cerato', 2019, 'Sedán'),
(48, 'QRS258', 'Nissan', 'Versa', 2020, 'Sedán'),
(49, 'TUV951', 'Chevrolet', 'N300', 2018, 'Van'),
(50, 'WXY456', 'Hyundai', 'HB20', 2021, 'Hatchback');

--11. citas_servicio
INSERT INTO citas_servicio (id_vehiculo, fecha_cita, motivo, estado) VALUES
(1, '2025-06-15', 'Cambio de aceite y filtro', 'Pendiente'),
(2, '2025-06-15', 'Revisión general preventiva', 'Pendiente'),
(3, '2025-06-15', 'Alineación y balanceo', 'Pendiente'),
(4, '2025-06-15', 'Diagnóstico eléctrico', 'Pendiente'),
(5, '2025-06-15', 'Cambio de frenos traseros', 'Pendiente'),
(6, '2025-06-15', 'Cambio de bujías', 'Pendiente'),
(7, '2025-06-15', 'Latonería y pintura general', 'Pendiente'),
(8, '2025-06-15', 'Cambio de correa de distribución', 'Pendiente'),
(9, '2025-06-15', 'Cambio de llantas', 'Pendiente'),
(10, '2025-06-15', 'Revisión de suspensión delantera', 'Pendiente'),
(11, '2025-06-16', 'Revisión de caja automática', 'Pendiente'),
(12, '2025-06-16', 'Mantenimiento por kilometraje', 'Pendiente'),
(13, '2025-06-16', 'Chequeo sistema eléctrico', 'Pendiente'),
(14, '2025-06-16', 'Revisión del sistema de escape', 'Pendiente'),
(15, '2025-06-16', 'Diagnóstico de ruido motor', 'Pendiente'),
(16, '2025-06-16', 'Cambio de batería', 'Pendiente'),
(17, '2025-06-16', 'Revisión luces y señalización', 'Pendiente'),
(18, '2025-06-16', 'Cambio de líquido de frenos', 'Pendiente'),
(19, '2025-06-16', 'Chequeo de sensores', 'Pendiente'),
(20, '2025-06-16', 'Revisión post-compra', 'Pendiente'),
(21, '2025-06-17', 'Diagnóstico de fallas eléctricas', 'Pendiente'),
(22, '2025-06-17', 'Cambio de amortiguadores', 'Pendiente'),
(23, '2025-06-17', 'Cambio de filtro de aire', 'Pendiente'),
(24, '2025-06-17', 'Ajuste de motor', 'Pendiente'),
(25, '2025-06-17', 'Inspección de frenos', 'Pendiente'),
(26, '2025-06-17', 'Cambio de filtro de combustible', 'Pendiente'),
(27, '2025-06-17', 'Lavado de motor', 'Pendiente'),
(28, '2025-06-17', 'Latonería y pintura por colisión', 'Pendiente'),
(29, '2025-06-17', 'Cambio de pastillas de freno', 'Pendiente'),
(30, '2025-06-17', 'Chequeo sistema hidráulico', 'Pendiente'),
(31, '2025-06-18', 'Revisión del alternador', 'Pendiente'),
(32, '2025-06-18', 'Alineación láser', 'Pendiente'),
(33, '2025-06-18', 'Inspección técnica general', 'Pendiente'),
(34, '2025-06-18', 'Servicio completo', 'Pendiente'),
(35, '2025-06-18', 'Cambio de refrigerante', 'Pendiente'),
(36, '2025-06-18', 'Instalación de luces LED', 'Pendiente'),
(37, '2025-06-18', 'Cambio de escobillas', 'Pendiente'),
(38, '2025-06-18', 'Chequeo transmisión', 'Pendiente'),
(39, '2025-06-18', 'Revisión de turbo', 'Pendiente'),
(40, '2025-06-18', 'Chequeo de presión de aceite', 'Pendiente'),
(41, '2025-06-19', 'Cambio de tapa válvulas', 'Pendiente'),
(42, '2025-06-19', 'Mantenimiento sistema eléctrico', 'Pendiente'),
(43, '2025-06-19', 'Chequeo de luces traseras', 'Pendiente'),
(44, '2025-06-19', 'Latonería: ruidos al frenar', 'Pendiente'),
(45, '2025-06-19', 'Latonería: vibraciones en carretera', 'Pendiente'),
(46, '2025-06-19', 'Ajuste de válvulas', 'Pendiente'),
(47, '2025-06-19', 'Cambio de farolas y pintura frontal', 'Pendiente'),
(48, '2025-06-19', 'Diagnóstico por consumo de aceite', 'Pendiente'),
(49, '2025-06-19', 'Revisión del sistema ABS', 'Pendiente'),
(50, '2025-06-19', 'Inspección de fugas de aceite', 'Pendiente');

--13. ventas
INSERT INTO ventas (fecha_venta, id_cliente, id_empleado, id_tipo_venta, subtotal, impuestos, total_venta, estado) VALUES
('2025-06-10', 1, 2, 1, 500000, 95000, 595000, 'Pagado'),
('2025-06-11', 2, 3, 2, 300000, 57000, 357000, 'Pendiente'),
('2025-06-12', 3, 4, 1, 450000, 85500, 535500, 'Pagado'),
('2025-06-13', 4, 1, 3, 700000, 133000, 833000, 'Pendiente'),
('2025-06-14', 5, 5, 2, 250000, 47500, 297500, 'Anulado');

--14. detalle_factura
INSERT INTO detalle_factura (id_venta, id_servicio, cantidad, precio_unitario, id_impuesto, valor_impuesto, valor_total, id_estado) VALUES
(1, 2, 1, 500000, 1, 95000, 595000, 1),
(2, 3, 2, 300000, 1, 57000, 357000, 2),
(3, 4, 1, 450000, 1, 85500, 535500, 1),
(4, 1, 3, 700000, 1, 133000, 833000, 2),
(5, 5, 2, 250000, 1, 47500, 297500, 3);

--15. historial_servicios
INSERT INTO historial_servicios (id_vehiculo, id_servicio, fecha_servicio, descripcion, id_estado) VALUES
(1, 1, '2024-01-05 08:30:00', 'Lavado completo exterior e interior', 1),
(2, 2, '2024-01-10 09:00:00', 'Revisión y cambio de neumáticos', 2),
(3, 3, '2024-01-15 10:45:00', 'Cambio de aceite y filtro de motor', 1),
(4, 4, '2024-01-20 11:15:00', 'Alineación y balanceo', 3),
(5, 5, '2024-01-25 13:30:00', 'Revisión del sistema de frenos', 1),
(6, 1, '2024-02-01 14:10:00', 'Lavado con cera especial', 2),
(7, 2, '2024-02-05 15:00:00', 'Cambio de batería', 1),
(8, 3, '2024-02-10 08:45:00', 'Revisión del aire acondicionado', 3),
(9, 4, '2024-02-15 10:30:00', 'Cambio de bujías', 1),
(10, 5, '2024-02-20 16:15:00', 'Revisión de suspensión', 1),
(11, 4, '2024-01-11 15:00:00', '7. Reparación de golpe leve en maletero', 1),
(12, 2, '2024-03-01 09:00:00', 'Instalación de luces LED', 2),
(13, 3, '2024-03-05 11:00:00', 'Mantenimiento preventivo completo', 1),
(14, 4, '2024-03-10 12:00:00', 'Revisión de motor por ruido extraño', 3),
(15, 5, '2024-03-15 13:30:00', 'Cambio de correa de distribución', 2),
(16, 1, '2024-03-20 15:00:00', 'Lavado ecológico con productos biodegradables', 1),
(17, 2, '2024-03-25 16:00:00', 'Sustitución de faros', 2),
(18, 3, '2024-03-30 17:00:00', 'Revisión de dirección hidráulica', 3),
(19, 4, '2024-04-05 08:00:00', 'Cambio de filtro de aire', 1),
(20, 5, '2024-04-10 10:00:00', 'Inspección de sistema eléctrico', 1),
(21, 1, '2024-04-15 12:00:00', 'Lavado y aspirado rápido', 2),
(22, 4, '2024-01-06 09:00:00', '2. Pintura completa del capó', 2),
(23, 3, '2024-04-20 13:00:00', 'Revisión general previa a viaje largo', 1),
(24, 4, '2024-04-25 14:00:00', 'Cambio de líquido de frenos', 2),
(25, 5, '2024-04-30 15:00:00', 'Instalación de sensores de reversa', 3),
(26, 1, '2024-05-05 16:00:00', 'Lavado con aplicación de protector UV', 1),
(27, 2, '2024-05-10 17:00:00', 'Revisión de caja de cambios automática', 2),
(28, 3, '2024-05-15 09:30:00', 'Cambio de aceite de transmisión', 1),
(29, 4, '2024-05-20 11:00:00', 'Revisión de frenos ABS', 3),
(30, 5, '2024-05-25 13:00:00', 'Sustitución de mangueras del radiador', 1),
(31, 1, '2024-05-30 14:30:00', 'Lavado con limpieza de tapicería', 2),
(32, 2, '2024-06-01 16:00:00', 'Revisión y recarga del aire acondicionado', 1),
(33, 4, '2024-01-14 16:15:00', '10. Pintura completa del vehículo', 1),
(34, 4, '2024-06-05 08:00:00', 'Revisión del tren delantero', 3),
(35, 5, '2024-06-10 09:30:00', 'Sustitución del alternador', 2),
(36, 1, '2024-06-15 10:30:00', 'Lavado básico y aspirado', 1),
(37, 2, '2024-06-20 11:30:00', 'Cambio de aceite sintético', 2),
(38, 3, '2024-06-25 13:00:00', 'Revisión de suspensión trasera', 1),
(39, 4, '2024-06-30 14:30:00', 'Reparación de parabrisas', 3),
(40, 5, '2024-07-05 15:30:00', 'Sustitución de motor de arranque', 1),
(41, 1, '2024-07-10 16:45:00', 'Lavado completo con encerado', 1),
(42, 2, '2024-07-15 08:15:00', 'Revisión del sistema eléctrico', 2),
(43, 3, '2024-07-20 09:45:00', 'Revisión general del vehículo', 1);
(45, 4, '2024-01-18 13:30:00', '14. Retoque de pintura de retrovisores', 2),
(46, 4, '2024-01-19 15:00:00', '15. Eliminación de rayones en portón trasero', 1),
(47, 4, '2024-01-20 16:00:00', '16. Reparación y pintura de faldones laterales', 2),
(48, 4, '2024-01-21 17:00:00', '17. Corrección de burbujas en pintura', 3),
(49, 4, '2024-01-22 08:00:00', '18. Pintura de guardabarros delantero izquierdo', 1),
(50, 4, '2024-01-23 10:00:00', '19. Detallado y retoques menores de pintura', 1),

--16. pagos
INSERT INTO pagos (id_venta, metodo_pago, monto_pagado, fecha_pago, observaciones) VALUES
(1, 'Efectivo', 250000.00, '2024-01-10 10:15:00', 'Pago completo en efectivo'),
(2, 'Tarjeta de crédito', 120000.00, '2024-01-12 14:30:00', 'Pagado con tarjeta VISA'),
(3, 'Transferencia bancaria', 180000.00, '2024-01-15 09:45:00', 'Transferencia desde Banco Nacional'),
(4, 'Tarjeta de débito', 95000.00, '2024-01-18 11:20:00', 'Pago parcial, pendiente saldo'),
(5, 'Efectivo', 300000.00, '2024-01-20 13:00:00', 'Pago completo sin observaciones'),
(6, 'Transferencia bancaria', 215000.00, '2024-01-23 15:10:00', 'Pago confirmado por WhatsApp'),
(7, 'Tarjeta de crédito', 150000.00, '2024-01-25 16:30:00', 'Pago a meses sin intereses'),
(8, 'Efectivo', 275000.00, '2024-01-28 17:00:00', 'Cliente entregó factura con pago'),
(9, 'Tarjeta de débito', 110000.00, '2024-01-30 09:40:00', 'Pago con tarjeta MasterCard'),
(10, 'Transferencia bancaria', 190000.00, '2024-02-01 10:25:00', 'Transferencia desde cuenta empresarial'),
(11, 'Efectivo', 100000.00, '2024-02-03 11:15:00', 'Anticipo inicial'),
(12, 'Tarjeta de crédito', 220000.00, '2024-02-05 12:00:00', 'Pago final'),
(13, 'Transferencia bancaria', 135000.00, '2024-02-06 14:45:00', 'Comprobante enviado por correo'),
(14, 'Efectivo', 80000.00, '2024-02-08 16:00:00', 'Entrega parcial'),
(15, 'Tarjeta de crédito', 250000.00, '2024-02-10 17:30:00', 'Sin observaciones'),
(16, 'Transferencia bancaria', 140000.00, '2024-02-12 08:15:00', 'Confirmado vía app bancaria'),
(17, 'Efectivo', 105000.00, '2024-02-14 09:30:00', 'Pagado en caja'),
(18, 'Tarjeta de débito', 130000.00, '2024-02-15 10:45:00', 'Pagado por terminal bancaria'),
(19, 'Transferencia bancaria', 230000.00, '2024-02-16 12:20:00', 'Pago total'),
(20, 'Efectivo', 175000.00, '2024-02-18 13:10:00', 'Pagado directamente en tienda');

--17. configuracion_taller
INSERT INTO configuracion_taller (nombre_taller, nit, direccion, telefono, correo, porcentaje_iva) VALUES
('Mechanix Taller Automotriz', '800024507-7', 'Calle 134 #46-34, Bogotá, Cundinamarca', '3104567890', 'contacto@mechanix.com', 19.00);

--18. bitacora_usuarios
INSERT INTO bitacora_usuarios (id_usuario, accion, fecha, ip_usuario) VALUES
(1, 'Inicio de sesión exitoso', '2024-06-01 08:15:23', '192.168.1.10'),
(2, 'Modificó datos del cliente', '2024-06-01 09:05:47', '192.168.1.11'),
(3, 'Registró nueva venta', '2024-06-01 10:22:11', '192.168.1.12'),
(1, 'Cerró sesión', '2024-06-01 11:30:55', '192.168.1.10'),
(4, 'Eliminó un registro de repuesto', '2024-06-02 08:45:09', '192.168.1.13'),
(5, 'Actualizó configuración del taller', '2024-06-02 09:20:35', '192.168.1.14'),
(3, 'Agregó nuevo repuesto', '2024-06-02 10:12:18', '192.168.1.12'),
(2, 'Falló intento de inicio de sesión', '2024-06-02 11:50:00', '192.168.1.11'),
(4, 'Cambió su contraseña', '2024-06-03 08:40:44', '192.168.1.13'),
(1, 'Visualizó informe de ventas', '2024-06-03 09:55:27', '192.168.1.10');

--19. repuestos
INSERT INTO repuestos (nombre_repuesto, descripcion, stock, precio_unitario, id_proveedor, estado) VALUES
('Filtro de aceite', 'Filtro para motor compatible con vehículos livianos', 50, 18000.00, 1, 'Activo'),
('Bujía NGK', 'Bujía estándar para motores de gasolina', 100, 12000.00, 2, 'Activo'),
('Pastillas de freno delanteras', 'Juego de pastillas para frenos de disco', 40, 85000.00, 3, 'Activo'),
('Aceite 10W-30', 'Aceite semisintético para motor, presentación 4L', 30, 55000.00, 1, 'Activo'),
('Filtro de aire', 'Filtro de aire de alto flujo, lavable', 25, 30000.00, 4, 'Activo'),
('Correa de distribución', 'Correa compatible con motores 1.6L a 2.0L', 15, 95000.00, 2, 'Activo'),
('Amortiguador delantero', 'Amortiguador hidráulico para suspensión delantera', 10, 120000.00, 5, 'Activo'),
('Batería 12V 60Ah', 'Batería libre de mantenimiento para automóvil', 20, 280000.00, 1, 'Activo'),
('Sensor de oxígeno', 'Sensor para sistema de escape OBD2', 12, 145000.00, 3, 'Activo'),
('Limpiaparabrisas', 'Juego de escobillas delanteras de 20 y 22 pulgadas', 60, 25000.00, 4, 'Activo');

