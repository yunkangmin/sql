## A, B, C, D 제품 모두 구매한 고객구하는 방법02

"A, B, C, D 제품 모두 구매한 고객구하는 방법01"에서 제수집합(관심항목)의 각 항목에 대한 서브쿼리와 IN을 사용해 문제를 해결했다. 제수집합이 작다면 가능한 방법이지만, 반대로 매우 크다면 이 방식으로는 실행이 불가능할 것이다.(관심항목을 모두 나열해야 하므로) **따라서 아래 방법을 사용한다.**

아래 sql은 뷰를 만들어 사용한다.

간단히 말하자면 관심제품이 아닌 제품목록을 구하고 이 제품목록이 아닌 제품을 구매한 고객목록을 구한다.


```sql
CREATE VIEW CustomerProducts AS
--한 고객이 동일 제품을 여러 번 구매한 경우 이 제품과 고객당 로우 하나만 추출하기 위해 DISTINCT 사용
SELECT DISTINCT Customers.CustomerID, Customers.CustFirstName,
  Customers.CustLastName,
       CASE WHEN Products.ProductName LIKE '%Skateboard%' THEN 'Skateboard'
              WHEN Products.ProductName LIKE '%Helmet%' THEN 'Helmet'
              WHEN Products.ProductName LIKE '%Knee Pads%' THEN 'Knee Pads'
              WHEN Products.ProductName LIKE '%Gloves%' THEN 'Gloves'
              ELSE NULL
       END AS ProductCategory
FROM Customers INNER JOIN Orders
  ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Order_Details
  ON Orders.OrderNumber = Order_Details.OrderNumber
INNER JOIN Products
  ON Products.ProductNumber = Order_Details.ProductNumber;

CREATE VIEW ProdsOfInterest AS
SELECT DISTINCT 
       CASE WHEN Products.ProductName LIKE '%Skateboard%' THEN 'Skateboard'
              WHEN Products.ProductName LIKE '%Helmet%' THEN 'Helmet'
              WHEN Products.ProductName LIKE '%Knee Pads%' THEN 'Knee Pads'
              WHEN Products.ProductName LIKE '%Gloves%' THEN 'Gloves'
              ELSE NULL
       END AS ProductCategory
FROM Products
WHERE ProductName LIKE '%Skateboard%'
   OR ProductName LIKE '%Helmet%' 
   OR ProductName LIKE '%Knee Pads%' 
   OR ProductName LIKE '%Gloves%';
  
SELECT DISTINCT CustomerID, CustFirstName, CustLastName
FROM CustomerProducts CP1
WHERE NOT EXISTS
  (SELECT ProductCategory FROM ProdsOfInterest PofI
    WHERE NOT EXISTS
    (SELECT CustomerID FROM CustomerProducts CP2
      WHERE CP2.CustomerID = CP1.CustomerID
      AND CP2.ProductCategory = PofI.ProductCategory));

-- view 삭제하기
DROP VIEW ProdsOfInterest;
DROP VIEW CustomerProducts;
```

GROUP BY와 HAVING절을 이용하여 구하는 방법

여기서는 위에서 생성한 뷰를 사용한다. CustomerProducts 뷰에서 유일한 고객 제품을 가져오기 위해(즉, 같은 제품을 2개이상 구매한 로우는 제거) DISTINCT를 사용했다는 점이 중요하다. 예를 들어 스케이드보드와 헬멧과 장갑 두 쌍을(서로 다른 주문으로) 구매한 고객이 생성하는 로우의 개수는 네 개인데, 이 숫자는 관심 제품 뷰에 있는 로우 건수와 일치해 혼란을 줄 수 있다.


```sql
SELECT CP.CustomerID, CP.CustFirstName, CP.CustLastName
FROM CustomerProducts CP CROSS JOIN ProdsOfInterest PofI
WHERE CP.ProductCategory = PofI.ProductCategory
GROUP BY CP.CustomerID, CP.CustFIrstName, CP.CustLastName
HAVING COUNT(CP.ProductCategory) =
  (SELECT COUNT(ProductCategory) FROM ProdsOfInterest);
```

제수집합(즉, ProdsOfInterest(관심제품))이 비어 있을 때 반환하는 로우의 개수는 0이다. 첫번째 방법과는 다른 결과가 나온다.

따라서 두번째 방법을 쓰자.