CREATE DATABASE Item60Example
	DEFAULT CHARACTER SET utf8
    DEFAULT COLLATE utf8_unicode_ci;

USE Item60Example;

CREATE TABLE Employees (
  EmployeeID int PRIMARY KEY,
  EmpName varchar(255) NOT NULL,
  EmpPosition varchar(255) NOT NULL,
  SupervisorID int NULL,
  HierarchyPath varchar(255)
);

ALTER TABLE Employees 
ADD FOREIGN KEY (SupervisorID) 
REFERENCES Employees (EmployeeID);

INSERT INTO Employees (EmployeeID, EmpName, EmpPosition, SupervisorID, HierarchyPath)
VALUES
	(1,	'Amy Kok', 'President', NULL, '1'),
	(2, 'Tom LaPlante', 'Manager', 1, '1/2'),
	(3,	'Aliya Ash', 'Manager', 1, '1/3'),
	(4,	'Nya Maeng', 'Associate',2, '1/2/4'),
	(5, 'Lee Devi', 'Associate', 2, '1/2/5'),
	(6, 'Kush Itō', 'Associate', 2, '1/2/6'),
	(7, 'Raj Pavlov', 'Senior Editor', 3, '1/3/7'),
	(8, 'Kusk Pérez', 'Senior Developer', 3, '1/3/8'),
	(9, 'Zoha Larsson',	'Senior Writer', 3, '1/3/9'),
	(10, 'Yuri Lee', 'Developer', 8, '1/3/8/10'),
	(11, 'Mariam Davis', 'Developer', 8, '1/3/8/11'),
	(12, 'Jessica Yosef', 'Developer', 8, '1/3/8/12')
;

