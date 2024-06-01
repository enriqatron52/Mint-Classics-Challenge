-- 
-- Query the correlation between customers location, their orders, and which warehouse the orders are stored--
SELECT 
    c.customerName,
    c.city,
    c.country,
    o.orderNumber,
    od.productCode,
    p.productName,
    p.warehouseCode,
    w.warehouseName  -- Adjusted column name based on available columns
FROM 
    customers c
JOIN 
    orders o ON c.customerNumber = o.customerNumber
JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
JOIN 
    products p ON od.productCode = p.productCode
JOIN 
    warehouses w ON p.warehouseCode = w.warehouseCode;
-- Count the orders by city and warehouse
SELECT 
    c.city,
    w.warehouseCode,
    COUNT(o.orderNumber) AS numberOfOrders
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
    c.city, w.warehouseCode
ORDER BY 
    c.city, w.warehouseCode;
-- Country Demand Analysis

-- Geographical Demand Analysis -- 
SELECT 
    c.city,
    w.warehouseCode,
    COUNT(o.orderNumber) AS numberOfOrders,
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
WHERE 
    w.warehousecode = 'b'
GROUP BY 
    c.city, w.warehouseCode
ORDER BY 
    numberOfOrders DESC;    