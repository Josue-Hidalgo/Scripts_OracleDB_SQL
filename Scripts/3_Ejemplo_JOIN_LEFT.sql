SELECT e.nombre, d.nombre_depto
FROM empleados e
LEFT JOIN departamentos d
ON e.id_departamento = d.id_departamento;

-- Devuelve todas las filas de la tabla izquierda y
-- las coincidentes de la derecha. Las que no coinciden 
-- aparecen con NULL.