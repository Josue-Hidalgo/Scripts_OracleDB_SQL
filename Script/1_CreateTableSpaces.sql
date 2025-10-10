-- 1. Crear Tablespace para Datos
CREATE TABLESPACE GE_DATA
    DATAFILE 'C:\app\josueshs\oradata\OracleDB\GE_DATA.DBF'
    SIZE 10M
    REUSE
    AUTOEXTEND ON NEXT 512K MAXSIZE 200M
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- 2. Crear Tablespace para Índices
CREATE TABLESPACE GE_INDEX
    DATAFILE 'C:\app\josueshs\oradata\OracleDB\GE_INDEX.DBF'
    SIZE 10M
    REUSE
    AUTOEXTEND ON NEXT 512K MAXSIZE 200M
    EXTENT MANAGEMENT LOCAL
    SEGMENT SPACE MANAGEMENT AUTO;

-- 3. CORREGIR: Tablespace Temporal
CREATE TEMPORARY TABLESPACE GE_TEMP
    TEMPFILE 'C:\app\josueshs\oradata\OracleDB\GE_TEMP.DBF'
    SIZE 10M
    AUTOEXTEND ON NEXT 512K MAXSIZE 200M;

-- Mensaje de Confirmación
PROMPT ====================================;
PROMPT CONFIGURACIÓN COMPLETADA EXITOSAMENTE;
PROMPT ====================================;
PROMPT Tablespaces creados:;
PROMPT - GE_DATA (Datos);
PROMPT - GE_INDEX (Índices);
PROMPT - GE_TEMP (Temporal);
PROMPT ====================================;