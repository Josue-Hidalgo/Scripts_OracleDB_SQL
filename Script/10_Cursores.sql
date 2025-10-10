-- RESUMEN CLASE: CURSORES EN PL/SQL
-- =================================

-- CONCEPTO BÁSICO DE CURSORES
-- ===========================
/*
Un cursor es un objeto en memoria RAM que contiene las filas producto 
de ejecutar una consulta a la base de datos dentro de un programa de aplicación.
Es un puntero que se posiciona en una tupla del conjunto de resultados,
funcionando como una tabla temporal que puede ser recorrida una fila a la vez.
*/

-- EJEMPLO 1: CURSOR BÁSICO CON PARÁMETRO
-- ======================================
-- Cursor que filtra cursos por ID, usando parámetro en la declaración

CREATE OR REPLACE PROCEDURE getCursos(pnIdCurso IN NUMBER)
AS
    -- Declaración del cursor con parámetro
    CURSOR curso(pnIdCurso IN NUMBER)
    IS
        SELECT nombre
        FROM curso
        -- NVL: si pnIdCurso es NULL, muestra todos los cursos
        WHERE curso_id = NVL(pnIdCurso, curso_id);

BEGIN
    -- FOR LOOP automático: abre, fetchea y cierra el cursor automáticamente
    FOR i IN curso(pnIdCurso) LOOP
        DBMS_OUTPUT.PUT_LINE(i.nombre);
    END LOOP;
END getCursos;
/

-- EJEMPLO 2: CURSOR SIN PARÁMETROS CON MÚLTIPLES COLUMNAS
-- =======================================================
-- Cursor que recupera todas las columnas de la tabla curso

CREATE OR REPLACE PROCEDURE getCursos(pnIdCurso IN NUMBER)
AS
    -- Cursor sin parámetros que selecciona múltiples columnas
    CURSOR curso
    IS
        SELECT nombre, creditos, semestre, annio
        FROM curso;

BEGIN
    -- Acceso a múltiples columnas del cursor
    FOR i IN curso LOOP
        DBMS_OUTPUT.PUT_LINE(i.nombre);
        DBMS_OUTPUT.PUT_LINE(i.creditos);
        DBMS_OUTPUT.PUT_LINE(i.semestre||'='||i.annio);
    END LOOP;
END getCursos;
/

-- EJEMPLO 3: CURSOR CON JOIN ENTRE TABLAS
-- =======================================
-- Cursor que realiza un INNER JOIN entre employee y department

CREATE OR REPLACE PROCEDURE getEmployeeForDepartment (pnIdDepartment IN NUMBER)
AS
    -- Cursor con JOIN y parámetro
    CURSOR employeeAndDepartmentCursor(pnIdDepartment IN NUMBER)
    IS
        SELECT employee.first_name as first_name,
               department.name as department_name
        FROM employee
        INNER JOIN department
        ON employee.id_department = department.id_department
        WHERE department.id_department = NVL(pnIdDepartment, department.id_department)
        ORDER BY department.name;

BEGIN
    -- Procesamiento de resultados del JOIN
    FOR i IN employeeAndDepartmentCursor(pnIdDepartment) LOOP
        DBMS_OUTPUT.PUT_LINE(i.first_name);
        DBMS_OUTPUT.PUT_LINE(i.department_name);
    END LOOP;
END getEmployeeForDepartment;
/

-- EJEMPLO 4: CURSOR CON OPEN, FETCH, CLOSE EXPLÍCITOS
-- ===================================================
-- Manejo manual del cursor usando operaciones explícitas

CREATE OR REPLACE PROCEDURE getEmployee (pnIdEmployee IN NUMBER)
AS
    vnIdEmployee NUMBER;
    vcFirstName VARCHAR2(50);  -- Se recomienda especificar longitud

    -- Declaración del cursor
    CURSOR employeeCursor
    IS
        SELECT id_employee, first_name
        FROM employee
        WHERE id_employee = NVL(pnIdEmployee, id_employee);

BEGIN
    OPEN employeeCursor;  -- Abrir cursor explícitamente
    
    LOOP
        FETCH employeeCursor INTO vnIdEmployee, vcFirstName;  -- Recuperar fila
        EXIT WHEN employeeCursor%NOTFOUND;  -- Salir cuando no hay más filas
        DBMS_OUTPUT.PUT_LINE(vnIdEmployee|| '-' ||vcFirstName);
    END LOOP;
    
    CLOSE employeeCursor;  -- Cerrar cursor explícitamente
END getEmployee;
/

-- EJEMPLO 5: CURSOR CON %ROWTYPE
-- ==============================
-- Uso de %ROWTYPE para crear variable que coincide con la estructura del cursor

CREATE OR REPLACE PROCEDURE getEmployee(pnIdEmployee NUMBER)
AS
    -- Declaración del cursor
    CURSOR employee_cursor IS
        SELECT id_employee, first_name
        FROM employee
        WHERE id_employee = NVL(pnIdEmployee, id_employee);

    -- Variable que automáticamente tiene la estructura del cursor
    employee_record employee_cursor%ROWTYPE;

BEGIN
    OPEN employee_cursor;
    LOOP
        FETCH employee_cursor INTO employee_record;
        EXIT WHEN employee_cursor%NOTFOUND;
        -- Insertar en otra tabla usando los datos del cursor
        INSERT INTO employee_view (id, first_name)
        VALUES (employee_record.id_employee, employee_record.first_name);
    END LOOP;
    CLOSE employee_cursor;
END getEmployee;
/

-- EJEMPLO 6: PROCEDIMIENTO CON REF CURSOR (SYS_REFCURSOR)
-- =======================================================
-- Uso de cursores de referencia para devolver resultados

CREATE OR REPLACE PROCEDURE getEmpleados (
    pnIdDepartment IN employee.id_department%TYPE,  -- Tipo basado en columna
    pRecordSet OUT SYS_REFCURSOR                    -- Cursor de salida
)
AS
BEGIN
    -- Abrir cursor de referencia con la consulta
    OPEN pRecordSet FOR
        SELECT first_name, last_name, id_employee, id_department
        FROM employee
        WHERE id_department = NVL(pnIdDepartment, id_department)
        ORDER BY first_name;
END getEmpleados;
/

-- EJEMPLO 7: CÓMO CONSUMIR UN REF CURSOR
-- ======================================
-- Bloque anónimo para probar procedimiento que devuelve REF CURSOR

DECLARE
    vnIdDepartment NUMBER := 1;
    empleados SYS_REFCURSOR;
    vFirst_name VARCHAR2(30);
    vLast_name VARCHAR2(30);
    vEmployee_id NUMBER(6);
    vDepartment_id NUMBER(6);
BEGIN
    -- Llamar al procedimiento que devuelve el cursor
    getEmpleados(vnIdDepartment, empleados);
    
    -- Procesar el cursor devuelto
    LOOP
        FETCH empleados INTO vFirst_name, vLast_name, vEmployee_id, vDepartment_id;
        EXIT WHEN empleados%NOTFOUND;  -- Salir cuando no hay más filas
        DBMS_OUTPUT.PUT_LINE(vFirst_name|| ' | ' ||vLast_name|| ' | ' ||vEmployee_id);
    END LOOP;
    
    CLOSE empleados;  -- IMPORTANTE: cerrar el cursor
END;
/

-- EJEMPLO 8: FUNCIÓN QUE RETORNA CURSOR
-- =====================================
-- Función que devuelve un SYS_REFCURSOR en lugar de procedimiento

CREATE OR REPLACE FUNCTION getCountry(pnIdCountry IN NUMBER)
RETURN SYS_REFCURSOR
AS
    countryCursor SYS_REFCURSOR;
BEGIN
    OPEN countryCursor FOR
        SELECT name
        FROM country
        WHERE id_country = NVL(pnIdCountry, id_country);
    RETURN countryCursor;  -- Devolver cursor abierto
END getCountry;
/

-- ATRIBUTOS DE CURSORES (RESUMEN)
-- ===============================
/*
%ISOPEN    - TRUE si el cursor está abierto
%FOUND     - TRUE si FETCH recuperó una fila exitosamente  
%NOTFOUND  - TRUE si FETCH NO recuperó una fila
%ROWCOUNT  - Número de filas fetcheadas hasta el momento

NOTA: %ROWCOUNT no da el conteo real hasta recorrer todo el cursor
*/

-- MEJORES PRÁCTICAS
-- =================
-- 1. Preferir FOR LOOP para cursores simples (menos código, menos errores)
-- 2. Usar OPEN/FETCH/CLOSE cuando se necesita control explícito
-- 3. Emplear %ROWTYPE para coincidencia automática de tipos
-- 4. Usar SYS_REFCURSOR para devolver resultados a aplicaciones externas
-- 5. SIEMPRE cerrar cursores explícitos y REF CURSOR
-- 6. Especificar longitudes en declaraciones VARCHAR2