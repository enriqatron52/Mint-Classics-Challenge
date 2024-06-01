USE mintclassics;
-- Calculate Profit for Each Order Detail
SELECT 
    od.productCode,            -- Product code from the order details
    p.warehouseCode,           -- Warehouse code from the products table
    (od.priceEach - p.buyPrice) AS profitPerUnit,  -- Calculate profit per unit
    od.quantityOrdered,        -- Quantity ordered from the order details
    (od.priceEach - p.buyPrice) * od.quantityOrdered AS totalProfit  -- Calculate total profit
FROM 
    orderdetails od
JOIN 
    products p ON od.productCode = p.productCode  -- Join order details and products on product code
ORDER BY  totalprofit DESC;
-- Summarize Profits by Warehouse
SELECT 
    p.warehouseCode,              -- Warehouse code from the products table
    SUM((od.priceEach - p.buyPrice) * od.quantityOrdered) AS totalProfit  -- Sum total profit by warehouse
FROM 
    orderdetails od
JOIN 
    products p ON od.productCode = p.productCode  -- Join order details and products on product code
GROUP BY 
    p.warehouseCode;  -- Group by warehouse code to get total profit per warehouse

--  Include Customer Details (optional)
SELECT 
    c.customerNumber, 
    c.customerName, 
    o.orderNumber, 
    p.warehouseCode, 
    SUM((od.priceEach - p.buyPrice) * od.quantityOrdered) AS totalProfit
FROM 
    customers c
JOIN 
    orders o ON c.customerNumber = o.customerNumber
JOIN 
    orderdetails od ON o.orderNumber = od.orderNumber
JOIN 
    products p ON od.productCode = p.productCode
GROUP BY 
    c.customerNumber, 
    c.customerName, 
    o.orderNumber, 
    p.warehouseCode;
    
-- Profit and Quantity Ordered Analysis of Products based on City, Country, and Warehouse -- 
SELECT 
    c.city,
    c.country,
    w.warehouseCode,
    SUM(od.quantityOrdered) AS totalQuantityOrdered,
    SUM(od.quantityOrdered * od.priceEach) AS totalSales
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
    c.city, c.country, w.warehouseCode
ORDER BY 
    totalSales DESC;