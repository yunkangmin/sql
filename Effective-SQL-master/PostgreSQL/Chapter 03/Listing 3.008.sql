-- Ensure you've run Item21StructureAndData.sql in the Sample Databases folder in order to run this example.

SET search_path = Item21Example;

-- Listing 3.8 SQL to extract October data

SELECT Category, OctQuantity, OctSales
  FROM SalesSummary;
