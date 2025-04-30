-- ==============================================================
--  Proyecto      : Sistema de Gestión Hotelera
--  Script        : Vistas
--  Base de Datos : GestionHotelera
--  Autor         : Emilio F. & Ginger R.
--  Fecha         : 28/04/2025
--
--  Descripción:
--      Script para crear vistas consolidados del sistema
--      de gestión hotelera, integrando información relacional
--      de establecimientos, habitaciones, clientes, 
--      reservaciones, facturación y actividades recreativas.
-- ==============================================================

USE GestionHotelera;
GO

-- =============================
-- Vista: Vista_Establecimiento_Completo
-- Muestra todos los datos del establecimiento con sus relaciones
-- =============================
CREATE VIEW Vista_Establecimiento_Completo AS
SELECT 
    e.id_establecimiento,
    e.nombre AS nombre_establecimiento,
    e.cedula_juridica,
    et.nombre AS tipo_establecimiento,
    e.provincia,
    e.canton,
    e.distrito,
    e.barrio,
    e.senas_exactas,
    e.referencia_gps,
    e.telefono1,
    e.telefono2,
    e.telefono3,
    e.correo,
    e.url_sitio_web,
    STUFF((
        SELECT ', ' + rs.nombre + ': ' + rs.url_red_social
        FROM Establecimiento_Red_Social rs
        WHERE rs.id_establecimiento = e.id_establecimiento
        FOR XML PATH('')
    ), 1, 2, '') AS redes_sociales,
    STUFF((
        SELECT ', ' + s.nombre
        FROM Establecimiento_Servicio_Relacion esr
        JOIN Establecimiento_Servicio s ON esr.id_establecimiento_servicio = s.id_establecimiento_servicio
        WHERE esr.id_establecimiento = e.id_establecimiento
        FOR XML PATH('')
    ), 1, 2, '') AS servicios
FROM 
    Establecimiento e
JOIN 
    Establecimiento_Tipo et ON e.id_establecimiento_tipo = et.id_establecimiento_tipo;
GO

-- =============================
-- Vista: Vista_Habitacion_Completa
-- Muestra todos los datos de la habitación con sus relaciones
-- =============================
CREATE VIEW Vista_Habitacion_Completa AS
SELECT 
    h.id_habitacion,
    h.numero,
    h.estado,
    e.nombre AS nombre_establecimiento,
    ht.nombre AS tipo_habitacion,
    ht.descripcion AS descripcion_habitacion,
    ht.precio,
    ht.capacidad_maxima,
    hc.nombre AS tipo_cama,
    hc.descripcion AS descripcion_cama,
    STUFF((
        SELECT ', ' + c.nombre
        FROM Habitacion_Comodidad_Relacion hcr
        JOIN Habitacion_Comodidad c ON hcr.id_habitacion_comodidad = c.id_habitacion_comodidad
        WHERE hcr.id_habitacion_tipo = ht.id_habitacion_tipo
        FOR XML PATH('')
    ), 1, 2, '') AS comodidades,
    STUFF((
        SELECT ', ' + hf.url_foto
        FROM Habitacion_Foto hf
        WHERE hf.id_habitacion_tipo = ht.id_habitacion_tipo
        FOR XML PATH('')
    ), 1, 2, '') AS fotos
FROM 
    Habitacion h
JOIN 
    Establecimiento e ON h.id_establecimiento = e.id_establecimiento
JOIN 
    Habitacion_Tipo ht ON h.id_habitacion_tipo = ht.id_habitacion_tipo
JOIN 
    Habitacion_Cama hc ON ht.id_habitacion_cama = hc.id_habitacion_cama;
GO

-- =============================
-- Vista: Vista_Cliente_Completo
-- Muestra todos los datos del cliente con sus relaciones
-- =============================
CREATE VIEW Vista_Cliente_Completo AS
SELECT 
    c.id_cliente,
    ci.nombre AS tipo_identificacion,
    c.numero_identificacion,
    c.nombre,
    c.primer_apellido,
    c.segundo_apellido,
    c.fecha_nacimiento,
    c.pais_residencia,
    c.provincia,
    c.canton,
    c.distrito,
    c.telefono1,
    c.telefono2,
    c.telefono3,
    c.correo,
    DATEDIFF(YEAR, c.fecha_nacimiento, GETDATE()) AS edad
FROM 
    Cliente c
JOIN 
    Cliente_Identificacion ci ON c.id_cliente_identificacion = ci.id_cliente_identificacion;
GO

-- =============================
-- Vista: Vista_Reservacion_Completa
-- Muestra todos los datos de la reservación con sus relaciones
-- =============================
CREATE VIEW Vista_Reservacion_Completa AS
SELECT 
    r.id_reservacion,
    c.nombre + ' ' + c.primer_apellido + ISNULL(' ' + c.segundo_apellido, '') AS nombre_cliente,
    r.fecha_ingreso,
    r.hora_ingreso,
    r.fecha_salida,
    r.hora_salida_personalizada,
    r.cantidad_personas,
    CASE WHEN r.posee_vehiculo = 1 THEN 'Sí' ELSE 'No' END AS posee_vehiculo,
    r.tipo_reservacion,
    STUFF((
        SELECT ', Habitación #' + h.numero + ' (' + ht.nombre + ')'
        FROM Habitacion_Reservacion_Relacion hrr
        JOIN Habitacion h ON hrr.id_habitacion = h.id_habitacion
        JOIN Habitacion_Tipo ht ON h.id_habitacion_tipo = ht.id_habitacion_tipo
        WHERE hrr.id_reservacion = r.id_reservacion
        FOR XML PATH('')
    ), 1, 2, '') AS habitaciones,
    STUFF((
        SELECT ', ' + rec.nombre + ' ($' + CAST(rec.precio AS VARCHAR) + ')'
        FROM Recreacion_Reservacion_Relacion rrr
        JOIN Recreacion rec ON rrr.id_recreacion = rec.id_recreacion
        WHERE rrr.id_reservacion = r.id_reservacion
        FOR XML PATH('')
    ), 1, 2, '') AS actividades_recreativas
FROM 
    Reservacion r
JOIN 
    Cliente c ON r.id_cliente = c.id_cliente;
GO

-- =============================
-- Vista: Vista_Facturacion_Completa
-- Muestra todos los datos de facturación con sus relaciones
-- =============================
CREATE VIEW Vista_Facturacion_Completa AS
SELECT 
    f.id_facturacion,
    r.id_reservacion,
    c.nombre + ' ' + c.primer_apellido + ISNULL(' ' + c.segundo_apellido, '') AS nombre_cliente,
    f.fecha_facturacion,
    f.total,
    fp.nombre AS metodo_pago,
    r.fecha_ingreso,
    r.fecha_salida,
    r.tipo_reservacion,
    STUFF((
        SELECT ', Habitación #' + h.numero + ' (' + ht.nombre + ' - $' + CAST(ht.precio AS VARCHAR) + ')'
        FROM Habitacion_Reservacion_Relacion hrr
        JOIN Habitacion h ON hrr.id_habitacion = h.id_habitacion
        JOIN Habitacion_Tipo ht ON h.id_habitacion_tipo = ht.id_habitacion_tipo
        WHERE hrr.id_reservacion = r.id_reservacion
        FOR XML PATH('')
    ), 1, 2, '') AS habitaciones,
    STUFF((
        SELECT ', ' + rec.nombre + ' ($' + CAST(rec.precio AS VARCHAR) + ')'
        FROM Recreacion_Reservacion_Relacion rrr
        JOIN Recreacion rec ON rrr.id_recreacion = rec.id_recreacion
        WHERE rrr.id_reservacion = r.id_reservacion
        FOR XML PATH('')
    ), 1, 2, '') AS actividades_recreativas
FROM 
    Facturacion f
JOIN 
    Reservacion r ON f.id_reservacion = r.id_reservacion
JOIN 
    Cliente c ON r.id_cliente = c.id_cliente
JOIN 
    Facturacion_Metodo_Pago fp ON f.id_facturacion_metodo_pago = fp.id_facturacion_metodo_pago;
GO

-- =============================
-- Vista: Vista_Recreacion_Completa
-- Muestra todos los datos de recreación con sus relaciones
-- =============================
CREATE VIEW Vista_Recreacion_Completa AS
SELECT 
    r.id_recreacion,
    r.nombre AS nombre_actividad,
    r.descripcion,
    r.precio,
    re.nombre AS empresa,
    re.telefono1 AS telefono_empresa,
    re.correo AS correo_empresa,
    STUFF((
        SELECT ', ' + rt.nombre
        FROM Recreacion_Tipo_Relacion rtr
        JOIN Recreacion_Tipo rt ON rtr.id_recreacion_tipo = rt.id_recreacion_tipo
        WHERE rtr.id_recreacion = r.id_recreacion
        FOR XML PATH('')
    ), 1, 2, '') AS tipos_actividad,
    STUFF((
        SELECT ', ' + rs.nombre
        FROM Recreacion_Servicio_Relacion rsr
        JOIN Recreacion_Servicio rs ON rsr.id_recreacion_servicio = rs.id_recreacion_servicio
        WHERE rsr.id_recreacion = r.id_recreacion
        FOR XML PATH('')
    ), 1, 2, '') AS servicios_incluidos
FROM 
    Recreacion r
JOIN 
    Recreacion_Empresa re ON r.id_recreacion_empresa = re.id_recreacion_empresa;
GO