SELECT p.nombre_producto, v.nombre_proveedor
FROM productos p, proveedores v;

--También con la sintaxis moderna (recomendada):

SELECT p.nombre_producto, v.nombre_proveedor
FROM productos p
CROSS JOIN proveedores v;