-- Ensure you've run SalesOrdersStructure.sql
-- and SalesOrdersData.sql in the Sample Databases folder
-- in order to run this example. 

SET search_path = SalesOrdersSample;

CREATE INDEX IX_Customers_CustArea
ON Customers (CustAreaCode, CustCity);

SELECT CustCity
FROM Customers
WHERE CustAreaCode = 530;

DROP INDEX IX_Customers_CustArea;
