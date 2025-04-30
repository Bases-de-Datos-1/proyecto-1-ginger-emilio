-- ==============================================================
--  Proyecto      : Sistema de Gestión Hotelera
--  Script        : Procedimientos Almacenados de Búsqueda
--  Base de Datos : GestionHotelera
--  Autor         : Emilio F. & Ginger R.
--  Fecha         : 29/04/2025
--
--  Descripción:
--      Script para crear procedimientos almacenados que permitan
--      realizar búsquedas con filtros en todas las tablas del sistema.
-- ==============================================================

USE GestionHotelera;
GO

-- =============================================
-- Buscar en Establecimiento_Tipo
-- =============================================
CREATE PROCEDURE sp_BuscarEstablecimientoTipo
    @id_establecimiento_tipo INT = NULL,
    @nombre VARCHAR(50) = NULL
AS
BEGIN
    SELECT *
    FROM Establecimiento_Tipo
    WHERE 
        (@id_establecimiento_tipo IS NULL OR id_establecimiento_tipo = @id_establecimiento_tipo)
        AND (@nombre IS NULL OR nombre LIKE '%' + @nombre + '%')
    ORDER BY nombre;
END;
GO

-- =============================================
-- Buscar en Establecimiento
-- =============================================
CREATE PROCEDURE sp_BuscarEstablecimiento
    @id_establecimiento INT = NULL,
    @nombre VARCHAR(100) = NULL,
    @cedula_juridica VARCHAR(20) = NULL,
    @id_establecimiento_tipo INT = NULL,
    @provincia VARCHAR(50) = NULL,
    @canton VARCHAR(50) = NULL,
    @distrito VARCHAR(50) = NULL
AS
BEGIN
    SELECT 
        e.*,
        et.nombre AS tipo_establecimiento
    FROM 
        Establecimiento e
        JOIN Establecimiento_Tipo et ON e.id_establecimiento_tipo = et.id_establecimiento_tipo
    WHERE 
        (@id_establecimiento IS NULL OR e.id_establecimiento = @id_establecimiento)
        AND (@nombre IS NULL OR e.nombre LIKE '%' + @nombre + '%')
        AND (@cedula_juridica IS NULL OR e.cedula_juridica = @cedula_juridica)
        AND (@id_establecimiento_tipo IS NULL OR e.id_establecimiento_tipo = @id_establecimiento_tipo)
        AND (@provincia IS NULL OR e.provincia LIKE '%' + @provincia + '%')
        AND (@canton IS NULL OR e.canton LIKE '%' + @canton + '%')
        AND (@distrito IS NULL OR e.distrito LIKE '%' + @distrito + '%')
    ORDER BY e.nombre;
END;
GO

-- =============================================
-- Buscar en Establecimiento_Red_Social
-- =============================================
CREATE PROCEDURE sp_BuscarEstablecimientoRedSocial
    @id_establecimiento_red_social INT = NULL,
    @id_establecimiento INT = NULL,
    @nombre VARCHAR(50) = NULL
AS
BEGIN
    SELECT 
        ers.*,
        e.nombre AS nombre_establecimiento
    FROM 
        Establecimiento_Red_Social ers
        JOIN Establecimiento e ON ers.id_establecimiento = e.id_establecimiento
    WHERE 
        (@id_establecimiento_red_social IS NULL OR ers.id_establecimiento_red_social = @id_establecimiento_red_social)
        AND (@id_establecimiento IS NULL OR ers.id_establecimiento = @id_establecimiento)
        AND (@nombre IS NULL OR ers.nombre LIKE '%' + @nombre + '%')
    ORDER BY e.nombre, ers.nombre;
END;
GO

-- =============================================
-- Buscar en Establecimiento_Servicio
-- =============================================
CREATE PROCEDURE sp_BuscarEstablecimientoServicio
    @id_establecimiento_servicio INT = NULL,
    @nombre VARCHAR(100) = NULL
AS
BEGIN
    SELECT *
    FROM Establecimiento_Servicio
    WHERE 
        (@id_establecimiento_servicio IS NULL OR id_establecimiento_servicio = @id_establecimiento_servicio)
        AND (@nombre IS NULL OR nombre LIKE '%' + @nombre + '%')
    ORDER BY nombre;
END;
GO

-- =============================================
-- Buscar en Establecimiento_Servicio_Relacion
-- =============================================
CREATE PROCEDURE sp_BuscarEstablecimientoServicioRelacion
    @id_establecimiento INT = NULL,
    @id_establecimiento_servicio INT = NULL
AS
BEGIN
    SELECT 
        esr.*,
        e.nombre AS nombre_establecimiento,
        es.nombre AS nombre_servicio
    FROM 
        Establecimiento_Servicio_Relacion esr
        JOIN Establecimiento e ON esr.id_establecimiento = e.id_establecimiento
        JOIN Establecimiento_Servicio es ON esr.id_establecimiento_servicio = es.id_establecimiento_servicio
    WHERE 
        (@id_establecimiento IS NULL OR esr.id_establecimiento = @id_establecimiento)
        AND (@id_establecimiento_servicio IS NULL OR esr.id_establecimiento_servicio = @id_establecimiento_servicio)
    ORDER BY e.nombre, es.nombre;
END;
GO

-- =============================================
-- Buscar en Habitacion_Cama
-- =============================================
CREATE PROCEDURE sp_BuscarHabitacionCama
    @id_habitacion_cama INT = NULL,
    @nombre VARCHAR(50) = NULL
AS
BEGIN
    SELECT *
    FROM Habitacion_Cama
    WHERE 
        (@id_habitacion_cama IS NULL OR id_habitacion_cama = @id_habitacion_cama)
        AND (@nombre IS NULL OR nombre LIKE '%' + @nombre + '%')
    ORDER BY nombre;
END;
GO

-- =============================================
-- Buscar en Habitacion_Tipo
-- =============================================
CREATE PROCEDURE sp_BuscarHabitacionTipo
    @id_habitacion_tipo INT = NULL,
    @nombre VARCHAR(100) = NULL,
    @precio_min DECIMAL(10,2) = NULL,
    @precio_max DECIMAL(10,2) = NULL,
    @capacidad_min INT = NULL,
    @capacidad_max INT = NULL,
    @id_habitacion_cama INT = NULL
AS
BEGIN
    SELECT 
        ht.*,
        hc.nombre AS tipo_cama
    FROM 
        Habitacion_Tipo ht
        JOIN Habitacion_Cama hc ON ht.id_habitacion_cama = hc.id_habitacion_cama
    WHERE 
        (@id_habitacion_tipo IS NULL OR ht.id_habitacion_tipo = @id_habitacion_tipo)
        AND (@nombre IS NULL OR ht.nombre LIKE '%' + @nombre + '%')
        AND (@precio_min IS NULL OR ht.precio >= @precio_min)
        AND (@precio_max IS NULL OR ht.precio <= @precio_max)
        AND (@capacidad_min IS NULL OR ht.capacidad_maxima >= @capacidad_min)
        AND (@capacidad_max IS NULL OR ht.capacidad_maxima <= @capacidad_max)
        AND (@id_habitacion_cama IS NULL OR ht.id_habitacion_cama = @id_habitacion_cama)
    ORDER BY ht.nombre;
END;
GO

-- =============================================
-- Buscar en Habitacion_Comodidad
-- =============================================
CREATE PROCEDURE sp_BuscarHabitacionComodidad
    @id_habitacion_comodidad INT = NULL,
    @nombre VARCHAR(100) = NULL
AS
BEGIN
    SELECT *
    FROM Habitacion_Comodidad
    WHERE 
        (@id_habitacion_comodidad IS NULL OR id_habitacion_comodidad = @id_habitacion_comodidad)
        AND (@nombre IS NULL OR nombre LIKE '%' + @nombre + '%')
    ORDER BY nombre;
END;
GO

-- =============================================
-- Buscar en Habitacion_Comodidad_Relacion
-- =============================================
CREATE PROCEDURE sp_BuscarHabitacionComodidadRelacion
    @id_habitacion_tipo INT = NULL,
    @id_habitacion_comodidad INT = NULL
AS
BEGIN
    SELECT 
        hcr.*,
        ht.nombre AS tipo_habitacion,
        hc.nombre AS comodidad
    FROM 
        Habitacion_Comodidad_Relacion hcr
        JOIN Habitacion_Tipo ht ON hcr.id_habitacion_tipo = ht.id_habitacion_tipo
        JOIN Habitacion_Comodidad hc ON hcr.id_habitacion_comodidad = hc.id_habitacion_comodidad
    WHERE 
        (@id_habitacion_tipo IS NULL OR hcr.id_habitacion_tipo = @id_habitacion_tipo)
        AND (@id_habitacion_comodidad IS NULL OR hcr.id_habitacion_comodidad = @id_habitacion_comodidad)
    ORDER BY ht.nombre, hc.nombre;
END;
GO

-- =============================================
-- Buscar en Habitacion_Foto
-- =============================================
CREATE PROCEDURE sp_BuscarHabitacionFoto
    @id_habitacion_foto INT = NULL,
    @id_habitacion_tipo INT = NULL
AS
BEGIN
    SELECT 
        hf.*,
        ht.nombre AS tipo_habitacion
    FROM 
        Habitacion_Foto hf
        JOIN Habitacion_Tipo ht ON hf.id_habitacion_tipo = ht.id_habitacion_tipo
    WHERE 
        (@id_habitacion_foto IS NULL OR hf.id_habitacion_foto = @id_habitacion_foto)
        AND (@id_habitacion_tipo IS NULL OR hf.id_habitacion_tipo = @id_habitacion_tipo)
    ORDER BY ht.nombre;
END;
GO

-- =============================================
-- Buscar en Habitacion
-- =============================================
CREATE PROCEDURE sp_BuscarHabitacion
    @id_habitacion INT = NULL,
    @id_establecimiento INT = NULL,
    @id_habitacion_tipo INT = NULL,
    @numero VARCHAR(20) = NULL,
    @estado VARCHAR(20) = NULL,
    @disponible BIT = NULL
AS
BEGIN
    SELECT 
        h.*,
        e.nombre AS nombre_establecimiento,
        ht.nombre AS tipo_habitacion,
        ht.precio,
        ht.capacidad_maxima,
        hc.nombre AS tipo_cama
    FROM 
        Habitacion h
        JOIN Establecimiento e ON h.id_establecimiento = e.id_establecimiento
        JOIN Habitacion_Tipo ht ON h.id_habitacion_tipo = ht.id_habitacion_tipo
        JOIN Habitacion_Cama hc ON ht.id_habitacion_cama = hc.id_habitacion_cama
    WHERE 
        (@id_habitacion IS NULL OR h.id_habitacion = @id_habitacion)
        AND (@id_establecimiento IS NULL OR h.id_establecimiento = @id_establecimiento)
        AND (@id_habitacion_tipo IS NULL OR h.id_habitacion_tipo = @id_habitacion_tipo)
        AND (@numero IS NULL OR h.numero LIKE '%' + @numero + '%')
        AND (@estado IS NULL OR h.estado = @estado)
        AND (@disponible IS NULL OR 
             (@disponible = 1 AND h.estado = 'DISPONIBLE') OR 
             (@disponible = 0 AND h.estado <> 'DISPONIBLE'))
    ORDER BY e.nombre, h.numero;
END;
GO

-- =============================================
-- Buscar en Cliente_Identificacion
-- =============================================
CREATE PROCEDURE sp_BuscarClienteIdentificacion
    @id_cliente_identificacion INT = NULL,
    @nombre VARCHAR(50) = NULL
AS
BEGIN
    SELECT *
    FROM Cliente_Identificacion
    WHERE 
        (@id_cliente_identificacion IS NULL OR id_cliente_identificacion = @id_cliente_identificacion)
        AND (@nombre IS NULL OR nombre LIKE '%' + @nombre + '%')
    ORDER BY nombre;
END;
GO

-- =============================================
-- Buscar en Cliente
-- =============================================
CREATE PROCEDURE sp_BuscarCliente
    @id_cliente INT = NULL,
    @id_cliente_identificacion INT = NULL,
    @numero_identificacion VARCHAR(50) = NULL,
    @nombre VARCHAR(100) = NULL,
    @apellido VARCHAR(50) = NULL,
    @pais_residencia VARCHAR(50) = NULL,
    @correo VARCHAR(100) = NULL,
    @edad_min INT = NULL,
    @edad_max INT = NULL
AS
BEGIN
    SELECT 
        c.*,
        ci.nombre AS tipo_identificacion,
        DATEDIFF(YEAR, c.fecha_nacimiento, GETDATE()) AS edad
    FROM 
        Cliente c
        JOIN Cliente_Identificacion ci ON c.id_cliente_identificacion = ci.id_cliente_identificacion
    WHERE 
        (@id_cliente IS NULL OR c.id_cliente = @id_cliente)
        AND (@id_cliente_identificacion IS NULL OR c.id_cliente_identificacion = @id_cliente_identificacion)
        AND (@numero_identificacion IS NULL OR c.numero_identificacion LIKE '%' + @numero_identificacion + '%')
        AND (@nombre IS NULL OR c.nombre LIKE '%' + @nombre + '%')
        AND (@apellido IS NULL OR (c.primer_apellido LIKE '%' + @apellido + '%' OR c.segundo_apellido LIKE '%' + @apellido + '%'))
        AND (@pais_residencia IS NULL OR c.pais_residencia LIKE '%' + @pais_residencia + '%')
        AND (@correo IS NULL OR c.correo LIKE '%' + @correo + '%')
        AND (@edad_min IS NULL OR DATEDIFF(YEAR, c.fecha_nacimiento, GETDATE()) >= @edad_min)
        AND (@edad_max IS NULL OR DATEDIFF(YEAR, c.fecha_nacimiento, GETDATE()) <= @edad_max)
    ORDER BY c.nombre, c.primer_apellido;
END;
GO

-- =============================================
-- Buscar en Reservacion
-- =============================================
CREATE PROCEDURE sp_BuscarReservacion
    @id_reservacion INT = NULL,
    @id_cliente INT = NULL,
    @fecha_ingreso_desde DATETIME = NULL,
    @fecha_ingreso_hasta DATETIME = NULL,
    @fecha_salida_desde DATETIME = NULL,
    @fecha_salida_hasta DATETIME = NULL,
    @tipo_reservacion VARCHAR(20) = NULL,
    @posee_vehiculo BIT = NULL
AS
BEGIN
    SELECT 
        r.*,
        c.nombre + ' ' + c.primer_apellido + ISNULL(' ' + c.segundo_apellido, '') AS nombre_cliente,
        ci.nombre AS tipo_identificacion,
        c.numero_identificacion
    FROM 
        Reservacion r
        JOIN Cliente c ON r.id_cliente = c.id_cliente
        JOIN Cliente_Identificacion ci ON c.id_cliente_identificacion = ci.id_cliente_identificacion
    WHERE 
        (@id_reservacion IS NULL OR r.id_reservacion = @id_reservacion)
        AND (@id_cliente IS NULL OR r.id_cliente = @id_cliente)
        AND (@fecha_ingreso_desde IS NULL OR r.fecha_ingreso >= @fecha_ingreso_desde)
        AND (@fecha_ingreso_hasta IS NULL OR r.fecha_ingreso <= @fecha_ingreso_hasta)
        AND (@fecha_salida_desde IS NULL OR r.fecha_salida >= @fecha_salida_desde)
        AND (@fecha_salida_hasta IS NULL OR r.fecha_salida <= @fecha_salida_hasta)
        AND (@tipo_reservacion IS NULL OR r.tipo_reservacion = @tipo_reservacion)
        AND (@posee_vehiculo IS NULL OR r.posee_vehiculo = @posee_vehiculo)
    ORDER BY r.fecha_ingreso DESC;
END;
GO

-- =============================================
-- Buscar en Habitacion_Reservacion_Relacion
-- =============================================
CREATE PROCEDURE sp_BuscarHabitacionReservacionRelacion
    @id_habitacion INT = NULL,
    @id_reservacion INT = NULL
AS
BEGIN
    SELECT 
        hrr.*,
        h.numero AS numero_habitacion,
        ht.nombre AS tipo_habitacion,
        e.nombre AS nombre_establecimiento,
        c.nombre + ' ' + c.primer_apellido AS nombre_cliente,
        r.fecha_ingreso,
        r.fecha_salida
    FROM 
        Habitacion_Reservacion_Relacion hrr
        JOIN Habitacion h ON hrr.id_habitacion = h.id_habitacion
        JOIN Habitacion_Tipo ht ON h.id_habitacion_tipo = ht.id_habitacion_tipo
        JOIN Establecimiento e ON h.id_establecimiento = e.id_establecimiento
        JOIN Reservacion r ON hrr.id_reservacion = r.id_reservacion
        JOIN Cliente c ON r.id_cliente = c.id_cliente
    WHERE 
        (@id_habitacion IS NULL OR hrr.id_habitacion = @id_habitacion)
        AND (@id_reservacion IS NULL OR hrr.id_reservacion = @id_reservacion)
    ORDER BY r.fecha_ingreso DESC;
END;
GO

-- =============================================
-- Buscar en Facturacion_Metodo_Pago
-- =============================================
CREATE PROCEDURE sp_BuscarFacturacionMetodoPago
    @id_facturacion_metodo_pago INT = NULL,
    @nombre VARCHAR(50) = NULL
AS
BEGIN
    SELECT *
    FROM Facturacion_Metodo_Pago
    WHERE 
        (@id_facturacion_metodo_pago IS NULL OR id_facturacion_metodo_pago = @id_facturacion_metodo_pago)
        AND (@nombre IS NULL OR nombre LIKE '%' + @nombre + '%')
    ORDER BY nombre;
END;
GO

-- =============================================
-- Buscar en Facturacion
-- =============================================
CREATE PROCEDURE sp_BuscarFacturacion
    @id_facturacion INT = NULL,
    @id_reservacion INT = NULL,
    @id_facturacion_metodo_pago INT = NULL,
    @fecha_desde DATETIME = NULL,
    @fecha_hasta DATETIME = NULL,
    @total_min DECIMAL(10,2) = NULL,
    @total_max DECIMAL(10,2) = NULL
AS
BEGIN
    SELECT 
        f.*,
        fp.nombre AS metodo_pago,
        c.nombre + ' ' + c.primer_apellido AS nombre_cliente,
        r.fecha_ingreso,
        r.fecha_salida
    FROM 
        Facturacion f
        JOIN Facturacion_Metodo_Pago fp ON f.id_facturacion_metodo_pago = fp.id_facturacion_metodo_pago
        JOIN Reservacion r ON f.id_reservacion = r.id_reservacion
        JOIN Cliente c ON r.id_cliente = c.id_cliente
    WHERE 
        (@id_facturacion IS NULL OR f.id_facturacion = @id_facturacion)
        AND (@id_reservacion IS NULL OR f.id_reservacion = @id_reservacion)
        AND (@id_facturacion_metodo_pago IS NULL OR f.id_facturacion_metodo_pago = @id_facturacion_metodo_pago)
        AND (@fecha_desde IS NULL OR f.fecha_facturacion >= @fecha_desde)
        AND (@fecha_hasta IS NULL OR f.fecha_facturacion <= @fecha_hasta)
        AND (@total_min IS NULL OR f.total >= @total_min)
        AND (@total_max IS NULL OR f.total <= @total_max)
    ORDER BY f.fecha_facturacion DESC;
END;
GO

-- =============================================
-- Buscar en Recreacion_Tipo
-- =============================================
CREATE PROCEDURE sp_BuscarRecreacionTipo
    @id_recreacion_tipo INT = NULL,
    @nombre VARCHAR(100) = NULL
AS
BEGIN
    SELECT *
    FROM Recreacion_Tipo
    WHERE 
        (@id_recreacion_tipo IS NULL OR id_recreacion_tipo = @id_recreacion_tipo)
        AND (@nombre IS NULL OR nombre LIKE '%' + @nombre + '%')
    ORDER BY nombre;
END;
GO

-- =============================================
-- Buscar en Recreacion_Servicio
-- =============================================
CREATE PROCEDURE sp_BuscarRecreacionServicio
    @id_recreacion_servicio INT = NULL,
    @nombre VARCHAR(100) = NULL
AS
BEGIN
    SELECT *
    FROM Recreacion_Servicio
    WHERE 
        (@id_recreacion_servicio IS NULL OR id_recreacion_servicio = @id_recreacion_servicio)
        AND (@nombre IS NULL OR nombre LIKE '%' + @nombre + '%')
    ORDER BY nombre;
END;
GO

-- =============================================
-- Buscar en Recreacion_Empresa
-- =============================================
CREATE PROCEDURE sp_BuscarRecreacionEmpresa
    @id_recreacion_empresa INT = NULL,
    @nombre VARCHAR(100) = NULL,
    @cedula_juridica VARCHAR(20) = NULL,
    @provincia VARCHAR(50) = NULL,
    @canton VARCHAR(50) = NULL
AS
BEGIN
    SELECT *
    FROM Recreacion_Empresa
    WHERE 
        (@id_recreacion_empresa IS NULL OR id_recreacion_empresa = @id_recreacion_empresa)
        AND (@nombre IS NULL OR nombre LIKE '%' + @nombre + '%')
        AND (@cedula_juridica IS NULL OR cedula_juridica LIKE '%' + @cedula_juridica + '%')
        AND (@provincia IS NULL OR provincia LIKE '%' + @provincia + '%')
        AND (@canton IS NULL OR canton LIKE '%' + @canton + '%')
    ORDER BY nombre;
END;
GO

-- =============================================
-- Buscar en Recreacion
-- =============================================
CREATE PROCEDURE sp_BuscarRecreacion
    @id_recreacion INT = NULL,
    @id_recreacion_empresa INT = NULL,
    @nombre VARCHAR(100) = NULL,
    @precio_min DECIMAL(10,2) = NULL,
    @precio_max DECIMAL(10,2) = NULL
AS
BEGIN
    SELECT 
        r.*,
        re.nombre AS nombre_empresa
    FROM 
        Recreacion r
        JOIN Recreacion_Empresa re ON r.id_recreacion_empresa = re.id_recreacion_empresa
    WHERE 
        (@id_recreacion IS NULL OR r.id_recreacion = @id_recreacion)
        AND (@id_recreacion_empresa IS NULL OR r.id_recreacion_empresa = @id_recreacion_empresa)
        AND (@nombre IS NULL OR r.nombre LIKE '%' + @nombre + '%')
        AND (@precio_min IS NULL OR r.precio >= @precio_min)
        AND (@precio_max IS NULL OR r.precio <= @precio_max)
    ORDER BY r.nombre;
END;
GO

-- =============================================
-- Buscar en Recreacion_Tipo_Relacion
-- =============================================
CREATE PROCEDURE sp_BuscarRecreacionTipoRelacion
    @id_recreacion INT = NULL,
    @id_recreacion_tipo INT = NULL
AS
BEGIN
    SELECT 
        rtr.*,
        r.nombre AS nombre_actividad,
        rt.nombre AS tipo_actividad
    FROM 
        Recreacion_Tipo_Relacion rtr
        JOIN Recreacion r ON rtr.id_recreacion = r.id_recreacion
        JOIN Recreacion_Tipo rt ON rtr.id_recreacion_tipo = rt.id_recreacion_tipo
    WHERE 
        (@id_recreacion IS NULL OR rtr.id_recreacion = @id_recreacion)
        AND (@id_recreacion_tipo IS NULL OR rtr.id_recreacion_tipo = @id_recreacion_tipo)
    ORDER BY r.nombre, rt.nombre;
END;
GO

-- =============================================
-- Buscar en Recreacion_Servicio_Relacion
-- =============================================
CREATE PROCEDURE sp_BuscarRecreacionServicioRelacion
    @id_recreacion INT = NULL,
    @id_recreacion_servicio INT = NULL
AS
BEGIN
    SELECT 
        rsr.*,
        r.nombre AS nombre_actividad,
        rs.nombre AS servicio
    FROM 
        Recreacion_Servicio_Relacion rsr
        JOIN Recreacion r ON rsr.id_recreacion = r.id_recreacion
        JOIN Recreacion_Servicio rs ON rsr.id_recreacion_servicio = rs.id_recreacion_servicio
    WHERE 
        (@id_recreacion IS NULL OR rsr.id_recreacion = @id_recreacion)
        AND (@id_recreacion_servicio IS NULL OR rsr.id_recreacion_servicio = @id_recreacion_servicio)
    ORDER BY r.nombre, rs.nombre;
END;
GO

-- =============================================
-- Buscar en Recreacion_Reservacion_Relacion
-- =============================================
CREATE PROCEDURE sp_BuscarRecreacionReservacionRelacion
    @id_recreacion INT = NULL,
    @id_reservacion INT = NULL
AS
BEGIN
    SELECT 
        rrr.*,
        r.nombre AS nombre_actividad,
        c.nombre + ' ' + c.primer_apellido AS nombre_cliente,
        res.fecha_ingreso,
        res.fecha_salida
    FROM 
        Recreacion_Reservacion_Relacion rrr
        JOIN Recreacion r ON rrr.id_recreacion = r.id_recreacion
        JOIN Reservacion res ON rrr.id_reservacion = res.id_reservacion
        JOIN Cliente c ON res.id_cliente = c.id_cliente
    WHERE 
        (@id_recreacion IS NULL OR rrr.id_recreacion = @id_recreacion)
        AND (@id_reservacion IS NULL OR rrr.id_reservacion = @id_reservacion)
    ORDER BY res.fecha_ingreso DESC;
END;
GO