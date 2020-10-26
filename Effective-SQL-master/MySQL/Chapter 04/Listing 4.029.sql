-- Ensure you've run Listing 4.028.sql to create the Employees table

USE Item28Example;

-- Listing 4.29 Non-sargable query to limit data to a particular year

SELECT EmployeeID, EmpFirstName, EmpLastName
  FROM Employees
 WHERE Year(EmpDOB) = 1950;


