-- Ensure you've run SalesOrdersStructure.sql and SalesOrdersData.sql 
-- in the Sample Databases folder in order to run this example. 

SET search_path = SalesOrdersSample;

SELECT CustomerID, Sum(OrderTotal) AS SumOrderTotal
FROM Orders
WHERE OrderDate > DATE '2015-12-01'
GROUP BY CustomerID;