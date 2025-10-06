-- 1. Crear Tablespace para Datos
CREATE TABLESPACE GE_DATA
     DATAFILE 'C:\app\josueshs\oradata\OracleDB\GE_DATA.DBF'
     SIZE 10M
     REUSE
     AUTOEXTEND ON
     NEXT 512K
     MAXSIZE 200M;

-- 2. Crear Tablespace para Índices
CREATE TABLESPACE GE_INDEX
     DATAFILE 'C:\app\josueshs\oradata\OracleDB\GE_INDEX.DBF'
     SIZE 10M
     REUSE
     AUTOEXTEND ON
     NEXT 512K
     MAXSIZE 200M;

-- 3. Crear Tablespace para Temporary Files (Opcional)
CREATE TABLESPACE GE_TEMP
     DATAFILE 'C:\app\josueshs\oradata\OracleDB\GE_TEMP.DBF'
     SIZE 10M
     REUSE
     AUTOEXTEND ON
     NEXT 512K
     MAXSIZE 200M;

-- Mensaje de Confirmación

PROMPT ====================================;
PROMPT CONFIGURACIÓN COMPLETADA EXITOSAMENTE;
PROMPT ====================================;
PROMPT Tablespaces creados:;
PROMPT - GE_DATA;
PROMPT - GE_INDEX;
PROMPT ====================================;
