SELECT e.nombre, d.nombre_depto
FROM empleados e
FULL JOIN departamentos d
ON e.id_departamento = d.id_departamento;

-- Devuelve todas las filas de
-- ambas tablas, coincidan o no.