-- 1. Crear usuario 

CREATE USER GE 
     IDENTIFIED BY GE
     DEFAULT TABLESPACE GE_DATA
     QUOTA 10M ON GE_DATA
     TEMPORARY TABLESPACE TEMP
     QUOTA 5M ON system;

-- 2. Otorgar privilegios necesarios al usuario
GRANT CREATE SESSION TO GE;
GRANT CREATE TABLE TO GE;
GRANT CREATE VIEW TO GE;
GRANT CREATE SEQUENCE TO GE;
GRANT CREATE PROCEDURE TO GE;

-- Mensaje de Confirmación
PROMPT ====================================;
PROMPT CONFIGURACIÓN COMPLETADA EXITOSAMENTE;
PROMPT ====================================;
PROMPT Usuario creado: GE/GE;
PROMPT ;
PROMPT Conectarse ahora con:;
PROMPT sqlplus GE/GE@OracleDB;
PROMPT ====================================;