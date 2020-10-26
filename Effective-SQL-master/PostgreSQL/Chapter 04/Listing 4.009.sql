-- To run the first three examples, you need to create a sample
-- database and point to it using SET search_path.
CREATE TABLE Students (
	StudentID int PRIMARY KEY NOT NULL,
	LastName varchar(50),
	FirstName varchar(50),
	BirthDate date
);

SELECT Students.StudentID, Students.LastName, Students.FirstName, 
   EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM Students.BirthDate) - 
    (CASE WHEN EXTRACT(MONTH FROM Students.BirthDate) < EXTRACT(MONTH FROM CURRENT_DATE) 
    THEN 0 
    WHEN EXTRACT(MONTH FROM Students.BirthDate) > EXTRACT(MONTH FROM CURRENT_DATE) 
    THEN 1 
    WHEN EXTRACT(DAY FROM Students.BirthDate) > EXTRACT(DAY FROM CURRENT_DATE) 
    THEN 1  
    ELSE 0 END) AS Age
  FROM Students;
  
DROP TABLE Students;

--Similar code using EmpDOB in the Employees table in SalesOrdersSample
-- Ensure you've run SalesOrdersStructure.sql
-- and SalesOrdersData.sql in the Sample Databases folder
-- in order to run this example. 

SET search_path = SalesOrdersSample;

SELECT Employees.EmployeeID, Employees.EmpLastName, Employees.EmpFirstName,
   (EXTRACT(YEAR FROM CURRENT_DATE) - EXTRACT(YEAR FROM Employees.EmpDOB)) -
    (CASE WHEN EXTRACT(MONTH FROM Employees.EmpDOB) < EXTRACT(MONTH FROM CURRENT_DATE) 
    THEN 0 
    WHEN EXTRACT(MONTH FROM Employees.EmpDOB) > EXTRACT(MONTH FROM CURRENT_DATE) 
    THEN 1 
    WHEN EXTRACT(DAY FROM Employees.EmpDOB) > EXTRACT(DAY FROM CURRENT_DATE) 
    THEN 1  
    ELSE 0 END) AS Age 
  FROM Employees;
