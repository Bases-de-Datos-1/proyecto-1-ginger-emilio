-- ==============================================================
--  Proyecto      : Sistema de Gestión Hotelera
--  Script        : Datos Iniciales
--  Base de Datos : GestionHotelera
--  Autor         : Emilio F. & Ginger R.
--  Fecha         : 29/04/2025
--
--  Descripción:
--      Script para insertar datos iniciales usando los procedimientos
--      de Procedure.sql
-- ==============================================================

USE GestionHotelera;


-- Servicios de Establecimientos
EXEC sp_AgregarEstablecimientoServicio 'Piscina', 'Piscina disponible para huéspedes';
EXEC sp_AgregarEstablecimientoServicio 'Wifi', 'Acceso a internet inalámbrico en todas las áreas';
EXEC sp_AgregarEstablecimientoServicio 'Parqueo', 'Área de estacionamiento para vehículos';
EXEC sp_AgregarEstablecimientoServicio 'Restaurante', 'Servicio de comida en el establecimiento';
EXEC sp_AgregarEstablecimientoServicio 'Bar', 'Bar con bebidas y snacks disponibles';
EXEC sp_AgregarEstablecimientoServicio 'Ranchos', 'Áreas de ranchos para eventos al aire libre';


-- Tipos de establecimientos
EXEC sp_AgregarEstablecimientoTipo 'Hotel';
EXEC sp_AgregarEstablecimientoTipo 'Hostal';
EXEC sp_AgregarEstablecimientoTipo 'Casa';
EXEC sp_AgregarEstablecimientoTipo 'Departamento';
EXEC sp_AgregarEstablecimientoTipo 'Cuarto Compartido';
EXEC sp_AgregarEstablecimientoTipo 'Cabana';


-- Comodidades de tipos de habitación
EXEC sp_AgregarHabitacionComodidad 'Wifi de habitación';
EXEC sp_AgregarHabitacionComodidad 'A/C';
EXEC sp_AgregarHabitacionComodidad 'Ventilador';
EXEC sp_AgregarHabitacionComodidad 'Agua caliente';


-- Camas de tipos de habitación
EXEC sp_AgregarHabitacionCama 'Individual', 'Cama para una persona';
EXEC sp_AgregarHabitacionCama 'Matrimonial', 'Cama doble estándar';
EXEC sp_AgregarHabitacionCama 'Queen', 'Cama queen size';
EXEC sp_AgregarHabitacionCama 'King', 'Cama king size';
EXEC sp_AgregarHabitacionCama 'Doble Individual', 'Dos camas individuales';
EXEC sp_AgregarHabitacionCama 'Doble Matrimonial', 'Dos camas matrimoniales';


-- Tipos de habitación
DECLARE @id_individual INT, @id_matrimonial INT, @id_queen INT, @id_king INT, @id_doble_ind INT, @id_doble_mat INT;

SELECT @id_individual = id_habitacion_cama FROM Habitacion_Cama WHERE nombre = 'Individual';
SELECT @id_matrimonial = id_habitacion_cama FROM Habitacion_Cama WHERE nombre = 'Matrimonial';
SELECT @id_queen = id_habitacion_cama FROM Habitacion_Cama WHERE nombre = 'Queen';
SELECT @id_king = id_habitacion_cama FROM Habitacion_Cama WHERE nombre = 'King';
SELECT @id_doble_ind = id_habitacion_cama FROM Habitacion_Cama WHERE nombre = 'Doble Individual';
SELECT @id_doble_mat = id_habitacion_cama FROM Habitacion_Cama WHERE nombre = 'Doble Matrimonial';

EXEC sp_AgregarHabitacionTipo 'Estandar', 'Habitación estándar con comodidades básicas', 50.00, 2, @id_individual;
EXEC sp_AgregarHabitacionTipo 'Superior', 'Habitación superior con mejores vistas y amenities', 75.00, 2, @id_matrimonial;
EXEC sp_AgregarHabitacionTipo 'Deluxe', 'Habitación de lujo con amplio espacio y comodidades premium', 120.00, 2, @id_queen;
EXEC sp_AgregarHabitacionTipo 'Exclusiva', 'Habitación exclusiva con servicios personalizados', 200.00, 2, @id_king;
EXEC sp_AgregarHabitacionTipo 'Suite', 'Suite amplia con sala de estar y dormitorio separado', 250.00, 4, @id_doble_mat;


-- Tipos de identificación de clientes
EXEC sp_AgregarClienteIdentificacion 'Cédula Nacional';
EXEC sp_AgregarClienteIdentificacion 'Pasaporte';
EXEC sp_AgregarClienteIdentificacion 'Licencia de Conducir';
EXEC sp_AgregarClienteIdentificacion 'DIMEX';
EXEC sp_AgregarClienteIdentificacion 'Cédula de Residencia';
GO

-- Métodos de pago para facturación
EXEC sp_AgregarFacturacionMetodoPago 'Efectivo';
EXEC sp_AgregarFacturacionMetodoPago 'Tarjeta de crédito';
EXEC sp_AgregarFacturacionMetodoPago 'Tarjeta de débito';
EXEC sp_AgregarFacturacionMetodoPago 'Transferencia bancaria';
EXEC sp_AgregarFacturacionMetodoPago 'PayPal';


-- Servicios de actividades de recreación
EXEC sp_AgregarRecreacionServicio 'Guía turístico', 'Incluye guía profesional durante la actividad';
EXEC sp_AgregarRecreacionServicio 'Equipo incluido', 'Todo el equipo necesario para la actividad';
EXEC sp_AgregarRecreacionServicio 'Comida incluida', 'Incluye alimentos durante la actividad';
EXEC sp_AgregarRecreacionServicio 'Transporte incluido', 'Transporte desde/hacia el hotel incluido';
EXEC sp_AgregarRecreacionServicio 'Seguro', 'Seguro contra accidentes incluido';
EXEC sp_AgregarRecreacionServicio 'Fotografía', 'Servicio fotográfico profesional incluido';


-- Tipos de actividades de recreación
EXEC sp_AgregarRecreacionTipo 'Senderismo';
EXEC sp_AgregarRecreacionTipo 'Tour en lancha';
EXEC sp_AgregarRecreacionTipo 'Tour en catamarán';
EXEC sp_AgregarRecreacionTipo 'Kayak';
EXEC sp_AgregarRecreacionTipo 'Visita a Museo';
EXEC sp_AgregarRecreacionTipo 'Visita a cataratas';
EXEC sp_AgregarRecreacionTipo 'Tour cultural';
EXEC sp_AgregarRecreacionTipo 'Tour gastronómico';
