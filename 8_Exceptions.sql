-- =============================================
-- ¿QUÉ SON LAS EXCEPCIONES?
-- =============================================
-- Son errores que ocurren durante la ejecución 
-- y que pueden ser capturados/manejados
-- de forma controlada

-- OBJETIVO: Evitar que los programas terminen
-- abruptamente y proporcionar manejo elegante
-- de errores

-- =============================================
-- PROBLEMA: Función vulnerable a errores
-- =============================================
CREATE OR REPLACE FUNCTION GetLastName (
    PCNombre IN VARCHAR2
)
RETURN VARCHAR2
IS
    VCLastName VARCHAR2(15);
BEGIN
    SELECT LastName
    INTO VCLastName
    FROM Employee
    WHERE FirstName = PCNombre;
    
    RETURN VCLastName;
END GetLastName;
/

-- ⚠️ POSIBLES ERRORES:
-- • TOO_MANY_ROWS si hay múltiples empleados con mismo nombre
-- • NO_DATA_FOUND si no existe el empleado

-- =============================================
-- ERROR TÍPICO: TOO_MANY_ROWS
-- =============================================
-- Al ejecutar: 
SELECT GetLastName('Juan') FROM dual;

-- RESULTADO:
-- ORA-01422: exact fetch returns more than requested number of rows
-- (La consulta retorna más filas de las esperadas)

-- CAUSA: Múltiples empleados se llaman 'Juan'
-- SOLUCIÓN: Manejar la excepción TOO_MANY_ROWS

-- =============================================
-- SOLUCIÓN: Manejo completo de excepciones
-- =============================================
CREATE OR REPLACE FUNCTION GetLastName (
    PCNombre IN VARCHAR2
)
RETURN VARCHAR2
IS
    VCLastName VARCHAR2(15);
BEGIN
    SELECT LastName
    INTO VCLastName
    FROM Employee
    WHERE FirstName = PCNombre;
    
    RETURN VCLastName;

EXCEPTION
    WHEN TOO_MANY_ROWS THEN
        DBMS_OUTPUT.PUT_LINE('Error: Múltiples empleados con el nombre ' || PCNombre);
        RETURN NULL;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontró empleado con nombre: ' || PCNombre);
        RETURN NULL;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
        RETURN NULL;
END GetLastName;
/

-- =============================================
-- EXCEPCIONES DEFINIDAS POR EL USUARIO
-- =============================================
CREATE OR REPLACE PROCEDURE UpdateDepartmentName (
    PNIdDepartment NUMBER, 
    PCDepartmentName VARCHAR2
) 
IS
    EInvalidDept EXCEPTION;  -- Declarar excepción personalizada
BEGIN
    UPDATE Department
    SET DepartmentName = PCDepartmentName
    WHERE DepartmentId = PNIdDepartment;

    -- Verificar si se actualizó algún registro
    IF SQL%NOTFOUND THEN
        RAISE EInvalidDept;  -- Lanzar excepción personalizada
    END IF;

    COMMIT;

EXCEPTION
    WHEN EInvalidDept THEN
        DBMS_OUTPUT.PUT_LINE('Error: No existe departamento con ID ' || PNIdDepartment);
        DBMS_OUTPUT.PUT_LINE('SQLERRM: ' || SQLERRM);   -- Mensaje de error
        DBMS_OUTPUT.PUT_LINE('SQLCODE: ' || SQLCODE);   -- Código de error
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
        ROLLBACK;
END UpdateDepartmentName;
/

-- =============================================
-- MANEJO DE DIVISIÓN POR CERO
-- =============================================
CREATE OR REPLACE PROCEDURE CrearPromedioEstudiante (
    PNIdEstudiante NUMBER
)
IS
    VNPromedio NUMBER(3,2);
    VNTotalEvaluaciones NUMBER;
BEGIN
    -- Esta consulta puede causar ZERO_DIVIDE
    SELECT SUM(Nota) / COUNT(*) 
    INTO VNPromedio 
    FROM Evaluation 
    WHERE IdEstudiante = PNIdEstudiante;

    INSERT INTO Estadistica(IdEstudiante, Promedio) 
    VALUES (PNIdEstudiante, VNPromedio); 
    
    COMMIT;

EXCEPTION 
    WHEN ZERO_DIVIDE THEN
        -- Manejo específico para división por cero
        DBMS_OUTPUT.PUT_LINE('Error: El estudiante no tiene evaluaciones.');
        ROLLBACK;
    WHEN OTHERS THEN
        -- Manejo de cualquier otro error
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
        ROLLBACK;
END CrearPromedioEstudiante;
/

-- =============================================
-- EXCEPCIONES PREDEFINIDAS MÁS COMUNES
-- =============================================

/*
Exception           Oracle Error    SQLCODE    Descripción
-----------------   ------------    -------    ----------------------------
NO_DATA_FOUND       ORA-01403       +100       No se encontraron datos
TOO_MANY_ROWS       ORA-01422       -1422      Múltiples filas retornadas
ZERO_DIVIDE         ORA-01476       -1476      División por cero
INVALID_NUMBER      ORA-01722       -1722      Conversión numérica inválida
DUP_VAL_ON_INDEX    ORA-00001       -1         Violación de índice único
VALUE_ERROR         ORA-06502       -6502      Error de valor o conversión
CURSOR_ALREADY_OPEN ORA-06511       -6511      Cursor ya abierto
TIMEOUT_ON_RESOURCE ORA-00051       -51        Timeout en recurso
STORAGE_ERROR       ORA-06500       -6500      Error de almacenamiento
PROGRAM_ERROR       ORA-06501       -6501      Error interno de PL/SQL
*/

-- USO EN CÓDIGO:
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        -- Manejar caso de no encontrar datos
    WHEN TOO_MANY_ROWS THEN
        -- Manejar múltiples filas
    WHEN OTHERS THEN
        -- Manejar cualquier otro error


-- =============================================
-- MEJORES PRÁCTICAS EN MANEJO DE EXCEPCIONES
-- =============================================

-- 1. SIEMPRE manejar excepciones específicas primero
EXCEPTION
    WHEN NO_DATA_FOUND THEN ...  -- Específico
    WHEN TOO_MANY_ROWS THEN ...  -- Específico  
    WHEN OTHERS THEN ...         -- General

-- 2. USAR ROLLBACK en manejo de excepciones
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;  -- Revertir cambios no confirmados

-- 3. PROPORCIONAR mensajes informativos
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);

-- 4. REGISTRAR errores en tablas de log si es necesario

-- 5. EVITAR bloques EXCEPTION vacíos
    -- ❌ MAL: 
    EXCEPTION WHEN OTHERS THEN NULL;
    -- ✅ BIEN:
    EXCEPTION WHEN OTHERS THEN 
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);

-- =============================================
-- ESTRUCTURA GENERAL RECOMENDADA
-- =============================================
CREATE OR REPLACE PROCEDURE MiProcedimiento IS
BEGIN
    -- Lógica principal aquí
    ...
EXCEPTION
    WHEN Exception_Específica THEN
        -- Manejo específico
    WHEN OTHERS THEN
        -- Manejo general con rollback
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END MiProcedimiento;
/