
-- 1. Tabla
CREATE TABLE RangeSales
(
    IdProduct    NUMBER(6),
    IdCustomer    NUMBER,
    PurchaseDate DATE,
    QuantitySold NUMBER(3),
    AmountSold   NUMBER(10,2)
)

-- 2. Particiones
/*
    Tablas muy grandes (> varios GB)
    Datos con patrones temporales (fechas, meses, años)
    Necesidad de purgar datos antiguos frecuentemente
    Consultas que siempre filtran por un rango específico
    Cargas masivas de datos por lotes
*/
PARTITION BY RANGE(PurchaseDate)
(
    PARTITION SALES_Q1_1998 VALUES LESS THAN (TO_DATE('01-APR-1998','DD-MON-YYYY')),
    PARTITION SALES_Q2_1998 VALUES LESS THAN (TO_DATE('01-JUL-1998','DD-MON-YYYY')),
    PARTITION SALES_Q3_1998 VALUES LESS THAN (TO_DATE('01-OCT-1998','DD-MON-YYYY')),
    PARTITION SALES_Q4_1998 VALUES LESS THAN (TO_DATE('01-JAN-1999','DD-MON-YYYY')),
    PARTITION SALES_Q1_1999 VALUES LESS THAN (TO_DATE('01-APR-1999','DD-MON-YYYY')),
    PARTITION SALES_Q4_2000 VALUES LESS THAN (MAXVALUE)
);