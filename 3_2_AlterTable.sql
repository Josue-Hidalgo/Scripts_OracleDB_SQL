-- 0. Conexión al esquema GE
CONNECT GE/GE@OracleDB;

-- 1. MODIFICAR columnas existentes
ALTER TABLE TableName MODIFY (
    FirstAttribute VARCHAR2(100),  -- Cambiar tamaño
    Code VARCHAR2(30) CONSTRAINT Code_nn NOT NULL,  -- Cambiar tamaño y mantener constraint
    Email VARCHAR2(150) NULL  -- Hacer columna nullable
);

-- 2. AGREGAR nuevas columnas
ALTER TABLE TableName ADD (
    PhoneNumber VARCHAR2(20),
    DateOfBirth DATE,
    IsVerified CHAR(1) DEFAULT 'N'
);

-- 3. AGREGAR nuevos constraints
ALTER TABLE TableName ADD (
    CONSTRAINT UK_TableName_Phone UNIQUE (PhoneNumber),
    CONSTRAINT CK_TableName_IsVerified CHECK (IsVerified IN ('Y', 'N'))
);

-- 4. ELIMINAR constraints
ALTER TABLE TableName DROP CONSTRAINT CK_TableName_FirstAttribute;
ALTER TABLE TableName DROP CONSTRAINT UK_TableName_Email;

-- 5. RENOMBRAR elementos
ALTER TABLE TableName RENAME COLUMN Email TO EmailAddress;
ALTER TABLE TableName RENAME CONSTRAINT PK_TableName TO PK_TableName_Main;

-- 6. HABILITAR/DESHABILITAR constraints
ALTER TABLE TableName DISABLE CONSTRAINT CK_TableName_Age;
ALTER TABLE TableName ENABLE CONSTRAINT CK_TableName_Age;

-- 7. ELIMINAR columnas
ALTER TABLE TableName DROP COLUMN PhoneNumber;
ALTER TABLE TableName DROP (DateOfBirth, IsVerified);  -- Múltiples columnas

-- 8. AGREGAR particiones (si la tabla es particionada)
ALTER TABLE TableName ADD PARTITION SALES_Q2_1999 
VALUES LESS THAN (TO_DATE('01-JUL-1999','DD-MON-YYYY'));

-- 9. MODIFICAR storage parameters
ALTER TABLE TableName STORAGE (NEXT 1M);
ALTER TABLE TableName MOVE TABLESPACE GE_DATA_NEW;

-- 10. TRUNCAR tabla (eliminar todos los datos)
ALTER TABLE TableName TRUNCATE PARTITION nombre_particion;  -- Si es particionada
-- TRUNCATE TABLE TableName;  -- Para tabla no particionada

-- 11. READ ONLY / READ WRITE
ALTER TABLE TableName READ ONLY;   -- Hacer tabla solo lectura
ALTER TABLE TableName READ WRITE;  -- Volver a lectura/escritura