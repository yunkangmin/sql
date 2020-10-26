## A만 주문하고 B는 주문하지 않은 고객을 찾는 방법

차집합 연산은 기본적으로 한 집합에서 다른 집합을 빼는 것이다. 교집합처럼 컬럼이 동일하거나 유사한 두 집합을 대상으로 작업해야 한다. DB2, SQL Server, PostgreSQL은 EXCEPT 키워드를 사용하고 오라클은 MINUS 키워드를 사용한다. MySQL과 액세스는 차집합 기능을 직접 지원하지는 않고 OUTER JOIN으로 유사하게 구현할 수 있다. 

**아래는  스케이트 보드만 주문하고 헬멧을 주문하지 않는 모든 고객을 찾는 쿼리이다.**
```sql
SELECT C.CustFirstName, C.CustLastName
FROM Customers C
WHERE C.CustomerID IN
  (SELECT CustomerID FROM Orders
  INNER JOIN Order_Details
    ON Orders.OrderNumber = Order_Details.OrderNumber
  INNER JOIN Products
    ON Products.ProductNumber = Order_Details.ProductNumber
  WHERE Products.ProductName LIKE '%Skateboard%')
MINUS
SELECT C2.CustFirstName, C2.CustLastName
FROM Customers C2
WHERE C2.CustomerID IN
  (SELECT CustomerID FROM Orders
  INNER JOIN Order_Details
    ON Orders.OrderNumber = Order_Details.OrderNumber
  INNER JOIN Products
    ON Products.ProductNumber = Order_Details.ProductNumber
  WHERE Products.ProductName LIKE '%Helmet%');
```