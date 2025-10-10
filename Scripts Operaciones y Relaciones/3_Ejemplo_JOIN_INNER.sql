SELECT e.nombre, d.nombre_depto
FROM empleados e
INNER JOIN departamentos d
ON e.id_departamento = d.id_departamento;

-- Devuelve solo las filas que coinciden en ambas 
-- tablas según la condición.