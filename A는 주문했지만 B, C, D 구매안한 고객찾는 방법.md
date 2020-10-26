## A는 주문했지만 B, C, D 구매안한 고객찾는 방법

**스케이트보드를 구매했지만 헬맷, 장갑, 무릎 보호대 모두 구매하지 않는 고객 목록구하기**

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
AND (C.CustomerID NOT IN 
  (SELECT CustID FROM TABLE(CustProd('Helmet')))
OR C.CustomerID NOT IN
  (SELECT CustID FROM TABLE(CustProd('Gloves')))
OR C.CustomerID NOT IN
  (SELECT CustID FROM TABLE(CustProd('Knee Pads'))));

--아래는 생성한 함수를 삭제한다.
DROP FUNCTION CustProd;
DROP TYPE CustIDTableType;
DROP TYPE CustIDRowType;
```

WHERE 절의 첫 번째 조건은 스케이트 보드를 구매한 고객을 찾는 것이고, 나머지 조건은 헬맷 또는 장갑 또는 무릎 보호대를 구매하지 않은 고객을 찾는 것이다.
