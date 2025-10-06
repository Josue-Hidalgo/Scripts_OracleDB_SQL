-- Trigger son parecidos a Funciones.
-- Estos se ejecutan automáticamente.
-- Dentro de Funcionalidad de Seguridad

-- Campos de Auditoría (en Tabla Modificada)
CREATE OR REPLACE TRIGGER GE.BeforeInsertTableName
BEFORE INSERT 
ON GE.TableName 
FOR EACH ROW
BEGIN 
    :new.create_by := USER;
    :new.creation_date := SYSDATE;
END BeforeInsertTableName;

CREATE OR REPLACE TRIGGER GE.BeforeUpdateTableName
BEFORE UPDATE 
ON GE.TableName 
FOR EACH ROW
BEGIN 
    :new.update_by := USER;
    :new.update_date := SYSDATE;
END BeforeUpdateTableName;


-- Bitácora de Auditoría
-- Se podría guardar el Id_Usuario en caso de ser necesario
-- Debería estar encapsulado y debería invocar es método
-- dentro de GE para insertar en Bitácora
-- ¿Eliminar datos? Puede ser tabla respaldo (No guardar todo)
-- Se borra algo que no se usa mucho se borran, pero se guardan en una tabla respaldo 
-- y luego se usaría en otro momento si se quieren atraer los Usuario o pero
CREATE OR REPLACE TRIGGER BeforeUpdateSalary
BEFORE INSERT OR UPDATE
OF Salary 
ON Employee
FOR EACH ROW
BEGIN 
    INSERT INTO Bitacora (Id,
    nom_esquema,    nom_tabla,
    nom_campo,      fec_cambio,
    valor_anterior, valor_actual)
    VALUES (s_bitacora.nextval, "GE", "EMPLOYEE", "SALARY", 
    SYSDATE, :old.salary, :new.salary
    );

-- INSERT, UPDATE, DELETE (UNO no cae en otro)