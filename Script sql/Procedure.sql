-- ==============================================================
--  Proyecto      : Sistema de Gestión Hotelera
--  Script        : Procedimientos Almacenados
--  Base de Datos : GestionHotelera
--  Autor         : Emilio F. & Ginger R.
--  Fecha         : 29/04/2025
--
--  Descripción:
--      Script para crear procedimientos almacenados que permitan
--      realizar operaciones en todas las tablas del sistema,
--      manejando adecuadamente las relaciones entre ellas.
-- ==============================================================

USE GestionHotelera;

-- =============================================
-- Procedimientos para Establecimiento_Tipo
-- =============================================
CREATE PROCEDURE sp_AgregarEstablecimientoTipo
    @nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO Establecimiento_Tipo (nombre)
    VALUES (@nombre);
    
    SELECT SCOPE_IDENTITY() AS id_establecimiento_tipo;
END;
GO

CREATE PROCEDURE sp_ActualizarEstablecimientoTipo
    @id_establecimiento_tipo INT,
    @nombre VARCHAR(50)
AS
BEGIN
    UPDATE Establecimiento_Tipo
    SET nombre = @nombre
    WHERE id_establecimiento_tipo = @id_establecimiento_tipo;
END;
GO

CREATE PROCEDURE sp_EliminarEstablecimientoTipo
    @id_establecimiento_tipo INT
AS
BEGIN
    -- Verifica si hay establecimientos usando este tipo
    IF EXISTS (SELECT 1 FROM Establecimiento WHERE id_establecimiento_tipo = @id_establecimiento_tipo)
    BEGIN
        RAISERROR('No se puede eliminar, hay establecimientos asociados a este tipo', 16, 1);
        RETURN;
    END
    
    DELETE FROM Establecimiento_Tipo
    WHERE id_establecimiento_tipo = @id_establecimiento_tipo;
END;
GO

-- =============================================
-- Procedimientos para Establecimiento
-- =============================================
CREATE PROCEDURE sp_AgregarEstablecimiento
    @nombre VARCHAR(100),
    @cedula_juridica VARCHAR(20),
    @id_establecimiento_tipo INT,
    @provincia VARCHAR(50),
    @canton VARCHAR(50),
    @distrito VARCHAR(50),
    @barrio VARCHAR(50),
    @senas_exactas VARCHAR(250),
    @referencia_gps VARCHAR(100),
    @telefono1 VARCHAR(20),
    @telefono2 VARCHAR(20) = NULL,
    @telefono3 VARCHAR(20) = NULL,
    @correo VARCHAR(100),
    @url_sitio_web VARCHAR(250) = NULL
AS
BEGIN
    INSERT INTO Establecimiento (
        nombre, cedula_juridica, id_establecimiento_tipo,
        provincia, canton, distrito, barrio, senas_exactas, referencia_gps,
        telefono1, telefono2, telefono3, correo, url_sitio_web
    )
    VALUES (
        @nombre, @cedula_juridica, @id_establecimiento_tipo,
        @provincia, @canton, @distrito, @barrio, @senas_exactas, @referencia_gps,
        @telefono1, @telefono2, @telefono3, @correo, @url_sitio_web
    );
    
    SELECT SCOPE_IDENTITY() AS id_establecimiento;
END;
GO

CREATE PROCEDURE sp_ActualizarEstablecimiento
    @id_establecimiento INT,
    @nombre VARCHAR(100),
    @cedula_juridica VARCHAR(20),
    @id_establecimiento_tipo INT,
    @provincia VARCHAR(50),
    @canton VARCHAR(50),
    @distrito VARCHAR(50),
    @barrio VARCHAR(50),
    @senas_exactas VARCHAR(250),
    @referencia_gps VARCHAR(100),
    @telefono1 VARCHAR(20),
    @telefono2 VARCHAR(20) = NULL,
    @telefono3 VARCHAR(20) = NULL,
    @correo VARCHAR(100),
    @url_sitio_web VARCHAR(250) = NULL
AS
BEGIN
    UPDATE Establecimiento
    SET 
        nombre = @nombre,
        cedula_juridica = @cedula_juridica,
        id_establecimiento_tipo = @id_establecimiento_tipo,
        provincia = @provincia,
        canton = @canton,
        distrito = @distrito,
        barrio = @barrio,
        senas_exactas = @senas_exactas,
        referencia_gps = @referencia_gps,
        telefono1 = @telefono1,
        telefono2 = @telefono2,
        telefono3 = @telefono3,
        correo = @correo,
        url_sitio_web = @url_sitio_web
    WHERE id_establecimiento = @id_establecimiento;
END;
GO

CREATE PROCEDURE sp_EliminarEstablecimiento
    @id_establecimiento INT
AS
BEGIN
    -- Verifica si hay habitaciones en este establecimiento
    IF EXISTS (SELECT 1 FROM Habitacion WHERE id_establecimiento = @id_establecimiento)
    BEGIN
        RAISERROR('No se puede eliminar, hay habitaciones asociadas a este establecimiento', 16, 1);
        RETURN;
    END
    
    -- Elimina relaciones de redes sociales y servicios
    DELETE FROM Establecimiento_Red_Social WHERE id_establecimiento = @id_establecimiento;
    DELETE FROM Establecimiento_Servicio_Relacion WHERE id_establecimiento = @id_establecimiento;
    
    -- Elimina el establecimiento
    DELETE FROM Establecimiento
    WHERE id_establecimiento = @id_establecimiento;
END;
GO

-- =============================================
-- Procedimientos para Establecimiento_Servicio
-- =============================================
CREATE PROCEDURE sp_AgregarEstablecimientoServicio
    @nombre VARCHAR(100),
    @descripcion VARCHAR(250) = NULL
AS
BEGIN
    INSERT INTO Establecimiento_Servicio (nombre, descripcion)
    VALUES (@nombre, @descripcion);
    
    SELECT SCOPE_IDENTITY() AS id_establecimiento_servicio;
END;
GO

CREATE PROCEDURE sp_ActualizarEstablecimientoServicio
    @id_establecimiento_servicio INT,
    @nombre VARCHAR(100),
    @descripcion VARCHAR(250) = NULL
AS
BEGIN
    UPDATE Establecimiento_Servicio
    SET nombre = @nombre, descripcion = @descripcion
    WHERE id_establecimiento_servicio = @id_establecimiento_servicio;
END;
GO

CREATE PROCEDURE sp_EliminarEstablecimientoServicio
    @id_establecimiento_servicio INT
AS
BEGIN
    -- Verifica si hay establecimientos usando este servicio
    IF EXISTS (SELECT 1 FROM Establecimiento_Servicio_Relacion WHERE id_establecimiento_servicio = @id_establecimiento_servicio)
    BEGIN
        RAISERROR('No se puede eliminar, hay establecimientos asociados a este servicio', 16, 1);
        RETURN;
    END
    
    DELETE FROM Establecimiento_Servicio
    WHERE id_establecimiento_servicio = @id_establecimiento_servicio;
END;
GO

-- =============================================
-- Procedimientos para Establecimiento_Servicio_Relacion
-- =============================================
CREATE PROCEDURE sp_AgregarServicioAEstablecimiento
    @id_establecimiento INT,
    @id_establecimiento_servicio INT
AS
BEGIN
    -- Verifica que no exista ya esta relación
    IF EXISTS (SELECT 1 FROM Establecimiento_Servicio_Relacion 
               WHERE id_establecimiento = @id_establecimiento 
               AND id_establecimiento_servicio = @id_establecimiento_servicio)
    BEGIN
        RAISERROR('Este servicio ya está asociado al establecimiento', 16, 1);
        RETURN;
    END
    
    INSERT INTO Establecimiento_Servicio_Relacion (id_establecimiento, id_establecimiento_servicio)
    VALUES (@id_establecimiento, @id_establecimiento_servicio);
    
    SELECT SCOPE_IDENTITY() AS id_establecimiento_servicio_relacion;
END;
GO

CREATE PROCEDURE sp_EliminarServicioDeEstablecimiento
    @id_establecimiento INT,
    @id_establecimiento_servicio INT
AS
BEGIN
    DELETE FROM Establecimiento_Servicio_Relacion
    WHERE id_establecimiento = @id_establecimiento
    AND id_establecimiento_servicio = @id_establecimiento_servicio;
END;
GO

-- =============================================
-- Procedimientos para Habitacion_Tipo
-- =============================================
CREATE PROCEDURE sp_AgregarHabitacionTipo
    @nombre VARCHAR(100),
    @descripcion VARCHAR(250) = NULL,
    @precio DECIMAL(10,2),
    @capacidad_maxima INT,
    @id_habitacion_cama INT
AS
BEGIN
    INSERT INTO Habitacion_Tipo (nombre, descripcion, precio, capacidad_maxima, id_habitacion_cama)
    VALUES (@nombre, @descripcion, @precio, @capacidad_maxima, @id_habitacion_cama);
    
    SELECT SCOPE_IDENTITY() AS id_habitacion_tipo;
END;
GO

CREATE PROCEDURE sp_ActualizarHabitacionTipo
    @id_habitacion_tipo INT,
    @nombre VARCHAR(100),
    @descripcion VARCHAR(250) = NULL,
    @precio DECIMAL(10,2),
    @capacidad_maxima INT,
    @id_habitacion_cama INT
AS
BEGIN
    UPDATE Habitacion_Tipo
    SET 
        nombre = @nombre,
        descripcion = @descripcion,
        precio = @precio,
        capacidad_maxima = @capacidad_maxima,
        id_habitacion_cama = @id_habitacion_cama
    WHERE id_habitacion_tipo = @id_habitacion_tipo;
END;
GO

CREATE PROCEDURE sp_EliminarHabitacionTipo
    @id_habitacion_tipo INT
AS
BEGIN
    -- Verifica si hay habitaciones de este tipo
    IF EXISTS (SELECT 1 FROM Habitacion WHERE id_habitacion_tipo = @id_habitacion_tipo)
    BEGIN
        RAISERROR('No se puede eliminar, hay habitaciones de este tipo', 16, 1);
        RETURN;
    END
    
    -- Elimina relaciones de comodidades y fotos
    DELETE FROM Habitacion_Comodidad_Relacion WHERE id_habitacion_tipo = @id_habitacion_tipo;
    DELETE FROM Habitacion_Foto WHERE id_habitacion_tipo = @id_habitacion_tipo;
    
    -- Elimina el tipo de habitación
    DELETE FROM Habitacion_Tipo
    WHERE id_habitacion_tipo = @id_habitacion_tipo;
END;
GO

-- =============================================
-- Procedimientos para Habitacion
-- =============================================
CREATE PROCEDURE sp_AgregarHabitacion
    @id_establecimiento INT,
    @id_habitacion_tipo INT,
    @numero VARCHAR(20),
    @estado VARCHAR(20)
AS
BEGIN
    INSERT INTO Habitacion (id_establecimiento, id_habitacion_tipo, numero, estado)
    VALUES (@id_establecimiento, @id_habitacion_tipo, @numero, @estado);
    
    SELECT SCOPE_IDENTITY() AS id_habitacion;
END;
GO

CREATE PROCEDURE sp_ActualizarHabitacion
    @id_habitacion INT,
    @id_establecimiento INT,
    @id_habitacion_tipo INT,
    @numero VARCHAR(20),
    @estado VARCHAR(20)
AS
BEGIN
    UPDATE Habitacion
    SET 
        id_establecimiento = @id_establecimiento,
        id_habitacion_tipo = @id_habitacion_tipo,
        numero = @numero,
        estado = @estado
    WHERE id_habitacion = @id_habitacion;
END;
GO

CREATE PROCEDURE sp_EliminarHabitacion
    @id_habitacion INT
AS
BEGIN
    -- Verifica si hay reservaciones para esta habitación
    IF EXISTS (SELECT 1 FROM Habitacion_Reservacion_Relacion WHERE id_habitacion = @id_habitacion)
    BEGIN
        RAISERROR('No se puede eliminar, hay reservaciones asociadas a esta habitación', 16, 1);
        RETURN;
    END
    
    DELETE FROM Habitacion
    WHERE id_habitacion = @id_habitacion;
END;
GO

-- =============================================
-- Procedimientos para Cliente
-- =============================================
CREATE PROCEDURE sp_AgregarCliente
    @id_cliente_identificacion INT,
    @numero_identificacion VARCHAR(50),
    @nombre VARCHAR(100),
    @primer_apellido VARCHAR(50),
    @segundo_apellido VARCHAR(50) = NULL,
    @fecha_nacimiento DATE,
    @pais_residencia VARCHAR(50),
    @provincia VARCHAR(50) = NULL,
    @canton VARCHAR(50) = NULL,
    @distrito VARCHAR(50) = NULL,
    @telefono1 VARCHAR(20),
    @telefono2 VARCHAR(20) = NULL,
    @telefono3 VARCHAR(20) = NULL,
    @correo VARCHAR(100)
AS
BEGIN
    INSERT INTO Cliente (
        id_cliente_identificacion, numero_identificacion,
        nombre, primer_apellido, segundo_apellido, fecha_nacimiento,
        pais_residencia, provincia, canton, distrito,
        telefono1, telefono2, telefono3, correo
    )
    VALUES (
        @id_cliente_identificacion, @numero_identificacion,
        @nombre, @primer_apellido, @segundo_apellido, @fecha_nacimiento,
        @pais_residencia, @provincia, @canton, @distrito,
        @telefono1, @telefono2, @telefono3, @correo
    );
    
    SELECT SCOPE_IDENTITY() AS id_cliente;
END;
GO

CREATE PROCEDURE sp_ActualizarCliente
    @id_cliente INT,
    @id_cliente_identificacion INT,
    @numero_identificacion VARCHAR(50),
    @nombre VARCHAR(100),
    @primer_apellido VARCHAR(50),
    @segundo_apellido VARCHAR(50) = NULL,
    @fecha_nacimiento DATE,
    @pais_residencia VARCHAR(50),
    @provincia VARCHAR(50) = NULL,
    @canton VARCHAR(50) = NULL,
    @distrito VARCHAR(50) = NULL,
    @telefono1 VARCHAR(20),
    @telefono2 VARCHAR(20) = NULL,
    @telefono3 VARCHAR(20) = NULL,
    @correo VARCHAR(100)
AS
BEGIN
    UPDATE Cliente
    SET 
        id_cliente_identificacion = @id_cliente_identificacion,
        numero_identificacion = @numero_identificacion,
        nombre = @nombre,
        primer_apellido = @primer_apellido,
        segundo_apellido = @segundo_apellido,
        fecha_nacimiento = @fecha_nacimiento,
        pais_residencia = @pais_residencia,
        provincia = @provincia,
        canton = @canton,
        distrito = @distrito,
        telefono1 = @telefono1,
        telefono2 = @telefono2,
        telefono3 = @telefono3,
        correo = @correo
    WHERE id_cliente = @id_cliente;
END;
GO

CREATE PROCEDURE sp_EliminarCliente
    @id_cliente INT
AS
BEGIN
    -- Verifica si hay reservaciones para este cliente
    IF EXISTS (SELECT 1 FROM Reservacion WHERE id_cliente = @id_cliente)
    BEGIN
        RAISERROR('No se puede eliminar, hay reservaciones asociadas a este cliente', 16, 1);
        RETURN;
    END
    
    DELETE FROM Cliente
    WHERE id_cliente = @id_cliente;
END;
GO


-- =============================================
-- Procedimientos para Reservacion
-- =============================================
CREATE PROCEDURE sp_AgregarReservacion
    @id_cliente INT,
    @fecha_ingreso DATETIME,
    @hora_ingreso TIME,
    @fecha_salida DATETIME,
    @hora_salida_personalizada TIME = NULL,
    @cantidad_personas INT,
    @posee_vehiculo BIT,
    @tipo_reservacion VARCHAR(20)
AS
BEGIN
    -- Valida tipo de reservación
    IF @tipo_reservacion NOT IN ('HABITACION', 'ACTIVIDAD')
    BEGIN
        RAISERROR('Tipo de reservación no válido. Debe ser HABITACION o ACTIVIDAD', 16, 1);
        RETURN;
    END
    
    INSERT INTO Reservacion (
        id_cliente, fecha_ingreso, hora_ingreso, fecha_salida, 
        hora_salida_personalizada, cantidad_personas, posee_vehiculo, tipo_reservacion
    )
    VALUES (
        @id_cliente, @fecha_ingreso, @hora_ingreso, @fecha_salida,
        @hora_salida_personalizada, @cantidad_personas, @posee_vehiculo, @tipo_reservacion
    );
    
    SELECT SCOPE_IDENTITY() AS id_reservacion;
END;
GO

CREATE PROCEDURE sp_ActualizarReservacion
    @id_reservacion INT,
    @id_cliente INT,
    @fecha_ingreso DATETIME,
    @hora_ingreso TIME,
    @fecha_salida DATETIME,
    @hora_salida_personalizada TIME = NULL,
    @cantidad_personas INT,
    @posee_vehiculo BIT,
    @tipo_reservacion VARCHAR(20)
AS
BEGIN
    -- Valida tipo de reservación
    IF @tipo_reservacion NOT IN ('HABITACION', 'ACTIVIDAD')
    BEGIN
        RAISERROR('Tipo de reservación no válido. Debe ser HABITACION o ACTIVIDAD', 16, 1);
        RETURN;
    END
    
    UPDATE Reservacion
    SET 
        id_cliente = @id_cliente,
        fecha_ingreso = @fecha_ingreso,
        hora_ingreso = @hora_ingreso,
        fecha_salida = @fecha_salida,
        hora_salida_personalizada = @hora_salida_personalizada,
        cantidad_personas = @cantidad_personas,
        posee_vehiculo = @posee_vehiculo,
        tipo_reservacion = @tipo_reservacion
    WHERE id_reservacion = @id_reservacion;
END;
GO

CREATE PROCEDURE sp_EliminarReservacion
    @id_reservacion INT
AS
BEGIN
    -- Verifica si hay facturación para esta reservación
    IF EXISTS (SELECT 1 FROM Facturacion WHERE id_reservacion = @id_reservacion)
    BEGIN
        RAISERROR('No se puede eliminar, hay facturación asociada a esta reservación', 16, 1);
        RETURN;
    END
    
    -- Elimina relaciones con habitaciones y actividades
    DELETE FROM Habitacion_Reservacion_Relacion WHERE id_reservacion = @id_reservacion;
    DELETE FROM Recreacion_Reservacion_Relacion WHERE id_reservacion = @id_reservacion;
    
    -- Elimina la reservación
    DELETE FROM Reservacion
    WHERE id_reservacion = @id_reservacion;
END;
GO


-- =============================================
-- Procedimientos para Habitacion_Reservacion_Relacion
-- =============================================
CREATE PROCEDURE sp_AgregarHabitacionAReservacion
    @id_habitacion INT,
    @id_reservacion INT
AS
BEGIN
    -- Verifica que la habitación no esté ya asignada a esta reservación
    IF EXISTS (SELECT 1 FROM Habitacion_Reservacion_Relacion 
               WHERE id_habitacion = @id_habitacion AND id_reservacion = @id_reservacion)
    BEGIN
        RAISERROR('Esta habitación ya está asignada a esta reservación', 16, 1);
        RETURN;
    END
    
    -- Verifica que la habitación esté disponible
    DECLARE @estado_habitacion VARCHAR(20);
    SELECT @estado_habitacion = estado FROM Habitacion WHERE id_habitacion = @id_habitacion;
    
    IF @estado_habitacion <> 'DISPONIBLE'
    BEGIN
        RAISERROR('La habitación no está disponible para reservación', 16, 1);
        RETURN;
    END
    
    INSERT INTO Habitacion_Reservacion_Relacion (id_habitacion, id_reservacion)
    VALUES (@id_habitacion, @id_reservacion);
    
    -- Actualizar estado de la habitación
    UPDATE Habitacion SET estado = 'RESERVADA' WHERE id_habitacion = @id_habitacion;
    
    SELECT SCOPE_IDENTITY() AS id_habitacion_reservacion_relacion;
END;
GO

CREATE PROCEDURE sp_EliminarHabitacionDeReservacion
    @id_habitacion INT,
    @id_reservacion INT
AS
BEGIN
    -- Verifica que la relación exista
    IF NOT EXISTS (SELECT 1 FROM Habitacion_Reservacion_Relacion 
                   WHERE id_habitacion = @id_habitacion AND id_reservacion = @id_reservacion)
    BEGIN
        RAISERROR('Esta habitación no está asignada a esta reservación', 16, 1);
        RETURN;
    END
    
    DELETE FROM Habitacion_Reservacion_Relacion
    WHERE id_habitacion = @id_habitacion AND id_reservacion = @id_reservacion;
    
    -- Actualiza estado de la habitación
    UPDATE Habitacion SET estado = 'DISPONIBLE' WHERE id_habitacion = @id_habitacion;
END;
GO


-- =============================================
-- Procedimientos para Facturacion
-- =============================================
CREATE PROCEDURE sp_AgregarFacturacion
    @id_reservacion INT,
    @id_facturacion_metodo_pago INT,
    @fecha_facturacion DATETIME,
    @total DECIMAL(10,2)
AS
BEGIN
    -- Verifica que no exista ya facturación para esta reservación
    IF EXISTS (SELECT 1 FROM Facturacion WHERE id_reservacion = @id_reservacion)
    BEGIN
        RAISERROR('Ya existe una factura para esta reservación', 16, 1);
        RETURN;
    END
    
    INSERT INTO Facturacion (id_reservacion, id_facturacion_metodo_pago, fecha_facturacion, total)
    VALUES (@id_reservacion, @id_facturacion_metodo_pago, @fecha_facturacion, @total);
    
    SELECT SCOPE_IDENTITY() AS id_facturacion;
END;
GO

CREATE PROCEDURE sp_ActualizarFacturacion
    @id_facturacion INT,
    @id_reservacion INT,
    @id_facturacion_metodo_pago INT,
    @fecha_facturacion DATETIME,
    @total DECIMAL(10,2)
AS
BEGIN
    UPDATE Facturacion
    SET 
        id_reservacion = @id_reservacion,
        id_facturacion_metodo_pago = @id_facturacion_metodo_pago,
        fecha_facturacion = @fecha_facturacion,
        total = @total
    WHERE id_facturacion = @id_facturacion;
END;
GO

CREATE PROCEDURE sp_EliminarFacturacion
    @id_facturacion INT
AS
BEGIN
    DELETE FROM Facturacion
    WHERE id_facturacion = @id_facturacion;
END;
GO

-- =============================================
-- Procedimientos para Habitacion_Cama
-- =============================================
CREATE PROCEDURE sp_AgregarHabitacionCama
    @nombre VARCHAR(50),
    @descripcion VARCHAR(250) = NULL
AS
BEGIN
    INSERT INTO Habitacion_Cama (nombre, descripcion)
    VALUES (@nombre, @descripcion);
    
    SELECT SCOPE_IDENTITY() AS id_habitacion_cama;
END;
GO

CREATE PROCEDURE sp_ActualizarHabitacionCama
    @id_habitacion_cama INT,
    @nombre VARCHAR(50),
    @descripcion VARCHAR(250) = NULL
AS
BEGIN
    UPDATE Habitacion_Cama
    SET nombre = @nombre, descripcion = @descripcion
    WHERE id_habitacion_cama = @id_habitacion_cama;
END;
GO

CREATE PROCEDURE sp_EliminarHabitacionCama
    @id_habitacion_cama INT
AS
BEGIN
    -- Verifica si hay tipos de habitación usando esta cama
    IF EXISTS (SELECT 1 FROM Habitacion_Tipo WHERE id_habitacion_cama = @id_habitacion_cama)
    BEGIN
        RAISERROR('No se puede eliminar, hay tipos de habitación asociados a esta cama', 16, 1);
        RETURN;
    END
    
    DELETE FROM Habitacion_Cama
    WHERE id_habitacion_cama = @id_habitacion_cama;
END;
GO

-- =============================================
-- Procedimientos para Habitacion_Comodidad
-- =============================================
CREATE PROCEDURE sp_AgregarHabitacionComodidad
    @nombre VARCHAR(100)
AS
BEGIN
    INSERT INTO Habitacion_Comodidad (nombre)
    VALUES (@nombre);
    
    SELECT SCOPE_IDENTITY() AS id_habitacion_comodidad;
END;
GO

CREATE PROCEDURE sp_ActualizarHabitacionComodidad
    @id_habitacion_comodidad INT,
    @nombre VARCHAR(100)
AS
BEGIN
    UPDATE Habitacion_Comodidad
    SET nombre = @nombre
    WHERE id_habitacion_comodidad = @id_habitacion_comodidad;
END;
GO

CREATE PROCEDURE sp_EliminarHabitacionComodidad
    @id_habitacion_comodidad INT
AS
BEGIN
    -- Verifica si hay tipos de habitación usando esta comodidad
    IF EXISTS (SELECT 1 FROM Habitacion_Comodidad_Relacion WHERE id_habitacion_comodidad = @id_habitacion_comodidad)
    BEGIN
        RAISERROR('No se puede eliminar, hay tipos de habitación asociados a esta comodidad', 16, 1);
        RETURN;
    END
    
    DELETE FROM Habitacion_Comodidad
    WHERE id_habitacion_comodidad = @id_habitacion_comodidad;
END;
GO

-- =============================================
-- Procedimientos para Habitacion_Comodidad_Relacion
-- =============================================
CREATE PROCEDURE sp_AgregarComodidadAHabitacionTipo
    @id_habitacion_tipo INT,
    @id_habitacion_comodidad INT
AS
BEGIN
    -- Verifica que no exista ya esta relación
    IF EXISTS (SELECT 1 FROM Habitacion_Comodidad_Relacion 
               WHERE id_habitacion_tipo = @id_habitacion_tipo 
               AND id_habitacion_comodidad = @id_habitacion_comodidad)
    BEGIN
        RAISERROR('Esta comodidad ya está asociada al tipo de habitación', 16, 1);
        RETURN;
    END
    
    INSERT INTO Habitacion_Comodidad_Relacion (id_habitacion_tipo, id_habitacion_comodidad)
    VALUES (@id_habitacion_tipo, @id_habitacion_comodidad);
    
    SELECT SCOPE_IDENTITY() AS id_habitacion_comodidad_relacion;
END;
GO

CREATE PROCEDURE sp_EliminarComodidadDeHabitacionTipo
    @id_habitacion_tipo INT,
    @id_habitacion_comodidad INT
AS
BEGIN
    DELETE FROM Habitacion_Comodidad_Relacion
    WHERE id_habitacion_tipo = @id_habitacion_tipo
    AND id_habitacion_comodidad = @id_habitacion_comodidad;
END;
GO

-- =============================================
-- Procedimientos para Habitacion_Foto
-- =============================================
CREATE PROCEDURE sp_AgregarHabitacionFoto
    @id_habitacion_tipo INT,
    @url_foto VARCHAR(250)
AS
BEGIN
    INSERT INTO Habitacion_Foto (id_habitacion_tipo, url_foto)
    VALUES (@id_habitacion_tipo, @url_foto);
    
    SELECT SCOPE_IDENTITY() AS id_habitacion_foto;
END;
GO

CREATE PROCEDURE sp_ActualizarHabitacionFoto
    @id_habitacion_foto INT,
    @id_habitacion_tipo INT,
    @url_foto VARCHAR(250)
AS
BEGIN
    UPDATE Habitacion_Foto
    SET id_habitacion_tipo = @id_habitacion_tipo, url_foto = @url_foto
    WHERE id_habitacion_foto = @id_habitacion_foto;
END;
GO

CREATE PROCEDURE sp_EliminarHabitacionFoto
    @id_habitacion_foto INT
AS
BEGIN
    DELETE FROM Habitacion_Foto
    WHERE id_habitacion_foto = @id_habitacion_foto;
END;
GO

-- =============================================
-- Procedimientos para Cliente_Identificacion
-- =============================================
CREATE PROCEDURE sp_AgregarClienteIdentificacion
    @nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO Cliente_Identificacion (nombre)
    VALUES (@nombre);
    
    SELECT SCOPE_IDENTITY() AS id_cliente_identificacion;
END;
GO

CREATE PROCEDURE sp_ActualizarClienteIdentificacion
    @id_cliente_identificacion INT,
    @nombre VARCHAR(50)
AS
BEGIN
    UPDATE Cliente_Identificacion
    SET nombre = @nombre
    WHERE id_cliente_identificacion = @id_cliente_identificacion;
END;
GO

CREATE PROCEDURE sp_EliminarClienteIdentificacion
    @id_cliente_identificacion INT
AS
BEGIN
    -- Verifica si hay clientes usando este tipo de identificación
    IF EXISTS (SELECT 1 FROM Cliente WHERE id_cliente_identificacion = @id_cliente_identificacion)
    BEGIN
        RAISERROR('No se puede eliminar, hay clientes asociados a este tipo de identificación', 16, 1);
        RETURN;
    END
    
    DELETE FROM Cliente_Identificacion
    WHERE id_cliente_identificacion = @id_cliente_identificacion;
END;
GO


-- =============================================
-- Procedimientos para Facturacion_Metodo_Pago
-- =============================================
CREATE PROCEDURE sp_AgregarFacturacionMetodoPago
    @nombre VARCHAR(50)
AS
BEGIN
    INSERT INTO Facturacion_Metodo_Pago (nombre)
    VALUES (@nombre);
    
    SELECT SCOPE_IDENTITY() AS id_facturacion_metodo_pago;
END;
GO

CREATE PROCEDURE sp_ActualizarFacturacionMetodoPago
    @id_facturacion_metodo_pago INT,
    @nombre VARCHAR(50)
AS
BEGIN
    UPDATE Facturacion_Metodo_Pago
    SET nombre = @nombre
    WHERE id_facturacion_metodo_pago = @id_facturacion_metodo_pago;
END;
GO

CREATE PROCEDURE sp_EliminarFacturacionMetodoPago
    @id_facturacion_metodo_pago INT
AS
BEGIN
    -- Verifica si hay facturas usando este método de pago
    IF EXISTS (SELECT 1 FROM Facturacion WHERE id_facturacion_metodo_pago = @id_facturacion_metodo_pago)
    BEGIN
        RAISERROR('No se puede eliminar, hay facturas asociadas a este método de pago', 16, 1);
        RETURN;
    END
    
    DELETE FROM Facturacion_Metodo_Pago
    WHERE id_facturacion_metodo_pago = @id_facturacion_metodo_pago;
END;
GO


-- =============================================
-- Procedimientos para Recreacion_Tipo
-- =============================================
CREATE PROCEDURE sp_AgregarRecreacionTipo
    @nombre VARCHAR(100)
AS
BEGIN
    INSERT INTO Recreacion_Tipo (nombre)
    VALUES (@nombre);
    
    SELECT SCOPE_IDENTITY() AS id_recreacion_tipo;
END;
GO

CREATE PROCEDURE sp_ActualizarRecreacionTipo
    @id_recreacion_tipo INT,
    @nombre VARCHAR(100)
AS
BEGIN
    UPDATE Recreacion_Tipo
    SET nombre = @nombre
    WHERE id_recreacion_tipo = @id_recreacion_tipo;
END;
GO

CREATE PROCEDURE sp_EliminarRecreacionTipo
    @id_recreacion_tipo INT
AS
BEGIN
    -- Verifica si hay actividades de recreación usando este tipo
    IF EXISTS (SELECT 1 FROM Recreacion_Tipo_Relacion WHERE id_recreacion_tipo = @id_recreacion_tipo)
    BEGIN
        RAISERROR('No se puede eliminar, hay actividades asociadas a este tipo', 16, 1);
        RETURN;
    END
    
    DELETE FROM Recreacion_Tipo
    WHERE id_recreacion_tipo = @id_recreacion_tipo;
END;
GO


-- =============================================
-- Procedimientos para Recreacion_Servicio
-- =============================================
CREATE PROCEDURE sp_AgregarRecreacionServicio
    @nombre VARCHAR(100),
    @descripcion VARCHAR(250) = NULL
AS
BEGIN
    INSERT INTO Recreacion_Servicio (nombre, descripcion)
    VALUES (@nombre, @descripcion);
    
    SELECT SCOPE_IDENTITY() AS id_recreacion_servicio;
END;
GO

CREATE PROCEDURE sp_ActualizarRecreacionServicio
    @id_recreacion_servicio INT,
    @nombre VARCHAR(100),
    @descripcion VARCHAR(250) = NULL
AS
BEGIN
    UPDATE Recreacion_Servicio
    SET nombre = @nombre, descripcion = @descripcion
    WHERE id_recreacion_servicio = @id_recreacion_servicio;
END;
GO

CREATE PROCEDURE sp_EliminarRecreacionServicio
    @id_recreacion_servicio INT
AS
BEGIN
    -- Verifica si hay actividades usando este servicio
    IF EXISTS (SELECT 1 FROM Recreacion_Servicio_Relacion WHERE id_recreacion_servicio = @id_recreacion_servicio)
    BEGIN
        RAISERROR('No se puede eliminar, hay actividades asociadas a este servicio', 16, 1);
        RETURN;
    END
    
    DELETE FROM Recreacion_Servicio
    WHERE id_recreacion_servicio = @id_recreacion_servicio;
END;
GO


-- =============================================
-- Procedimientos para Recreacion_Empresa
-- =============================================
CREATE PROCEDURE sp_AgregarRecreacionEmpresa
    @nombre VARCHAR(100),
    @cedula_juridica VARCHAR(20),
    @correo VARCHAR(100),
    @telefono1 VARCHAR(20),
    @telefono2 VARCHAR(20) = NULL,
    @telefono3 VARCHAR(20) = NULL,
    @nombre_contacto VARCHAR(100),
    @provincia VARCHAR(50),
    @canton VARCHAR(50),
    @distrito VARCHAR(50),
    @senas_exactas VARCHAR(250)
AS
BEGIN
    INSERT INTO Recreacion_Empresa (
        nombre, cedula_juridica, correo,
        telefono1, telefono2, telefono3, nombre_contacto,
        provincia, canton, distrito, senas_exactas
    )
    VALUES (
        @nombre, @cedula_juridica, @correo,
        @telefono1, @telefono2, @telefono3, @nombre_contacto,
        @provincia, @canton, @distrito, @senas_exactas
    );
    
    SELECT SCOPE_IDENTITY() AS id_recreacion_empresa;
END;
GO

CREATE PROCEDURE sp_ActualizarRecreacionEmpresa
    @id_recreacion_empresa INT,
    @nombre VARCHAR(100),
    @cedula_juridica VARCHAR(20),
    @correo VARCHAR(100),
    @telefono1 VARCHAR(20),
    @telefono2 VARCHAR(20) = NULL,
    @telefono3 VARCHAR(20) = NULL,
    @nombre_contacto VARCHAR(100),
    @provincia VARCHAR(50),
    @canton VARCHAR(50),
    @distrito VARCHAR(50),
    @senas_exactas VARCHAR(250)
AS
BEGIN
    UPDATE Recreacion_Empresa
    SET 
        nombre = @nombre,
        cedula_juridica = @cedula_juridica,
        correo = @correo,
        telefono1 = @telefono1,
        telefono2 = @telefono2,
        telefono3 = @telefono3,
        nombre_contacto = @nombre_contacto,
        provincia = @provincia,
        canton = @canton,
        distrito = @distrito,
        senas_exactas = @senas_exactas
    WHERE id_recreacion_empresa = @id_recreacion_empresa;
END;
GO

CREATE PROCEDURE sp_EliminarRecreacionEmpresa
    @id_recreacion_empresa INT
AS
BEGIN
    -- Verifica si hay actividades de esta empresa
    IF EXISTS (SELECT 1 FROM Recreacion WHERE id_recreacion_empresa = @id_recreacion_empresa)
    BEGIN
        RAISERROR('No se puede eliminar, hay actividades asociadas a esta empresa', 16, 1);
        RETURN;
    END
    
    DELETE FROM Recreacion_Empresa
    WHERE id_recreacion_empresa = @id_recreacion_empresa;
END;
GO

-- =============================================
-- Procedimientos para Recreacion
-- =============================================
CREATE PROCEDURE sp_AgregarRecreacion
    @id_recreacion_empresa INT,
    @nombre VARCHAR(100),
    @descripcion VARCHAR(250) = NULL,
    @precio DECIMAL(10,2)
AS
BEGIN
    INSERT INTO Recreacion (id_recreacion_empresa, nombre, descripcion, precio)
    VALUES (@id_recreacion_empresa, @nombre, @descripcion, @precio);
    
    SELECT SCOPE_IDENTITY() AS id_recreacion;
END;
GO

CREATE PROCEDURE sp_ActualizarRecreacion
    @id_recreacion INT,
    @id_recreacion_empresa INT,
    @nombre VARCHAR(100),
    @descripcion VARCHAR(250) = NULL,
    @precio DECIMAL(10,2)
AS
BEGIN
    UPDATE Recreacion
    SET 
        id_recreacion_empresa = @id_recreacion_empresa,
        nombre = @nombre,
        descripcion = @descripcion,
        precio = @precio
    WHERE id_recreacion = @id_recreacion;
END;
GO

CREATE PROCEDURE sp_EliminarRecreacion
    @id_recreacion INT
AS
BEGIN
    -- Verifica si hay reservaciones para esta actividad
    IF EXISTS (SELECT 1 FROM Recreacion_Reservacion_Relacion WHERE id_recreacion = @id_recreacion)
    BEGIN
        RAISERROR('No se puede eliminar, hay reservaciones asociadas a esta actividad', 16, 1);
        RETURN;
    END
    
    -- Eliminar relaciones con tipos y servicios
    DELETE FROM Recreacion_Tipo_Relacion WHERE id_recreacion = @id_recreacion;
    DELETE FROM Recreacion_Servicio_Relacion WHERE id_recreacion = @id_recreacion;
    
    -- Eliminar la actividad
    DELETE FROM Recreacion
    WHERE id_recreacion = @id_recreacion;
END;
GO

-- =============================================
-- Procedimientos para Recreacion_Tipo_Relacion
-- =============================================
CREATE PROCEDURE sp_AgregarTipoARecreacion
    @id_recreacion INT,
    @id_recreacion_tipo INT
AS
BEGIN
    -- Verifica que no exista ya esta relación
    IF EXISTS (SELECT 1 FROM Recreacion_Tipo_Relacion 
               WHERE id_recreacion = @id_recreacion 
               AND id_recreacion_tipo = @id_recreacion_tipo)
    BEGIN
        RAISERROR('Este tipo ya está asociado a la actividad', 16, 1);
        RETURN;
    END
    
    INSERT INTO Recreacion_Tipo_Relacion (id_recreacion, id_recreacion_tipo)
    VALUES (@id_recreacion, @id_recreacion_tipo);
    
    SELECT SCOPE_IDENTITY() AS id_recreacion_tipo_relacion;
END;
GO

CREATE PROCEDURE sp_EliminarTipoDeRecreacion
    @id_recreacion INT,
    @id_recreacion_tipo INT
AS
BEGIN
    DELETE FROM Recreacion_Tipo_Relacion
    WHERE id_recreacion = @id_recreacion
    AND id_recreacion_tipo = @id_recreacion_tipo;
END;
GO

-- =============================================
-- Procedimientos para Recreacion_Servicio_Relacion
-- =============================================
CREATE PROCEDURE sp_AgregarServicioARecreacion
    @id_recreacion INT,
    @id_recreacion_servicio INT
AS
BEGIN
    -- Verifica que no exista ya esta relación
    IF EXISTS (SELECT 1 FROM Recreacion_Servicio_Relacion 
               WHERE id_recreacion = @id_recreacion 
               AND id_recreacion_servicio = @id_recreacion_servicio)
    BEGIN
        RAISERROR('Este servicio ya está asociado a la actividad', 16, 1);
        RETURN;
    END
    
    INSERT INTO Recreacion_Servicio_Relacion (id_recreacion, id_recreacion_servicio)
    VALUES (@id_recreacion, @id_recreacion_servicio);
    
    SELECT SCOPE_IDENTITY() AS id_recreacion_servicio_relacion;
END;
GO

CREATE PROCEDURE sp_EliminarServicioDeRecreacion
    @id_recreacion INT,
    @id_recreacion_servicio INT
AS
BEGIN
    DELETE FROM Recreacion_Servicio_Relacion
    WHERE id_recreacion = @id_recreacion
    AND id_recreacion_servicio = @id_recreacion_servicio;
END;
GO


-- =============================================
-- Procedimientos para Recreacion_Reservacion_Relacion
-- =============================================
CREATE PROCEDURE sp_AgregarRecreacionAReservacion
    @id_recreacion INT,
    @id_reservacion INT
AS
BEGIN
    -- Verifica que no exista ya esta relación
    IF EXISTS (SELECT 1 FROM Recreacion_Reservacion_Relacion 
               WHERE id_recreacion = @id_recreacion 
               AND id_reservacion = @id_reservacion)
    BEGIN
        RAISERROR('Esta actividad ya está asociada a la reservación', 16, 1);
        RETURN;
    END
    
    INSERT INTO Recreacion_Reservacion_Relacion (id_recreacion, id_reservacion)
    VALUES (@id_recreacion, @id_reservacion);
    
    SELECT SCOPE_IDENTITY() AS id_recreacion_reservacion_relacion;
END;
GO

CREATE PROCEDURE sp_EliminarRecreacionDeReservacion
    @id_recreacion INT,
    @id_reservacion INT
AS
BEGIN
    DELETE FROM Recreacion_Reservacion_Relacion
    WHERE id_recreacion = @id_recreacion
    AND id_reservacion = @id_reservacion;
END;
GO
