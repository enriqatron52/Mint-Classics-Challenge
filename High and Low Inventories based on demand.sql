-- Checks the inventory along with its demand and supply -- 
SELECT 
    p.warehouseCode,
    p.productCode,
    p.productName,
    p.productLine,
    COALESCE(SUM(od.quantityOrdered), 0) AS totalQuantityOrdered,
    p.quantityInStock,
    (p.quantityInStock - COALESCE(SUM(od.quantityOrdered), 0)) AS remainingStock
FROM 
    products p
LEFT JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.warehouseCode, p.productCode, p.productName, p.productLine, p.quantityInStock

ORDER BY 
    remainingStock ASC;
-- Query for the remaining stocks grouped by their respective warehouse codes and product line. It excludes any products where the calculation of remaining stock (quantity in stock minus total quantity ordered) results in a negative value.
SELECT 
    p.warehouseCode,
    p.productLine,
    COALESCE(SUM(od.totalQuantityOrdered), 0) AS totalQuantityOrdered,
    SUM(p.quantityInStock) AS quantityInStock,
    GREATEST(SUM(p.quantityInStock) - COALESCE(SUM(od.totalQuantityOrdered), 0), 0) AS remainingStock
FROM 
    products p
LEFT JOIN (
    SELECT 
        productCode,
        SUM(quantityOrdered) AS totalQuantityOrdered
    FROM 
        orderdetails
    GROUP BY 
        productCode
) od ON p.productCode = od.productCode
GROUP BY 
    p.warehouseCode, p.productLine
HAVING 
    remainingStock > 0
ORDER BY 
    remainingStock ASC;

-- Checks the remaining Stock of each Products -- 
SELECT 
    p.productCode,
    p.productName,
    p.productLine,
    SUM(od.quantityOrdered) AS totalQuantityOrdered,
    p.quantityInStock,
    (p.quantityInStock - SUM(od.quantityOrdered)) AS remainingStock
FROM 
    products p
LEFT JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.productCode, p.productName, p.productLine, p.quantityInStock
ORDER BY 
    totalQuantityOrdered ASC;
-- Very Low Inventories -- 
SELECT 
    p.warehouseCode,
    p.productCode,
    p.productName,
    p.productLine,
    COALESCE(SUM(od.quantityOrdered), 0) AS totalQuantityOrdered,
    p.quantityInStock,
    (p.quantityInStock - COALESCE(SUM(od.quantityOrdered), 0)) AS remainingStock
FROM 
    products p
LEFT JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.warehouseCode, p.productCode, p.productName, p.productLine, p.quantityInStock
HAVING 
    remainingStock < 0 OR remainingStock < 100
ORDER BY 
    remainingStock ASC;
-- Very High Inventories -- 
SELECT 
    p.warehouseCode,
    p.productCode,
    p.productName,
    p.productLine,
    COALESCE(SUM(od.quantityOrdered), 0) AS totalQuantityOrdered,
    p.quantityInStock,
    (p.quantityInStock - COALESCE(SUM(od.quantityOrdered), 0)) AS remainingStock
FROM 
    products p
LEFT JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.warehouseCode, p.productCode, p.productName, p.productLine, p.quantityInStock
HAVING 
    totalQuantityOrdered < (p.quantityInStock / 4)
ORDER BY 
    remainingStock DESC, totalQuantityOrdered ASC;

