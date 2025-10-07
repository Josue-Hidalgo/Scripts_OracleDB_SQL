SELECT e.nombre
FROM estudiantes e
WHERE NOT EXISTS (
    SELECT c.id_curso
    FROM cursos c
    WHERE NOT EXISTS (
        SELECT 1
        FROM estudiantes_cursos ec
        WHERE ec.id_estudiante = e.id_estudiante
          AND ec.id_curso = c.id_curso
    )
);

/*
    Explicación paso a paso:

    Subconsulta interna
    Busca cursos que el estudiante no ha matriculado.

    Segunda subconsulta (NOT EXISTS externo)
    Si no existen cursos que el estudiante no haya matriculado,
    significa que sí está en todos los cursos → cumple la condición.
*/


-- O también...

SELECT e.nombre
FROM estudiantes e
JOIN estudiantes_cursos ec ON e.id_estudiante = ec.id_estudiante
GROUP BY e.nombre
HAVING COUNT(DISTINCT ec.id_curso) = (SELECT COUNT(*) FROM cursos);

/*
    “Dame los estudiantes que tienen tantos cursos distintos como cursos existen en total.”
*/