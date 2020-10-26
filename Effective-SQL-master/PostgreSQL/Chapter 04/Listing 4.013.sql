-- Ensure you've run SalesOrdersStructure.sql
-- and SalesOrdersData.sql in the Sample Databases folder
-- in order to run this example. 

SET search_path = SalesOrdersSample;

CREATE FUNCTION CustProd(ProdName varchar(50)) 
	RETURNS TABLE (CustID int) 
	LANGUAGE plpgsql AS
$BODY$
BEGIN
	RETURN QUERY
	SELECT Orders.CustomerID AS CustID 
	FROM Orders 
	INNER JOIN Order_Details 
		ON Orders.OrderNumber = Order_Details.OrderNumber 
	INNER JOIN Products 
		ON Products.ProductNumber = Order_Details.ProductNumber
	WHERE ProductName = ProdName;
END;
$BODY$;

--Schema must be included for function invocation to work
SELECT C.CustomerID, C.CustFirstName, C.CustLastName
FROM Customers AS C 
WHERE C.CustomerID IN
  (SELECT CustID FROM SalesOrdersSample.CustProd('Skateboard'))
AND C.CustomerID IN
  (SELECT CustID FROM SalesOrdersSample.CustProd('Helmet'))
AND C.CustomerID IN
  (SELECT CustID FROM SalesOrdersSample.CustProd('Knee Pads'))
AND C.CustomerID IN
  (SELECT CustID FROM SalesOrdersSample.CustProd('Gloves'));

DROP FUNCTION CustProd(ProdName varchar(50));

-- Sample query that returns results:
CREATE FUNCTION CustProd(ProdName varchar(50)) 
	RETURNS TABLE (CustID int) 
	LANGUAGE plpgsql AS
$BODY$
BEGIN
	RETURN QUERY
	SELECT Orders.CustomerID AS CustID 
	FROM Orders 
	INNER JOIN Order_Details 
		ON Orders.OrderNumber = Order_Details.OrderNumber 
	INNER JOIN Products 
		ON Products.ProductNumber = Order_Details.ProductNumber
	WHERE ProductName LIKE CONCAT('%', ProdName, '%');
END;
$BODY$;

--Schema must be included for function invocation to work
SELECT C.CustomerID, C.CustFirstName, C.CustLastName
FROM Customers AS C 
WHERE C.CustomerID IN
  (SELECT CustID FROM SalesOrdersSample.CustProd('Skateboard'))
AND C.CustomerID IN
  (SELECT CustID FROM SalesOrdersSample.CustProd('Helmet'))
AND C.CustomerID IN
  (SELECT CustID FROM SalesOrdersSample.CustProd('Knee Pads'))
AND C.CustomerID IN
  (SELECT CustID FROM SalesOrdersSample.CustProd('Gloves'));

DROP FUNCTION CustProd(ProdName varchar(50));
