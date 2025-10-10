-- Views más comunes

-- View para información básica de usuarios
CREATE OR REPLACE VIEW VW_UserBasicInfo AS
SELECT 
    TableNameId,
    FirstAttribute AS UserName,
    Code AS UserCode,
    Email,
    Status,
    CreationDate AS RegistrationDate
FROM TableName
WHERE Status = 'ACTIVE';

-- Usar la view
SELECT * FROM VW_UserBasicInfo WHERE UserCode LIKE 'EMP%';

-- View para información completa con relaciones
CREATE OR REPLACE VIEW VW_CompleteUserInfo AS
SELECT 
    tn.TableNameId,
    tn.FirstAttribute AS FullName,
    tn.Code AS UserCode,
    tn.Email,
    tn.Age,
    tn.Status,
    ot.OtherTableName AS DepartmentName,  -- Desde otra tabla
    tn.CreationDate,
    tn.CreatedBy
FROM TableName tn
LEFT JOIN OtherTable ot ON tn.RelatedTableId = ot.OtherTableId
WHERE tn.Status IN ('ACTIVE', 'PENDING');

-- View para estadísticas de usuarios
CREATE OR REPLACE VIEW VW_UserStatistics AS
SELECT 
    Status,
    COUNT(*) AS TotalUsers,
    AVG(Age) AS AverageAge,
    MIN(Age) AS MinimumAge,
    MAX(Age) AS MaximumAge,
    COUNT(CASE WHEN Age < 18 THEN 1 END) AS UnderageUsers
FROM TableName
GROUP BY Status;

-- View con datos derivados
CREATE OR REPLACE VIEW VW_UserWithAgeGroup AS
SELECT 
    TableNameId,
    FirstAttribute AS UserName,
    Code,
    Email,
    Age,
    CASE 
        WHEN Age < 18 THEN 'UNDERAGE'
        WHEN Age BETWEEN 18 AND 25 THEN 'YOUNG'
        WHEN Age BETWEEN 26 AND 40 THEN 'ADULT'
        WHEN Age BETWEEN 41 AND 60 THEN 'MATURE'
        ELSE 'SENIOR'
    END AS AgeGroup,
    Status,
    CreationDate
FROM TableName;

-- View que oculta datos sensibles
CREATE OR REPLACE VIEW VW_PublicUserInfo AS
SELECT 
    TableNameId,
    SUBSTR(FirstAttribute, 1, 1) || '***' AS MaskedName,  -- Enmascarar nombre
    Code,
    SUBSTR(Email, 1, 3) || '***@***' AS MaskedEmail,      -- Enmascarar email
    CASE 
        WHEN Age < 18 THEN 'UNDER 18'
        WHEN Age BETWEEN 18 AND 65 THEN 'ADULT'
        ELSE 'SENIOR'
    END AS AgeCategory,
    Status
FROM TableName
WHERE Status = 'ACTIVE';

-- View para monitorear actividad reciente
CREATE OR REPLACE VIEW VW_RecentActivity AS
SELECT 
    TableNameId,
    FirstAttribute AS UserName,
    Status,
    CreationDate,
    CreatedBy,
    UpdateDate,
    UpdatedBy,
    ROUND((SYSDATE - CreationDate), 2) AS DaysSinceCreation
FROM TableName
WHERE CreationDate >= ADD_MONTHS(SYSDATE, -3)  -- Últimos 3 meses
   OR UpdateDate >= ADD_MONTHS(SYSDATE, -1);   -- O actualizados en último mes

-- Suponiendo que TableName tiene una relación jerárquica
CREATE OR REPLACE VIEW VW_UserHierarchy AS
SELECT 
    LEVEL AS HierarchyLevel,
    TableNameId,
    FirstAttribute AS UserName,
    RelatedTableId AS ManagerId,
    LPAD(' ', (LEVEL-1)*3) || FirstAttribute AS IndentedName
FROM TableName
START WITH RelatedTableId IS NULL  -- Usuarios sin manager (raíz)
CONNECT BY PRIOR TableNameId = RelatedTableId;  -- Relación jerárquica

-- View materializada (almacena físicamente los datos)
CREATE MATERIALIZED VIEW MV_UserSummary
REFRESH COMPLETE START WITH SYSDATE NEXT SYSDATE + 1  -- Refrescar diariamente
AS
SELECT 
    Status,
    COUNT(*) AS UserCount,
    TRUNC(CreationDate) AS CreationDay,
    AVG(Age) AS AvgAge
FROM TableName
GROUP BY Status, TRUNC(CreationDate);

-- View que implementa reglas de negocio complejas
CREATE OR REPLACE VIEW VW_ValidUsers AS
SELECT 
    tn.*,
    CASE 
        WHEN tn.Age >= 18 AND tn.Status = 'ACTIVE' THEN 'VALID'
        WHEN tn.Age < 18 AND tn.Status = 'ACTIVE' THEN 'MINOR_ACTIVE'
        ELSE 'INVALID'
    END AS ValidationStatus
FROM TableName tn
WHERE tn.Email IS NOT NULL 
  AND tn.FirstAttribute IS NOT NULL;

  -- View formateada para consumo externo
CREATE OR REPLACE VIEW VW_UserExport AS
SELECT 
    TableNameId AS "id",
    FirstAttribute AS "name",
    Code AS "code",
    LOWER(Email) AS "email",
    Age AS "age",
    LOWER(Status) AS "status",
    TO_CHAR(CreationDate, 'YYYY-MM-DD"T"HH24:MI:SS') AS "created_at"
FROM TableName
WHERE Status = 'ACTIVE';

-- Consultar views
SELECT * FROM VW_UserBasicInfo;

-- Ver definición de una view
SELECT TEXT FROM USER_VIEWS WHERE VIEW_NAME = 'VW_USERBASICINFO';

-- Eliminar view
DROP VIEW VW_UserBasicInfo;

-- Recompilar view (si hay problemas)
ALTER VIEW VW_UserBasicInfo COMPILE;