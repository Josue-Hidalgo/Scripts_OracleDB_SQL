-- 1. Crear usuario con privilegios completos para desarrollo
CREATE USER GE 
     IDENTIFIED BY GE
     DEFAULT TABLESPACE GE_DATA
     TEMPORARY TABLESPACE GE_TEMP
     QUOTA 10M ON GE_DATA
     QUOTA 5M ON system;
     --QUOTA UNLIMITED ON GE_DATA
     --QUOTA UNLIMITED ON GE_INDEX
     --ACCOUNT UNLOCK;

-- 2. Paquete básico de privilegios para desarrollo
GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW, CREATE SEQUENCE TO GE;
GRANT CREATE PROCEDURE, CREATE TRIGGER, CREATE TYPE, CREATE SYNONYM TO GE;
GRANT UNLIMITED TABLESPACE TO GE;

-- 3. Privilegios adicionales útiles (opcionales)
GRANT CREATE MATERIALIZED VIEW TO GE;
GRANT CREATE JOB TO GE;
GRANT DEBUG CONNECT SESSION TO GE;

-- Mensaje de Confirmación
PROMPT ====================================;
PROMPT CONFIGURACIÓN COMPLETADA EXITOSAMENTE;
PROMPT ====================================;
PROMPT Usuario GE creado exitosamente;
PROMPT ;
PROMPT Credenciales: GE/GE;
PROMPT Tablespace PerDefault: GE_DATA;
PROMPT Tablespace Temporal: GE_TEMP;
PROMPT ;
PROMPT Conectar con:;
PROMPT sqlplus GE/GE@OracleDB;
PROMPT ====================================;