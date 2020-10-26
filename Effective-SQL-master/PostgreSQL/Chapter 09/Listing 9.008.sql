-- Ensure you've run SalesOrdersStructure.sql
-- and SalesOrdersData.sql in the Sample Databases folder
-- in order to run this example. 

SET search_path = SalesOrdersSample;

WITH CustDecPurch AS
(SELECT Orders.CustomerID, 
   SUM((QuotedPrice)*(QuantityOrdered)) AS Purchase 
 FROM Orders INNER JOIN Order_Details
   ON Orders.OrderNumber = Order_Details.OrderNumber 
 WHERE Orders.OrderDate Between '2015-12-01'
     AND '2015-12-31' 
 GROUP BY Orders.CustomerID),
 Coupons AS
(SELECT CustDecPurch.CustomerID, ztblPurchaseCoupons.NumCoupons
 FROM CustDecPurch CROSS JOIN ztblPurchaseCoupons
 WHERE CustDecPurch.Purchase BETWEEN 
   ztblPurchaseCoupons.LowSpend AND 
   ztblPurchaseCoupons.HighSpend)
SELECT C.CustFirstName, C.CustLastName, C.CustStreetAddress, 
     C.CustCity, C.CustState, C.CustZipCode, CP.NumCoupons
FROM Coupons AS CP INNER JOIN Customers AS C
  ON CP.CustomerID = C.CustomerID
CROSS JOIN ztblSeqNumbers AS z
WHERE z.Sequence <= CP.NumCoupons;
