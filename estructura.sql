-- CREACION DE LAS TABLAS

-- 1. TABLAS SIN FORANEAS, SE EJECUTAN PRIMERO

-- Tabla de clientes
DROP TABLE IF EXISTS clientes;
CREATE TABLE clientes (
    cliente_id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla categorias
DROP TABLE IF EXISTS categorias;
CREATE TABLE categorias (
    categoria_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT
);

-- Tabla provincias
DROP TABLE IF EXISTS provincias;
CREATE TABLE provincias (
    provincia_id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);


-- 2. SE EJECUTA LA CREACION DE LA TABLA DE PRODUCTOS

-- Tabla de productos
DROP TABLE IF EXISTS productos;
CREATE TABLE productos (
    producto_id SERIAL PRIMARY KEY,
	categoria_id INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio NUMERIC(10, 2) NOT NULL,
    stock INT NOT NULL,
	atributos JSONB,
	CONSTRAINT chk_precio_positivo CHECK (precio > 0),
    CONSTRAINT chk_stock_valido    CHECK (stock >= 0),
	CONSTRAINT fk_productos_cat
        FOREIGN KEY (categoria_id) REFERENCES categorias(categoria_id)
		ON DELETE RESTRICT -- evita borrar una categoria si tiene productos
);

-- 3. SE EJECUTA LA CREACION DE PEDIDOS

-- Tabla de pedidos
DROP TABLE IF EXISTS pedidos;
CREATE TABLE pedidos (
    pedido_id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
	provincia_id INT NOT NULL,
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'Pendiente',
    total NUMERIC(10, 2) NOT NULL,
	CONSTRAINT fk_pedidos_cli
		FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
		ON DELETE RESTRICT, -- evita que se borre un cliente que hizo algun pedido
	CONSTRAINT fk_pedidos_provincia
        FOREIGN KEY (provincia_id) REFERENCES provincias(provincia_id)
        ON DELETE RESTRICT, -- evita borrar una provincia con algun pedido vinculado
	CONSTRAINT chk_total_valido CHECK (total > 0),
	CONSTRAINT chk_estado_pedido_valido
        CHECK (estado IN ('Cancelado', 'Enviado', 'Pendiente', 'Completado'))
);

-- 4. POR ULTIMO SE EJECUTA LA CREACION DE DETALLE_PEDIDO

-- Tabla de detalle de pedido (relación muchos a muchos entre pedidos y productos)
DROP TABLE IF EXISTS detalle_pedido;
CREATE TABLE detalle_pedido (
    detalle_id SERIAL PRIMARY KEY,
    pedido_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario NUMERIC(10, 2) NOT NULL,
	CONSTRAINT chk_cantidad_valido CHECK (cantidad > 0),
	CONSTRAINT chk_preciounit_valido CHECK (precio_unitario >= 0),
	CONSTRAINT fk_detpedido_pedidos
		FOREIGN KEY (pedido_id) REFERENCES pedidos(pedido_id)
		ON DELETE CASCADE, -- borra los detalles si se borra un pedido
	CONSTRAINT fk_detpedido_prod
		FOREIGN KEY (producto_id) REFERENCES productos(producto_id)
		ON DELETE RESTRICT -- impide borrar un producto si aparece en un pedido
	
);

-- 5. INSERCIONES EN LAS TABLAS

-- INSERTS para Provincias
INSERT INTO provincias (nombre) VALUES
('Buenos Aires'),
('Ciudad Autónoma de Buenos Aires'),
('Catamarca'),
('Chaco'),
('Chubut'),
('Córdoba'),
('Corrientes'),
('Entre Ríos'),
('Formosa'),
('Jujuy'),
('La Pampa'),
('La Rioja'),
('Mendoza'),
('Misiones'),
('Neuquén'),
('Río Negro'),
('Salta'),
('San Juan'),
('San Luis'),
('Santa Cruz'),
('Santa Fe'),
('Santiago del Estero'),
('Tierra del Fuego'),
('Tucumán');


-- INSERTS para Categorías
INSERT INTO categorias (nombre, descripcion) VALUES
('Electrónica', 'Dispositivos electrónicos, periféricos y accesorios de tecnología'),
('Ropa y Calzado', 'Prenda de vestir, indumentaria deportiva y calzado'),
('Hogar y Jardín', 'Artículos de decoración, muebles y utensilios del hogar');


-- INSERTS para Clientes
INSERT INTO clientes (nombre, apellido, email, telefono) VALUES
('Martín', 'Gómez', 'martin.gomez@example.com', '+54 387 455-1234'),
('Lucía', 'Fernández', 'lucia.f@example.com', '+54 11 6123-4567'),
('Gonzalo', 'Álvarez', 'gonzalo.alvarez@example.com', '+54 351 987-6543'),
('Sofia', 'Martínez', 'sofia.m@example.com', NULL),
('Joaquín', 'Pérez', 'joaquin.perez@example.com', '+54 387 412-3456'),
('Mariana', 'López', 'mariana.lopez@example.com', '+54 11 5544-3322'),
('Matías', 'Romero', 'matias.romero@example.com', '+54 351 234-5678'),
('Camila', 'Díaz', 'camila.diaz@example.com', NULL),
('Nicolás', 'Sosa', 'nicolas.sosa@example.com', '+54 381 678-9012'),
('Valentina', 'Torres', 'valentina.torres@example.com', '+54 261 345-6789'),
('Lucas', 'Benítez', 'lucas.benitez@example.com', '+54 342 890-1234'),
('Florencia', 'Acosta', 'florencia.acosta@example.com', NULL),
('Facundo', 'Medina', 'facundo.medina@example.com', '+54 299 456-7890'),
('Agustina', 'Herrera', 'agustina.herrera@example.com', '+54 387 521-9876'),
('Diego', 'Castro', 'diego.castro@example.com', '+54 11 4433-2211'),
('Micaela', 'Ríos', 'micaela.rios@example.com', '+54 379 123-4567'),
('Tomás', 'Giménez', 'tomas.gimenez@example.com', NULL),
('Paula', 'Mendoza', 'paula.mendoza@example.com', '+54 351 876-5432'),
('Santiago', 'Peralta', 'santiago.peralta@example.com', '+54 388 654-3210'),
('Luciana', 'Sánchez', 'luciana.sanchez@example.com', '+54 223 987-1234'),
('Gabriel', 'Rojas', 'gabriel.rojas@example.com', '+54 264 321-7654'),
('Carolina', 'Molina', 'carolina.molina@example.com', NULL),
('Emanuel', 'Cáceres', 'emanuel.caceres@example.com', '+54 387 611-2233'),
('Daniela', 'Suárez', 'daniela.suarez@example.com', '+54 11 6890-5432');


-- INSERTS para Productos
INSERT INTO productos (categoria_id, nombre, descripcion, precio, stock, atributos) VALUES
(1, 'Auriculares Wireless Over-Ear', 'Auriculares con cancelación activa de ruido', 85000.00, 15, 
   '{"marca": "SoundPulse", "color": "Negro", "inalambrico": true, "garantia_meses": 12}'),
   
(1, 'Teclado Mecánico RGB', 'Teclado para gaming con switches rojos silenciosos', 45000.00, 30, 
   '{"marca": "KeyMaster", "idioma": "Español", "tipo_switch": "Red", "retroiluminado": true}'),

(2, 'Zapatillas Deportivas Running', 'Zapatillas livianas para correr de alto impacto', 62000.00, 20, 
   '{"marca": "RunFast", "talle": 41, "color": "Azul/Gris", "genero": "Unisex"}'),

(2, 'Campera Impermeable Trekking', 'Campera abrigo térmico con protección para lluvia', 95000.00, 8, 
   '{"marca": "MountainX", "talle": "L", "material": "Gore-Tex", "color": "Verde Oliva"}'),

(3, 'Lámpara de Escritorio LED', 'Lámpara regulable en intensidad con puerto de carga USB', 18500.00, 50, 
   '{"marca": "LumiHome", "potencia_watts": 10, "puertos_usb": 1, "temperatura_color": "Cálida/Fría"}'),

(1, 'Monitor Gaming 27" 165Hz IPS', 'Monitor Full HD con tiempo de respuesta de 1ms y compatibilidad FreeSync', 245000.00, 12, 
   '{"marca": "ViewSonic", "tamano_pantalla": "27 pulgadas", "tasa_refresco": "165Hz", "resolucion": "1920x1080", "tipo_panel": "IPS"}'),

(1, 'Notebook Pro 15.6" i7 16GB', 'Computadora portátil de alto rendimiento con disco SSD de 512GB', 890000.00, 6, 
   '{"marca": "TechBrand", "procesador": "Intel Core i7", "ram_gb": 16, "almacenamiento_gb": 512, "peso_kg": 1.8}'),

(1, 'Mouse Gamer Ergonómico 16000 DPI', 'Mouse óptico programable con retroiluminación RGB y 7 botones', 32000.00, 25, 
   '{"marca": "HyperGlide", "dpi_maximo": 16000, "inalambrico": false, "peso_ajustable": true}'),

(1, 'Joystick Inalámbrico Bluetooth', 'Control de mandos multiplataforma compatible con PC, Android y consolas', 48000.00, 18, 
   '{"marca": "GamePadX", "autonomia_horas": 10, "conexion": "Bluetooth 5.0", "vibracion": true}'),

(1, 'Silla Gamer Ergonómica Reclinable', 'Silla de escritorio con apoyabrazos 3D y almohadilla lumbar', 198000.00, 9, 
   '{"marca": "ProSeat", "material": "Cuero Sintético", "peso_max_kg": 150, "reclinable_grados": 180}'),

(1, 'Webcam Full HD 1080p', 'Cámara web con micrófono estéreo integrado para streaming y videollamadas', 28500.00, 35, 
   '{"marca": "VisionTech", "resolucion": "1080p", "fps": 30, "microfono_integrado": true}'),

(1, 'Disco Rígido Externo 2TB USB 3.0', 'Almacenamiento portátil resistente a impactos', 78000.00, 22, 
   '{"marca": "DataVault", "capacidad_tb": 2, "interfaz": "USB 3.0", "factor_forma": "2.5 pulgadas"}'),

(1, 'Micrófono Condensador USB', 'Micrófono de estudio con patrón polar cardioide y filtro antipop', 54000.00, 14, 
   '{"marca": "AudioMaster", "patron_polar": "Cardioide", "conexion": "USB-C", "tripode_incluido": true}'),

(1, 'Placa de Video RTX 4060 8GB', 'Tarjeta gráfica para gaming en alta definición y renderizado', 520000.00, 5, 
   '{"marca": "GigaChip", "vram_gb": 8, "tipo_memoria": "GDDR6", "consumo_watts": 115}'),

(1, 'Cargador Rápido GaN 65W USB-C', 'Cargador ultracompacto para laptops, tablets y smartphones', 22000.00, 40, 
   '{"marca": "PowerFast", "potencia_watts": 65, "puertos": 3, "tecnologia": "GaN"}'),

(2, 'Remera Algodón Básica Unisex', 'Remera 100% algodón peinado de calce clásico', 12500.00, 60, 
   '{"marca": "UrbanWear", "talle": "M", "color": "Negro", "composicion": "100% Algodón"}'),

(2, 'Pantalón Jean Slim Fit', 'Pantalón de jean elastizado con corte moderno', 38000.00, 25, 
   '{"marca": "DenimCo", "talle": 42, "color": "Azul Oscuro", "corte": "Slim Fit"}'),

(2, 'Buzos Oversize con Capucha', 'Buzo de friso invisible térmico con bolsillo canguro', 32000.00, 30, 
   '{"marca": "StreetStyle", "talle": "XL", "color": "Gris Topo", "con_capucha": true}'),

(2, 'Zapatillas Urbanas Canvas', 'Calzado casual de lona con suela de goma antideslizante', 45000.00, 20, 
   '{"marca": "CityWalk", "talle": 39, "color": "Blanco", "material": "Lona"}'),

(2, 'Camisa Formal Manga Larga', 'Camisa entallada apta para eventos institucionales u oficina', 29000.00, 15, 
   '{"marca": "Elegance", "talle": "L", "color": "Azul Francia", "corte": "Custom Fit"}'),

(2, 'Short Deportivo Secado Rápido', 'Pantalón corto con cintura elastizada y bolsillos con cierre', 16500.00, 40, 
   '{"marca": "RunFast", "talle": "M", "color": "Negro", "bolsillo_cierre": true}'),

(2, 'Botas de Montaña Trekking', 'Calzado impermeable reforzado con suela de agarre multiterreno', 89000.00, 10, 
   '{"marca": "MountainX", "talle": 43, "color": "Marrón", "impermeable": true}'),

(3, 'Set de Herramientas Jardinería 5 Pzas', 'Incluye pala, trasplantador, rastrillo, tijera de podar y guantes', 24000.00, 18, 
   '{"marca": "GardenPro", "piezas": 5, "material": "Acero Inoxidable", "estuche_incluido": true}'),

(3, 'Mesa de Centro Estilo Industrial', 'Mesa ratona con estructura metálica y tapa de madera maciza', 65000.00, 7, 
   '{"marca": "WoodDesign", "dimensiones_cm": "100x60x45", "material_tapa": "Madera de Paraíso", "requiere_armado": false}'),

(3, 'Juego de Sabanas 2 1/2 Plazas 600 Hilos', 'Set completo de sábanas ultra suaves antipeeling', 34000.00, 22, 
   '{"marca": "DreamTextil", "plazas": "2 y 1/2", "hilos": 600, "color": "Blanco"}'),

(3, 'Podadora de Césped Eléctrica 1200W', 'Cortadora de césped compacta con bolsa recolectora de 30 litros', 115000.00, 6, 
   '{"marca": "GreenYard", "potencia_watts": 1200, "ancho_corte_cm": 32, "capacidad_bolsa_lts": 30}'),

(3, 'Robot Aspiradora Inteligente', 'Aspiradora y trapeadora automática con mapeo de ambientes por sensor', 210000.00, 8, 
   '{"marca": "CleanBot", "autonomia_minutos": 110, "conexion_wifi": true, "soporta_trapeado": true}'),

(3, 'Juego de Ollas Antiadherentes 5 Piezas', 'Batería de cocina con recubrimiento cerámico y tapas de vidrio templado', 72000.00, 15, 
   '{"marca": "ChefMaster", "piezas": 5, "antiadherente": "Cerámico", "apto_lavavajillas": true}'),

(3, 'Maceta Rotomoldeada Nro 40', 'Maceta moderna súper liviana y resistente a rayos UV para exterior', 14500.00, 30, 
   '{"marca": "EcoPlast", "diametro_cm": 40, "color": "Gris Cemento", "apto_exterior": true}'),

(3, 'Manguera Expandible 15 Metros', 'Manguera flexible de jardín con pistola de riego de 7 posiciones', 18000.00, 25, 
   '{"marca": "GardenPro", "longitud_max_m": 15, "posiciones_pistola": 7, "material": "Látex/Nylon"}');

-- INSERTS para Pedidos
INSERT INTO pedidos (cliente_id, provincia_id, estado, total) VALUES
(17, 2, 'Completado', 85000.00),
(2, 3, 'Enviado', 169000.00),
(6, 4, 'Pendiente', 142500.00),
(1, 17, 'Completado', 18500.00),
(2, 2, 'Enviado', 85000.00),
(3, 6, 'Completado', 285000.00),
(4, 1, 'Pendiente', 80500.00),
(5, 24, 'Completado', 134000.00),
(6, 8, 'Enviado', 45000.00),
(7, 21, 'Completado', 113990.00),
(8, 11, 'Cancelado', 95000.00),
(9, 15, 'Completado', 890000.00),
(10, 17, 'Enviado', 37000.00),
(11, 1, 'Completado', 120000.00),
(12, 7, 'Pendiente', 26500.00),
(13, 6, 'Completado', 62000.00),
(14, 6, 'Completado', 16500.00),
(15, 10, 'Enviado', 1450000.00),
(16, 20, 'Completado', 42000.00),
(17, 18, 'Completado', 310000.00),
(18, 1, 'Cancelado', 54000.00),
(19, 17, 'Enviado', 19800.00),
(20, 2, 'Completado', 180000.00),
(21, 21, 'Pendiente', 48000.00),
(22, 14, 'Completado', 115000.00),
(1, 17, 'Completado', 210000.00),
(2, 2, 'Enviado', 38000.00),
(3, 6, 'Completado', 137000.00),
(4, 1, 'Completado', 88000.00),
(5, 24, 'Enviado', 78000.00),
(6, 8, 'Completado', 18500.00),
(7, 21, 'Cancelado', 62000.00),
(8, 11, 'Completado', 320000.00),
(9, 15, 'Pendiente', 22500.00),
(10, 17, 'Completado', 92000.00),
(11, 1, 'Completado', 59000.00),
(12, 7, 'Enviado', 34000.00),
(13, 6, 'Completado', 240000.00),
(14, 6, 'Completado', 45000.00),
(15, 10, 'Pendiente', 14200.00),
(16, 20, 'Completado', 130000.00),
(17, 18, 'Enviado', 18500.00),
(18, 1, 'Completado', 95000.00),
(19, 17, 'Completado', 285000.00),
(20, 2, 'Cancelado', 48000.00),
(21, 21, 'Completado', 22500.00),
(22, 14, 'Enviado', 85000.00),
(1, 17, 'Completado', 108000.00),
(2, 2, 'Pendiente', 62000.00),
(3, 6, 'Completado', 37000.00),
(4, 1, 'Completado', 1450000.00),
(5, 24, 'Enviado', 115000.00),
(6, 8, 'Completado', 49990.00),
(7, 21, 'Completado', 88000.00),
(8, 11, 'Completado', 18500.00),
(9, 15, 'Enviado', 14200.00),
(10, 17, 'Cancelado', 210000.00),
(11, 1, 'Completado', 54000.00),
(12, 7, 'Pendiente', 38000.00),
(13, 6, 'Completado', 890000.00),
(14, 6, 'Completado', 19800.00),
(15, 10, 'Enviado', 26500.00),
(16, 20, 'Completado', 92000.00),
(17, 18, 'Completado', 78000.00),
(18, 1, 'Enviado', 42000.00),
(19, 17, 'Completado', 310000.00),
(20, 2, 'Completado', 124000.00),
(21, 21, 'Pendiente', 85000.00),
(22, 14, 'Completado', 59000.00),
(1, 17, 'Completado', 240000.00),
(2, 2, 'Enviado', 320000.00),
(3, 6, 'Cancelado', 45000.00),
(4, 1, 'Completado', 18500.00),
(5, 24, 'Completado', 62000.00),
(6, 8, 'Pendiente', 115000.00),
(7, 21, 'Completado', 285000.00),
(8, 11, 'Enviado', 88000.00),
(9, 15, 'Completado', 22500.00),
(10, 17, 'Completado', 14200.00),
(11, 1, 'Completado', 78000.00),
(12, 7, 'Enviado', 49990.00),
(13, 6, 'Pendiente', 38000.00),
(14, 6, 'Completado', 54000.00),
(15, 10, 'Completado', 95000.00),
(16, 20, 'Completado', 1450000.00),
(17, 18, 'Enviado', 18500.00),
(18, 1, 'Cancelado', 210000.00),
(19, 17, 'Completado', 42000.00),
(20, 2, 'Completado', 19800.00),
(21, 21, 'Completado', 85000.00),
(22, 14, 'Enviado', 310000.00),
(1, 17, 'Completado', 26500.00),
(2, 2, 'Completado', 92000.00),
(3, 6, 'Pendiente', 240000.00),
(4, 1, 'Completado', 62000.00),
(5, 24, 'Enviado', 115000.00),
(6, 8, 'Completado', 88000.00),
(7, 21, 'Completado', 285000.00),
(8, 11, 'Completado', 45000.00),
(9, 15, 'Completado', 18500.00),
(10, 17, 'Enviado', 78000.00),
(11, 1, 'Completado', 38000.00),
(12, 7, 'Completado', 54000.00);


-- INSERTS para Detalle de Pedido
INSERT INTO detalle_pedido (pedido_id, producto_id, cantidad, precio_unitario) VALUES
(1, 1, 1, 85000.00),
(2, 2, 1, 45000.00),
(2, 4, 1, 95000.00),
(3, 3, 2, 62000.00),
(3, 5, 1, 18500.00),
(4, 5, 1, 18500.00),
(5, 1, 1, 85000.00),
(6, 10, 1, 285000.00),
(7, 6, 1, 22500.00),
(7, 20, 1, 18500.00),
(7, 21, 1, 39500.00),
(8, 2, 1, 45000.00),
(8, 21, 1, 42000.00),
(8, 22, 1, 47000.00),
(9, 2, 1, 45000.00),
(10, 9, 1, 49990.00),
(10, 17, 1, 64000.00),
(11, 4, 1, 95000.00),
(12, 11, 1, 890000.00),
(13, 19, 2, 18500.00),
(14, 17, 1, 62000.00),
(14, 21, 1, 58000.00),
(15, 29, 1, 26500.00),
(16, 3, 1, 62000.00),
(17, 25, 1, 16500.00),
(18, 12, 1, 1450000.00),
(19, 14, 1, 42000.00),
(20, 27, 1, 310000.00),
(21, 15, 1, 54000.00),
(22, 30, 1, 19800.00),
(23, 2, 4, 45000.00),
(24, 22, 1, 48000.00),
(25, 23, 1, 115000.00),
(26, 18, 1, 210000.00),
(27, 8, 1, 38000.00),
(28, 2, 1, 45000.00),
(28, 21, 1, 42000.00),
(28, 23, 1, 50000.00),
(29, 24, 1, 88000.00),
(30, 13, 1, 78000.00),
(31, 5, 1, 18500.00),
(32, 3, 1, 62000.00),
(33, 16, 1, 320000.00),
(34, 6, 1, 22500.00),
(35, 26, 1, 92000.00),
(36, 17, 1, 59000.00),
(37, 21, 1, 34000.00),
(38, 28, 1, 240000.00),
(39, 2, 1, 45000.00),
(40, 7, 1, 14200.00),
(41, 2, 2, 45000.00),
(41, 14, 1, 40000.00),
(42, 19, 1, 18500.00),
(43, 4, 1, 95000.00),
(44, 10, 1, 285000.00),
(45, 22, 1, 48000.00),
(46, 6, 1, 22500.00),
(47, 1, 1, 85000.00),
(48, 2, 2, 45000.00),
(48, 19, 1, 18000.00),
(49, 3, 1, 62000.00),
(50, 19, 2, 18500.00),
(51, 12, 1, 1450000.00),
(52, 23, 1, 115000.00),
(53, 9, 1, 49990.00),
(54, 24, 1, 88000.00),
(55, 5, 1, 18500.00),
(56, 7, 1, 14200.00),
(57, 18, 1, 210000.00),
(58, 15, 1, 54000.00),
(59, 8, 1, 38000.00),
(60, 11, 1, 890000.00),
(61, 30, 1, 19800.00),
(62, 29, 1, 26500.00),
(63, 26, 1, 92000.00),
(64, 13, 1, 78000.00),
(65, 14, 1, 42000.00),
(66, 27, 1, 310000.00),
(67, 3, 2, 62000.00),
(68, 1, 1, 85000.00),
(69, 17, 1, 59000.00),
(70, 28, 1, 240000.00),
(71, 16, 1, 320000.00),
(72, 2, 1, 45000.00),
(73, 5, 1, 18500.00),
(74, 3, 1, 62000.00),
(75, 23, 1, 115000.00),
(76, 10, 1, 285000.00),
(77, 24, 1, 88000.00),
(78, 6, 1, 22500.00),
(79, 7, 1, 14200.00),
(80, 13, 1, 78000.00),
(81, 9, 1, 49990.00),
(82, 8, 1, 38000.00),
(83, 15, 1, 54000.00),
(84, 4, 1, 95000.00),
(85, 12, 1, 1450000.00),
(86, 19, 1, 18500.00),
(87, 18, 1, 210000.00),
(88, 14, 1, 42000.00),
(89, 30, 1, 19800.00),
(90, 1, 1, 85000.00),
(91, 27, 1, 310000.00),
(92, 29, 1, 26500.00),
(93, 26, 1, 92000.00),
(94, 28, 1, 240000.00),
(95, 3, 1, 62000.00),
(96, 23, 1, 115000.00),
(97, 24, 1, 88000.00),
(98, 10, 1, 285000.00),
(99, 2, 1, 45000.00),
(100, 5, 1, 18500.00),
(101, 13, 1, 78000.00),
(102, 8, 1, 38000.00),
(103, 15, 1, 54000.00);
