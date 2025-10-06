
-- Funciones vs Procedimientos
/*
    Procedimientos Almacenados (Stored Procedures)
        Realizan acciones (INSERT, UPDATE, DELETE)
        No retornan valores directamente
        Pueden tener parámetros de entrada (IN) y salida (OUT)
        Ejecutan transacciones

    Funciones (Functions)
        Retornan un valor
        Se usan principalmente para cálculos y consultas
        Pueden usarse en sentencias SELECT
*/

-- Packages
/*
    Agrupan procedimientos y funciones relacionados
*/

-- Beneficios
/*
    Reutilización: Escribir una vez, usar muchas veces
    Seguridad: Control de acceso a través de permisos
    Mantenibilidad: Cambios centralizados
    Rendimiento: Ejecución más rápida
    Encapsulamiento: Ocultar la lógica compleja
*/

-- ¿Cuándo usar?
/*
    Procedimiento: Para operaciones que modifican datos
    Función: Para obtener y retornar valores específicos
    Paquete: Para agrupar funcionalidades relacionadas
*/

-- Procedures

-- 1.
CREATE PROCEDURE RemoveEmployee (
    PIdEmployee IN NUMBER
)
AS
BEGIN
    DELETE FROM Employee
    WHERE IdEmployee = PIdEmployee;
    COMMIT;
END RemoveEmployee;

-- 2.
CREATE OR REPLACE PROCEDURE InsertEmployee (
    PCFirstName IN VARCHAR2, 
    PCFirstLastName IN VARCHAR2
)
AS
BEGIN
    INSERT INTO Employee(IdEmployee, FirstName, FirstLastName)
    VALUES (S_Employee.NEXTVAL, PCFirstName, PCFirstLastName);
    COMMIT;
END InsertEmployee;

-- Function

-- 1.
CREATE FUNCTION GetEmployeeName (
    PId IN NUMBER
)
RETURN VARCHAR2
IS
    VCName VARCHAR2(30);
BEGIN
    SELECT Name
    INTO VCName
    FROM Employee
    WHERE Id = PId;
    RETURN (VCName);
END GetEmployeeName;

-- 2.
CREATE FUNCTION GetEmployeeName (
    PId IN NUMBER
)
RETURN VARCHAR2
IS
    VCName VARCHAR2(30);
BEGIN
    SELECT Name
    INTO VCName
    FROM Employee
    WHERE Id = PId;
    RETURN (VCName);
END GetEmployeeName;

-- Packages
CREATE OR REPLACE PACKAGE AdmtnEmployee IS

    PROCEDURE HireEmployee (
        PCLastName VARCHAR2, 
        PNIdJob NUMBER, 
        PNManager NUMBER, 
        PNSalary NUMBER, 
        PNPercentCommission NUMBER, 
        PNIdDepartment NUMBER
    );

    PROCEDURE CreateDepartment(PCDepartmentName VARCHAR2);
    PROCEDURE RemoveEmployee(PNIdEmployee NUMBER);
    PROCEDURE RemoveDepartment(PNIdDepartment NUMBER);
    PROCEDURE IncreaseSalary(PNIdEmployee NUMBER, PNSalaryIncrement NUMBER);
    PROCEDURE IncreaseComm(PIdEmployee NUMBER, PNCommIncrement NUMBER);

END AdmtnEmployee;

-- Cuerpo de Package
CREATE OR REPLACE PACKAGE BODY AdmtnEmployee AS

PROCEDURE HireEmployee (
    PCLastName VARCHAR2, 
    PNIdJob NUMBER, 
    PNManager NUMBER,  
    PNSalary NUMBER, 
    PNPercentCommission NUMBER, 
    PNIdDepartment NUMBER
)
IS  
BEGIN  
    INSERT INTO Employee (
        IdEmployee, 
        LastName, 
        Email, 
        Job, 
        Manager, 
        Salary,  
        PercentCommission, 
        IdDepartment
    )  
    VALUES (
        Employee_Seq.NEXTVAL, 
        PCLastName, 
        LastName || '@oracle.com', 
        PNIdJob,  
        PNManager, 
        PNSalary, 
        PNPercentCommission, 
        PNIdDepartment
    );
    COMMIT;
END;

PROCEDURE CreateDepartment (
    PCDepartmentName IN VARCHAR2
)
IS
BEGIN
    INSERT INTO Department (Id, Name)
    VALUES (S_Department.NEXTVAL, PCDepartmentName);
    COMMIT;
END;

PROCEDURE RemoveEmployee (
    PNIdEmployee NUMBER
)
IS
BEGIN
    DELETE FROM Employee
    WHERE IdEmployee = PNIdEmployee;
    COMMIT;
END;

END AdmtnEmployee;