-- 0. Conexión al esquema GE
CONNECT GE/GE@OracleDB;

-- 1. Crear tabla
CREATE TABLE NombreTabla (
    -- 1.* Se le agregan los CONSTRAINT 
    IdNombreTabla NUMBER CONSTRAINT IdNombreTabla_nn NOT NULL,
    IdNombreTablaRelacionada NUMBER,
    PrimerAtributo VARCHAR2(50),
    -- 2. Crear PKs
    CONSTRAINT PK_NombreTabla PRIMARY KEY (IdNombreTabla)
        USING INDEX TABLESPACE GE_INDEX,
    -- 3. Crear FKs (CORREGIDO: era "PKs" pero es FOREIGN KEY)
    CONSTRAINT FK_NombreTablaRelacionada FOREIGN KEY (IdNombreTablaRelacionada)
        REFERENCES OtraTabla(IdOtraTabla) -- FALTABA: tabla y columna de referencia
) TABLESPACE GE_DATA;

-- 4. Create Sequences
CREATE SEQUENCE SEQ_NombreTabla
START WITH 1
INCREMENT BY 1
MINVALUE 0
NOCACHE
NOCYCLE;