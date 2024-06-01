SELECT * FROM warehouses;
SELECT * FROM products;
SELECT * FROM productlines;
SELECT * FROM orderdetails;
SELECT * FROM orders;
SELECT * FROM customers;



SELECT DISTINCT city FROM customers;



-- Number of units stored in a warehouse
SELECT 
	warehouses.warehouseCode,
    products.productLine,
    products.quantityInstock
FROM 
	warehouses
INNER JOIN
	products ON warehouses.warehouseCode=products.warehouseCode
    ;
SELECT 
	warehouseCode,
    SUM(quantityInstock) AS 'Quantity In Stock per Warehouse'
FROM(
	SELECT 
	warehouses.warehouseCode,
    products.productLine,
    products.quantityInstock
FROM 
	warehouses
INNER JOIN
	products ON warehouses.warehouseCode=products.warehouseCode)
    AS SUBQUERY
GROUP BY 
	warehousecode;
    
    
-- Number of units ordered in a warehouse-- 
SELECT 
    warehouses.warehouseCode,
    SUM(orderdetails.quantityOrdered) AS totalQuantityOrdered
FROM 
    warehouses
INNER JOIN 
    products
ON 
    warehouses.warehouseCode = products.warehouseCode
INNER JOIN 
    orderdetails
ON 
    products.productCode = orderdetails.productCode
GROUP BY 
    warehouses.warehouseCode;
    
--
-- Number of units that a Warehouse stored after orders-- 

--  Calculate the remaining units for each product
SELECT 
    p.productCode,
    p.warehouseCode,
    p.quantityInStock,
    IFNULL(SUM(od.quantityOrdered), 0) AS totalQuantityOrdered,
    (p.quantityInStock - IFNULL(SUM(od.quantityOrdered), 0)) AS remainingUnits
FROM 
    products p
LEFT JOIN 
    orderdetails od ON p.productCode = od.productCode
GROUP BY 
    p.productCode, p.warehouseCode, p.quantityInStock;

-- Step 2: Sum the remaining units by warehouse
SELECT 
    warehouseCode,
    SUM(remainingUnits) AS remainingUnitsInWarehouse
FROM 
    (
        SELECT 
            p.productCode,
            p.warehouseCode
            p.quantityInStock,
            IFNULL(SUM(od.quantityOrdered), 0) AS totalQuantityOrdered,
            (p.quantityInStock - IFNULL(SUM(od.quantityOrdered), 0)) AS remainingUnits
        FROM 
            products p
        LEFT JOIN 
            orderdetails od ON p.productCode = od.productCode
        GROUP BY 
            p.productCode, p.warehouseCode
    ) AS subquery
GROUP BY 
    warehouseCode;
