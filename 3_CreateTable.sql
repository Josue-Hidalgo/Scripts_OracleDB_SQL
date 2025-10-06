-- 0. Conexion al esquema GE
CONNECT GE/GE@OracleDB;

-- 1. Crear tabla
CREATE TABLE NombreTabla (
    -- 1.1 CONSTRAINT para atributos obligatorios
    IdNombreTabla NUMBER CONSTRAINT IdNombreTabla_nn NOT NULL,
    IdNombreTablaRelacionada NUMBER,
    PrimerAtributo VARCHAR2(50),
    -- 2. Crear PKs
    CONSTRAINT PK_NombreTabla PRIMARY KEY (IdNombreTabla)
        USING INDEX TABLESPACE GE_INDEX;
    -- 3. Crear PKs
    CONSTRAINT FK_NombreTablaRelacionada FOREIGN KEY (IdNombreTablaRelacionada)
        REFERENCES TABLESPACE GE_INDEX;
) TABLESPACE GE_DATA;

-- 4. Create Sequences
CREATE SEQUENCE TypeIdentification
START WITH 0
INCREMENT BY 1
MINVALUE 0
NOCACHE
NOCYCLE;
