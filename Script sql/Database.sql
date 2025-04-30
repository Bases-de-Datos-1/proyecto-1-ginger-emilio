-- ==============================================================
--  Proyecto      : Sistema de Gestión Hotelera
--  Script        : Creación de Tablas Base
--  Base de Datos : GestionHotelera
--  Autor         : Emilio F. & Ginger R.
--  Fecha         : 27/04/2025
--
--  Descripción:
--      Script para crear las tablas principales del sistema
--      de gestión hotelera, abarcando establecimientos,
--      habitaciones, clientes, reservaciones, facturación
--      y servicios de recreación.
-- ==============================================================

CREATE DATABASE GestionHotelera;
GO

USE GestionHotelera;
GO

-- =============================
-- Tabla: Establecimiento_Tipo
-- =============================
CREATE TABLE Establecimiento_Tipo (
    id_establecimiento_tipo INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL
);
GO

-- =============================
-- Tabla: Establecimiento
-- =============================
CREATE TABLE Establecimiento (
    id_establecimiento INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    cedula_juridica VARCHAR(20) NOT NULL UNIQUE,
    id_establecimiento_tipo INT NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    canton VARCHAR(50) NOT NULL,
    distrito VARCHAR(50) NOT NULL,
    barrio VARCHAR(50) NOT NULL,
    senas_exactas VARCHAR(250) NOT NULL,
    referencia_gps VARCHAR(100) NOT NULL,
    telefono1 VARCHAR(20) NOT NULL,
    telefono2 VARCHAR(20) NULL,
    telefono3 VARCHAR(20) NULL,
    correo VARCHAR(100) NOT NULL,
    url_sitio_web VARCHAR(250) NULL,

    CONSTRAINT FK_Establecimiento_Tipo
    FOREIGN KEY (id_establecimiento_tipo) REFERENCES Establecimiento_Tipo(id_establecimiento_tipo)
);
GO

-- =============================
-- Tabla: Establecimiento_Red_Social
-- =============================
CREATE TABLE Establecimiento_Red_Social (
    id_establecimiento_red_social INT PRIMARY KEY IDENTITY(1,1),
    id_establecimiento INT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    url_red_social VARCHAR(250) NOT NULL,

    CONSTRAINT FK_Establecimiento_Red_Social
    FOREIGN KEY (id_establecimiento) REFERENCES Establecimiento(id_establecimiento)
);
GO

-- =============================
-- Tabla: Establecimiento_Servicio
-- =============================
CREATE TABLE Establecimiento_Servicio (
    id_establecimiento_servicio INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(250) NULL
);
GO

-- =============================
-- Tabla: Establecimiento_Servicio_Relacion
-- =============================
CREATE TABLE Establecimiento_Servicio_Relacion (
    id_establecimiento_servicio_relacion INT PRIMARY KEY IDENTITY(1,1),
    id_establecimiento INT NOT NULL,
    id_establecimiento_servicio INT NOT NULL,

    CONSTRAINT FK_EstablecimientoServicioRelacion_Establecimiento
    FOREIGN KEY (id_establecimiento) REFERENCES Establecimiento(id_establecimiento),

    CONSTRAINT FK_EstablecimientoServicioRelacion_Servicio
    FOREIGN KEY (id_establecimiento_servicio) REFERENCES Establecimiento_Servicio(id_establecimiento_servicio)
);
GO

-- =============================
-- Tabla: Habitacion_Cama
-- =============================
CREATE TABLE Habitacion_Cama (
    id_habitacion_cama INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(250) NULL
);
GO

-- =============================
-- Tabla: Habitacion_Tipo
-- =============================
CREATE TABLE Habitacion_Tipo (
    id_habitacion_tipo INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(250) NULL,
    precio DECIMAL(10,2) NOT NULL,
    capacidad_maxima INT NOT NULL,
    id_habitacion_cama INT NOT NULL,

    CONSTRAINT FK_HabitacionTipo_Cama
    FOREIGN KEY (id_habitacion_cama) REFERENCES Habitacion_Cama(id_habitacion_cama)
);
GO

-- =============================
-- Tabla: Habitacion_Comodidad
-- =============================
CREATE TABLE Habitacion_Comodidad (
    id_habitacion_comodidad INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL
);
GO

-- =============================
-- Tabla: Habitacion_Comodidad_Relacion
-- =============================
CREATE TABLE Habitacion_Comodidad_Relacion (
    id_habitacion_comodidad_relacion INT PRIMARY KEY IDENTITY(1,1),
    id_habitacion_tipo INT NOT NULL,
    id_habitacion_comodidad INT NOT NULL,

    CONSTRAINT FK_HabitacionComodidadRelacion_Tipo
    FOREIGN KEY (id_habitacion_tipo) REFERENCES Habitacion_Tipo(id_habitacion_tipo),

    CONSTRAINT FK_HabitacionComodidadRelacion_Comodidad
    FOREIGN KEY (id_habitacion_comodidad) REFERENCES Habitacion_Comodidad(id_habitacion_comodidad)
);
GO

-- =============================
-- Tabla: Habitacion_Foto
-- =============================
CREATE TABLE Habitacion_Foto (
    id_habitacion_foto INT PRIMARY KEY IDENTITY(1,1),
    id_habitacion_tipo INT NOT NULL,
    url_foto VARCHAR(250) NOT NULL,

    CONSTRAINT FK_HabitacionFoto_Tipo
    FOREIGN KEY (id_habitacion_tipo) REFERENCES Habitacion_Tipo(id_habitacion_tipo)
);
GO

-- =============================
-- Tabla: Habitacion
-- =============================
CREATE TABLE Habitacion (
    id_habitacion INT PRIMARY KEY IDENTITY(1,1),
    id_establecimiento INT NOT NULL,
    id_habitacion_tipo INT NOT NULL,
    numero VARCHAR(20) NOT NULL,
    estado VARCHAR(20) NOT NULL,

    CONSTRAINT FK_Habitacion_Establecimiento
    FOREIGN KEY (id_establecimiento) REFERENCES Establecimiento(id_establecimiento),

    CONSTRAINT FK_Habitacion_Tipo
    FOREIGN KEY (id_habitacion_tipo) REFERENCES Habitacion_Tipo(id_habitacion_tipo)
);
GO

-- =============================
-- Tabla: Cliente_Identificacion
-- =============================
CREATE TABLE Cliente_Identificacion (
    id_cliente_identificacion INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL
);
GO

-- =============================
-- Tabla: Cliente
-- =============================
CREATE TABLE Cliente (
    id_cliente INT PRIMARY KEY IDENTITY(1,1),
    id_cliente_identificacion INT NOT NULL,
    numero_identificacion VARCHAR(50) NOT NULL UNIQUE,
    nombre VARCHAR(100) NOT NULL,
    primer_apellido VARCHAR(50) NOT NULL,
    segundo_apellido VARCHAR(50) NULL,
    fecha_nacimiento DATE NOT NULL,
    pais_residencia VARCHAR(50) NOT NULL,
    provincia VARCHAR(50) NULL,
    canton VARCHAR(50) NULL,
    distrito VARCHAR(50) NULL,
    telefono1 VARCHAR(20) NOT NULL,
    telefono2 VARCHAR(20) NULL,
    telefono3 VARCHAR(20) NULL,
    correo VARCHAR(100) NOT NULL,

    CONSTRAINT FK_Cliente_ClienteIdentificacion
    FOREIGN KEY (id_cliente_identificacion) REFERENCES Cliente_Identificacion(id_cliente_identificacion)
);
GO

-- =============================
-- Tabla: Reservacion
-- =============================
CREATE TABLE Reservacion (
    id_reservacion INT PRIMARY KEY IDENTITY(1,1),
    id_cliente INT NOT NULL,
    fecha_ingreso DATETIME NOT NULL,
	hora_ingreso TIME NOT NULL,
    fecha_salida DATETIME NOT NULL,
	hora_salida_personalizada TIME NULL,
    cantidad_personas INT NOT NULL,
    posee_vehiculo BIT NOT NULL,
    tipo_reservacion VARCHAR(20) NOT NULL CHECK (tipo_reservacion IN ('HABITACION', 'ACTIVIDAD')),

    CONSTRAINT FK_Reservacion_Cliente
    FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);
GO

-- =============================
-- Tabla: Habitacion_Reservacion_Relacion
-- =============================
CREATE TABLE Habitacion_Reservacion_Relacion (
    id_habitacion_reservacion_relacion INT PRIMARY KEY IDENTITY(1,1),
    id_habitacion INT NOT NULL,
    id_reservacion INT NOT NULL,

    CONSTRAINT FK_HabitacionReservacionRelacion_Habitacion
    FOREIGN KEY (id_habitacion) REFERENCES Habitacion(id_habitacion),

    CONSTRAINT FK_HabitacionReservacionRelacion_Reservacion
    FOREIGN KEY (id_reservacion) REFERENCES Reservacion(id_reservacion)
);
GO

-- =============================
-- Tabla: Facturacion_Metodo_Pago
-- =============================
CREATE TABLE Facturacion_Metodo_Pago (
    id_facturacion_metodo_pago INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(50) NOT NULL
);
GO

-- =============================
-- Tabla: Facturacion
-- =============================
CREATE TABLE Facturacion (
    id_facturacion INT PRIMARY KEY IDENTITY(1,1),
    id_reservacion INT NOT NULL,
    id_facturacion_metodo_pago INT NOT NULL,
    fecha_facturacion DATETIME NOT NULL,
    total DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_Facturacion_Reservacion
    FOREIGN KEY (id_reservacion) REFERENCES Reservacion(id_reservacion),

    CONSTRAINT FK_Facturacion_MetodoPago
    FOREIGN KEY (id_facturacion_metodo_pago) REFERENCES Facturacion_Metodo_Pago(id_facturacion_metodo_pago)
);
GO

-- =============================
-- Tabla: Recreacion_Tipo
-- =============================
CREATE TABLE Recreacion_Tipo (
    id_recreacion_tipo INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL
);
GO

-- =============================
-- Tabla: Recreacion_Servicio
-- =============================
CREATE TABLE Recreacion_Servicio (
    id_recreacion_servicio INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(250) NULL
);
GO

-- =============================
-- Tabla: Recreacion_Empresa
-- =============================
CREATE TABLE Recreacion_Empresa (
    id_recreacion_empresa INT PRIMARY KEY IDENTITY(1,1),
    nombre VARCHAR(100) NOT NULL,
    cedula_juridica VARCHAR(20) NOT NULL UNIQUE,
    correo VARCHAR(100) NOT NULL,
    telefono1 VARCHAR(20) NOT NULL,
    telefono2 VARCHAR(20) NULL,
    telefono3 VARCHAR(20) NULL,
    nombre_contacto VARCHAR(100) NOT NULL,
    provincia VARCHAR(50) NOT NULL,
    canton VARCHAR(50) NOT NULL,
    distrito VARCHAR(50) NOT NULL,
    senas_exactas VARCHAR(250) NOT NULL
);
GO


-- =============================
-- Tabla: Recreacion
-- =============================
CREATE TABLE Recreacion (
    id_recreacion INT PRIMARY KEY IDENTITY(1,1),
    id_recreacion_empresa INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(250) NULL,
    precio DECIMAL(10,2) NOT NULL,

    CONSTRAINT FK_Recreacion_Empresa
    FOREIGN KEY (id_recreacion_empresa) REFERENCES Recreacion_Empresa(id_recreacion_empresa)
);
GO

-- =============================
-- Tabla: Recreacion_Tipo_Relacion
-- =============================
CREATE TABLE Recreacion_Tipo_Relacion (
    id_recreacion_tipo_relacion INT PRIMARY KEY IDENTITY(1,1),
    id_recreacion INT NOT NULL,
    id_recreacion_tipo INT NOT NULL,

    CONSTRAINT FK_RecreacionTipoRelacion_Recreacion
    FOREIGN KEY (id_recreacion) REFERENCES Recreacion(id_recreacion),

    CONSTRAINT FK_RecreacionTipoRelacion_RecreacionTipo
    FOREIGN KEY (id_recreacion_tipo) REFERENCES Recreacion_Tipo(id_recreacion_tipo)
);
GO

-- =============================
-- Tabla: Recreacion_Servicio_Relacion
-- =============================
CREATE TABLE Recreacion_Servicio_Relacion (
    id_recreacion_servicio_relacion INT PRIMARY KEY IDENTITY(1,1),
    id_recreacion INT NOT NULL,
    id_recreacion_servicio INT NOT NULL,

    CONSTRAINT FK_RecreacionServicioRelacion_Recreacion
    FOREIGN KEY (id_recreacion) REFERENCES Recreacion(id_recreacion),

    CONSTRAINT FK_RecreacionServicioRelacion_RecreacionServicio
    FOREIGN KEY (id_recreacion_servicio) REFERENCES Recreacion_Servicio(id_recreacion_servicio)
);
GO

-- =============================
-- Tabla: Recreacion_Reservacion_Relacion
-- =============================
CREATE TABLE Recreacion_Reservacion_Relacion (
    id_recreacion_reservacion_relacion INT PRIMARY KEY IDENTITY(1,1),
    id_recreacion INT NOT NULL,
    id_reservacion INT NOT NULL,

    CONSTRAINT FK_RecreacionReservacionRelacion_Recreacion
    FOREIGN KEY (id_recreacion) REFERENCES Recreacion(id_recreacion),

    CONSTRAINT FK_RecreacionReservacionRelacion_Reservacion
    FOREIGN KEY (id_reservacion) REFERENCES Reservacion(id_reservacion)
);
GO
