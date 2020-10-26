-- Ensure you've run Item36StructureAndData.sql in the Sample Databases folder
-- in order to create the Inventory table

SET search_path = Item36Example;

--Listing 5.28 Multiple counts in a single query
SELECT COUNT(*) AS TotalRows,
  COUNT(CustomerID) AS TotalOrdersWithCustomers,
  COUNT(EmployeeID) AS TotalOrdersWithEmployees,
  COUNT(DISTINCT CustomerID) AS TotalUniqueCustomers,
  COUNT(CASE WHEN OrderTotal > 1000 THEN CustomerID END) AS TotalLargeOrders,
  COUNT(DISTINCT CASE WHEN OrderTotal > 1000 THEN CustomerID END) AS TotalUniqueCust_LargeOrders
FROM OrdersTable;

