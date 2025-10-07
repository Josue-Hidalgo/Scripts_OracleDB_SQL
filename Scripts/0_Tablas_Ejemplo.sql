-- TABLAS DE EJEMPLO

CREATE TABLE empleados_tienda (
    id_empleado NUMBER,
    nombre VARCHAR2(50),
    puesto VARCHAR2(50)
);

CREATE TABLE empleados_oficina (
    id_empleado NUMBER,
    nombre VARCHAR2(50),
    puesto VARCHAR2(50)
);

-- INSERSIÓN DE DATOS

-- Tabla empleados_tienda
INSERT INTO empleados_tienda (id_empleado, nombre, puesto)
VALUES (1, 'Ana López', 'Vendedora');

INSERT INTO empleados_tienda (id_empleado, nombre, puesto)
VALUES (2, 'Juan Pérez', 'Cajero');

-- Tabla empleados_oficina
INSERT INTO empleados_oficina (id_empleado, nombre, puesto)
VALUES (3, 'Carlos Mora', 'Contador');

INSERT INTO empleados_oficina (id_empleado, nombre, puesto)
VALUES (4, 'Ana López', 'Vendedora');


-- VERIFIQUE DATOS CON ESTO

SELECT * FROM empleados_tienda;
SELECT * FROM empleados_oficina;
