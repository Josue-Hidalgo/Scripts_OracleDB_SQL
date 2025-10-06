-- 0. Conexión al esquema GE
CONNECT GE/GE@OracleDB;

-- 1. Crear tabla
CREATE TABLE TableName (
    -- 1.1 Campos principales con CONSTRAINTS
    TableNameId NUMBER 
        CONSTRAINT TableNameId_nn NOT NULL,
    
    RelatedTableId NUMBER,

    FirstAttribute VARCHAR2(50)
        CONSTRAINT FirstAttribute_nn NOT NULL,
    
    Code VARCHAR2(20)
        CONSTRAINT Code_nn NOT NULL,
    
    Email VARCHAR2(100),
    
    Age NUMBER,
    
    Status VARCHAR2(20) DEFAULT 'ACTIVE'
        CONSTRAINT Status_nn NOT NULL,

    -- 1.2 Campos de Auditoría
    CreationDate TIMESTAMP 
        CONSTRAINT CreationDate_nn NOT NULL,
    CreatedBy VARCHAR2(100) 
        CONSTRAINT CreatedBy_nn NOT NULL,
    UpdatedBy VARCHAR2(100) 
        CONSTRAINT UpdatedBy_nn NOT NULL,
    UpdateDate TIMESTAMP 
        CONSTRAINT UpdateDate_nn NOT NULL,

    -- 2. CONSTRAINTS a nivel de tabla
    -- 2.1 PRIMARY KEY
    CONSTRAINT PK_TableName PRIMARY KEY (TableNameId)
        USING INDEX TABLESPACE GE_INDEX,
    
    -- 2.2 FOREIGN KEYS
    CONSTRAINT FK_TableName_Related FOREIGN KEY (RelatedTableId)
        REFERENCES OtherTable(OtherTableId)
        ON DELETE SET NULL,

    -- 2.3 UNIQUE Constraints
    CONSTRAINT UK_TableName_Code UNIQUE (Code)
        USING INDEX TABLESPACE GE_INDEX,
    
    CONSTRAINT UK_TableName_Email UNIQUE (Email)
        USING INDEX TABLESPACE GE_INDEX,
    
    -- 2.4 CHECK Constraints
    CONSTRAINT CK_TableName_Age CHECK (Age BETWEEN 0 AND 150),
    
    CONSTRAINT CK_TableName_Status CHECK (Status IN ('ACTIVE', 'INACTIVE', 'PENDING')),
    
    CONSTRAINT CK_TableName_FirstAttribute CHECK (LENGTH(FirstAttribute) >= 2)
    
) TABLESPACE GE_DATA;

ALTER TABLE TableName

-- 3. Crear INDEX (OPCIONAL)
CREATE INDEX IX_TableName_FirstAttribute ON GE.TableName(FirstAttribute)
    TABLESPACE GE_INDEX;

CREATE INDEX IX_TableName_Status ON GE.TableName(Status)
    TABLESPACE GE_INDEX;

-- 4. Create Sequences
CREATE SEQUENCE SEQ_TableName
START WITH 1
INCREMENT BY 1
MINVALUE 0
NOCACHE
NOCYCLE;

-- 5. Triggers

-- 5.1 Asignar PK Automáticamente (OPCIONAL)
CREATE OR REPLACE TRIGGER GE.BI_TableName_PK
BEFORE INSERT ON GE.TableName
FOR EACH ROW
BEGIN
    IF :new.TableNameId IS NULL THEN
        :new.TableNameId := SEQ_TableName.NEXTVAL;
    END IF;
END;
/

-- 5.2 Campos de Auditoría
CREATE OR REPLACE TRIGGER GE.BI_TableName_Audit
BEFORE INSERT ON GE.TableName
FOR EACH ROW
BEGIN 
    :new.CreatedBy := USER;
    :new.CreationDate := SYSTIMESTAMP;
    :new.UpdatedBy := USER;
    :new.UpdateDate := SYSTIMESTAMP;
END BI_TableName_Audit;
/

CREATE OR REPLACE TRIGGER GE.BU_TableName_Audit
BEFORE UPDATE ON GE.TableName
FOR EACH ROW
BEGIN 
    :new.UpdatedBy := USER;
    :new.UpdateDate := SYSTIMESTAMP;
END BU_TableName_Audit;
/

-- 7. Comentarios para documentación
COMMENT ON TABLE GE.TableName               IS 'Tabla plantilla para demostrar constraints en Oracle';
COMMENT ON COLUMN GE.TableName.TableNameId  IS 'Identificador único de la tabla (PK)';
COMMENT ON COLUMN GE.TableName.Codigo       IS 'Código único del registro';
COMMENT ON COLUMN GE.TableName.Email        IS 'Dirección de email única';
COMMENT ON COLUMN GE.TableName.Estado       IS 'Estado del registro: ACTIVO, INACTIVO, PENDIENTE';