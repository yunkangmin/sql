-- Ensure you've run Item55StructureAndData.sql in the Sample Databases folder
-- in order to run this example. 

USE Item55Example;

CREATE INDEX DimDate_WeekDayLong
ON DimDate (DateValue, WeekdayNameLong);
