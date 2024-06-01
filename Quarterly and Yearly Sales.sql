


-- 
SELECT 
    QUARTER(o.orderDate) AS quarter,
    YEAR(o.orderDate) AS year,
    p.productLine,
    w.warehouseCode,
    COUNT(o.orderNumber) AS numberOfOrders,
    SUM(od.quantityOrdered) AS totalQuantityOrdered
FROM 
    orders o
JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
JOIN 
    products p ON od.productCode = p.productCode
JOIN 
    warehouses w ON p.warehouseCode = w.warehouseCode
WHERE 
    w.warehousecode = 'd'
GROUP BY 
    quarter, year, p.productLine, w.warehouseCode
ORDER BY 
    year, quarter;

-- Product Line Popularity
SELECT 
    c.country,
    w.warehouseCode,
    SUM(od.quantityOrdered) AS totalQuantityOrdered
FROM 
    customers c
JOIN 
    orders o ON c.customerNumber = o.customerNumber
JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
JOIN 
    products p ON od.productCode = p.productCode
JOIN 
    warehouses w ON p.warehouseCode = w.warehouseCode
GROUP BY 
    c.country, w.warehouseCode
ORDER BY 
    c.country, w.warehouseCode;
--
