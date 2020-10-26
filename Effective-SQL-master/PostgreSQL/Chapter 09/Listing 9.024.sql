-- Ensure you've run EntertainmentAgencyStructure.sql
-- and EntertainmentAgencyData.sql in the Sample Databases folder
-- in order to run this example. 

SET search_path = EntertainmentAgencySample;

SELECT A.AgtFirstName, A.AgtLastName, 
    EXTRACT(YEAR FROM E.StartDate) AS ContractYear,
    SUM(CASE WHEN EXTRACT(MONTH FROM E.StartDate) = 1 
             THEN E.ContractPrice END) AS January,
    SUM(CASE WHEN EXTRACT(MONTH FROM E.StartDate) = 2 
             THEN E.ContractPrice END) AS February,
    SUM(CASE WHEN EXTRACT(MONTH FROM E.StartDate) = 3 
             THEN E.ContractPrice END) AS March,
    SUM(CASE WHEN EXTRACT(MONTH FROM E.StartDate) = 4 
             THEN E.ContractPrice END) AS April,
    SUM(CASE WHEN EXTRACT(MONTH FROM E.StartDate) = 5 
             THEN E.ContractPrice END) AS May,
    SUM(CASE WHEN EXTRACT(MONTH FROM E.StartDate) = 6 
             THEN E.ContractPrice END) AS June,
    SUM(CASE WHEN EXTRACT(MONTH FROM E.StartDate) = 7 
             THEN E.ContractPrice END) AS July,
    SUM(CASE WHEN EXTRACT(MONTH FROM E.StartDate) = 8 
             THEN E.ContractPrice END) AS August,
    SUM(CASE WHEN EXTRACT(MONTH FROM E.StartDate) = 9 
             THEN E.ContractPrice END) AS September,
    SUM(CASE WHEN EXTRACT(MONTH FROM E.StartDate) = 10 
             THEN E.ContractPrice END) AS October,
    SUM(CASE WHEN EXTRACT(MONTH FROM E.StartDate) = 11 
             THEN E.ContractPrice END) AS November,
    SUM(CASE WHEN EXTRACT(MONTH FROM E.StartDate) = 12 
             THEN E.ContractPrice END) AS December
FROM Agents AS A LEFT JOIN
    (SELECT En.AgentID, En.StartDate, En.ContractPrice
     FROM Engagements AS En
     WHERE En.StartDate >= '2015-01-01'
       AND En.StartDate < '2016-01-01') AS E
  ON A.AgentID = E.AgentID
GROUP BY AgtFirstName, AgtLastName, EXTRACT(YEAR FROM E.StartDate);
