## A, B, C, D 제품 모두 구매한 고객구하는 방법01

아마 아래와 같은 쿼리를 작성하고 싶은 유혹에 빠질 것이다. 이 쿼리는 스케이트보드 또는 헬맷 또는 무릎 보호대 또는 장갑을 주문한 고객 목록을 추출하기 때문에 원하는 결과가 나오지 않는다. 

```sql
SELECT C.CustomerID, C.CustFirstName, C.CustLastName
FROM Customers C
WHERE C.CustomerID IN 
  (SELECT CustomerID FROM Orders
  INNER JOIN Order_Details
  ON Orders.OrderNumber = Order_Details.OrderNumber
  INNER JOIN Products
  ON Products.ProductNumber = Order_Details.ProductNumber
  WHERE Products.ProductName LIKE '%Skateboard%'
	 OR Products.ProductName LIKE '%Helmet%'
	 OR Products.ProductName LIKE '%Knee Pads%'
	 OR Products.ProductName LIKE '%Gloves%');
```

INNER JOIN을 사용하여 올바르게 SQL을 작성하면 아래와 같다.

```sql
SELECT C.CustomerID, C.CustFirstName, C.CustLastName
FROM Customers C INNER JOIN
  (SELECT DISTINCT Orders.CustomerID
  FROM Orders INNER JOIN Order_Details
  ON Orders.OrderNumber = Order_Details.OrderNumber
  INNER JOIN Products 
  ON Products.ProductNumber = Order_Details.ProductNumber
  WHERE Products.ProductName LIKE '%Skateboard%') OSk
ON C.CustomerID = OSk.CustomerID
INNER JOIN
  (SELECT DISTINCT Orders.CustomerID
  FROM Orders INNER JOIN Order_Details
  ON Orders.OrderNumber = Order_Details.OrderNumber
  INNER JOIN Products 
  ON Products.ProductNumber = Order_Details.ProductNumber
  WHERE Products.ProductName LIKE '%Helmet%') OHel
ON C.CustomerID = OHel.CustomerID
INNER JOIN
  (SELECT DISTINCT Orders.CustomerID
  FROM Orders INNER JOIN Order_Details
  ON Orders.OrderNumber = Order_Details.OrderNumber
  INNER JOIN Products 
  ON Products.ProductNumber = Order_Details.ProductNumber
  WHERE Products.ProductName LIKE '%Knee Pads%') OKn
ON C.CustomerID = OKn.CustomerID
INNER JOIN
  (SELECT DISTINCT Orders.CustomerID
  FROM Orders INNER JOIN Order_Details
  ON Orders.OrderNumber = Order_Details.OrderNumber
  INNER JOIN Products 
  ON Products.ProductNumber = Order_Details.ProductNumber
  WHERE Products.ProductName LIKE '%Gloves%') OGl
ON C.CustomerID = OGl.CustomerID;
```

쿼리가 훨씬 복잡해지지만, 위 쿼리는 올바른 결과를 반환한다. FROM 절에 서브쿼리를 네 개 추가해 네 가지 제품을 모두 구매한 고객만 찾기 때문이다. 서브쿼리에서 DISTICT를 사용한 이유는 고객 한 명당 로우을 하나만 추출하기 위해서이다. 

또 다른 방법으로 서브쿼리 네 개와 Customers 테이블에 대해 WHERE 절을 추가해 IN 조건을 달 수도 있다. 서브쿼리를 처리하는 부분을 함수로 만든 덕분에 마지막 SQL문은 꽤 간단하다.

```sql
CREATE TYPE CustIDRowType AS OBJECT(CustID int);
/

CREATE TYPE CustIDTableType IS TABLE OF CustIDRowType;
/

CREATE FUNCTION CustProd(ProdName IN varchar) 
RETURN CustIDTableType
AS CustIDTable CustIDTableType;
BEGIN
	SELECT CustIDRow
	BULK COLLECT INTO CustIDTable
	FROM (
	  SELECT CustIDRowType(Orders.CustomerID) AS CustIDRow
	  FROM Orders 
	  INNER JOIN Order_Details 
		  ON Orders.OrderNumber = Order_Details.OrderNumber 
	  INNER JOIN Products 
  		ON Products.ProductNumber = Order_Details.ProductNumber
	  WHERE ProductName LIKE '%' || ProdName || '%'
	);
	RETURN CustIDTable;
END;
/

SELECT C.CustomerID, C.CustFirstName, C.CustLastName
FROM Customers C 
WHERE C.CustomerID IN
  (SELECT CustID FROM TABLE(CustProd('Skateboard')))  
AND C.CustomerID IN
  (SELECT CustID FROM TABLE(CustProd('Helmet')))
AND C.CustomerID IN
  (SELECT CustID FROM TABLE(CustProd('Knee Pads')))
AND C.CustomerID IN
  (SELECT CustID FROM TABLE(CustProd('Gloves')));

--생성한 함수 지우기
DROP FUNCTION CustProd;
DROP TYPE CustIDTableType;
DROP TYPE CustIDRowType;
```

마지막으로 IN과 EXITS, 연관성 있는 서브쿼리를 사용해 이 문제를 해결할 수 있다.

```sql
SELECT C.CustomerID, C.CustFirstName, C.CustLastName
FROM Customers C 
WHERE EXISTS
  (SELECT Orders.CustomerID
  FROM Orders INNER JOIN Order_Details
  ON Orders.OrderNumber = Order_Details.OrderNumber
  INNER JOIN Products 
  ON Products.ProductNumber = Order_Details.ProductNumber
  WHERE Products.ProductName LIKE '%Skateboard%'
  AND Orders.CustomerID = C.CustomerID)
AND EXISTS
  (SELECT Orders.CustomerID
  FROM Orders INNER JOIN Order_Details
  ON Orders.OrderNumber = Order_Details.OrderNumber
  INNER JOIN Products 
  ON Products.ProductNumber = Order_Details.ProductNumber
  WHERE Products.ProductName LIKE '%Helmet%'
  AND Orders.CustomerID = C.CustomerID)
AND EXISTS
  (SELECT Orders.CustomerID
  FROM Orders INNER JOIN Order_Details
  ON Orders.OrderNumber = Order_Details.OrderNumber
  INNER JOIN Products 
  ON Products.ProductNumber = Order_Details.ProductNumber
  WHERE Products.ProductName LIKE '%Knee Pads%'
  AND Orders.CustomerID = C.CustomerID)
AND EXISTS
  (SELECT Orders.CustomerID
  FROM Orders INNER JOIN Order_Details
  ON Orders.OrderNumber = Order_Details.OrderNumber
  INNER JOIN Products 
  ON Products.ProductNumber = Order_Details.ProductNumber
  WHERE Products.ProductName LIKE '%Gloves%'
  AND Orders.CustomerID = C.CustomerID);
  ```