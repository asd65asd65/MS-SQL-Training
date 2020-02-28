use Northwind


--A
select * from Employees
--1
select EmployeeID, FirstName+LastName Name, Title, BirthDate from Employees
where Title like '%sales%'
--2
select ProductID, ProductName, UnitPrice, UnitsInStock from Products
where ProductID like '5%' or ProductID like '_5%'

--B
--3
select A.EmployeeID, A.FirstName+A.LastName Name, A.City, B.CustomerID, B.CompanyName 
from Employees A left outer join Customers B
on A.City = B.City
order by 1, 4

--C
select * from Orders
select * from [Order Details]
--4
select B.ProductID, datepart(YEAR,A.OrderDate) Year, datepart(MONTH,A.OrderDate) Month, SUM(B.Quantity) TotalSell from Orders A, [Order Details] B
group by B.ProductID, datepart(YEAR,A.OrderDate), datepart(MONTH,A.OrderDate)
order by B.ProductID desc, datepart(YEAR,A.OrderDate) desc, datepart(MONTH,A.OrderDate) desc

--D
--5
select A.ReportsTo, B.FirstName+B.LastName Name, COUNT(A.ReportsTo) Number
from Employees A inner join Employees B 
on A.ReportsTo = B.EmployeeID
where A.ReportsTo is not null
group by A.ReportsTo, B.FirstName+B.LastName

--E
--6
select (datepart(MONTH,A.OrderDate)-1)/3+1 Month, SUM(B.UnitPrice*B.Quantity) 交易總金額 
from Orders A inner join [Order Details] B
on A.OrderID = B.OrderID
group by  (datepart(MONTH,A.OrderDate)-1)/3
order by  (datepart(MONTH,A.OrderDate)-1)/3

--F
select * from Orders
select * from [Order Details]
--7
select A.EmployeeID, A.FirstName+A.LastName Name, ISNULL(SUM(C.Quantity*C.UnitPrice), 0) 總業績 
from Employees A left outer join Orders B on A.EmployeeID = B.EmployeeID left outer join [Order Details] C on B.OrderID = C.OrderID
group by ALL A.EmployeeID, A.FirstName+A.LastName
--8
select A.CustomerID, A.CompanyName, ISNULL(SUM(C.Quantity*C.UnitPrice), 0) 總交易金額 
from Customers A left outer join Orders B on A.CustomerID = B.CustomerID left outer join [Order Details] C on B.OrderID = C.OrderID
group by ALL A.CustomerID, A.CompanyName
--9
select A.ProductID, A.ProductName, ISNULL(SUM(B.Quantity*B.UnitPrice), 0) 交易總金額 
from Products A left outer join [Order Details] B on A.ProductID = B.ProductID
group by ALL A.ProductID, A.ProductName

--G
select * from Categories
--10
select CategoryID, COUNT(ProductID) 產品項目數 from Products
group by CategoryID
having COUNT(ProductID)>10

--H
--11
select A.EmployeeID, COUNT(B.OrderID) 接單次數
from Employees A left outer join Orders B on A.EmployeeID = B.EmployeeID
where DATEPART(YEAR,B.OrderDate)=1996
group by A.EmployeeID
having COUNT(B.OrderID)>4
--12
select A.ProductID, COUNT(B.OrderID) 交易次數
from [Order Details] A left outer join Orders B on A.OrderID = B.OrderID
where DATEPART(YEAR,B.OrderDate)=1998
group by A.ProductID
having COUNT(B.OrderID)>20

--I
--13
select B.CustomerID, SUM(C.Quantity*C.UnitPrice) 下單金額
from Orders B left outer join [Order Details] C on B.OrderID=C.OrderID
where datepart(YEAR,B.OrderDate)=1997
group by B.CustomerID
having SUM(C.Quantity*C.UnitPrice)>5000

--J
--14
select top 3 B.ProductID, SUM(B.Quantity*B.UnitPrice) 交易金額
from  Orders A left outer join [Order Details] B on A.OrderID=B.OrderID
where datepart(YEAR,A.OrderDate)=1997
group by B.ProductID
having SUM(B.Quantity*B.UnitPrice)>=5000 and SUM(B.Quantity*B.UnitPrice)<=10000
order by SUM(B.Quantity*B.UnitPrice) desc
--15
select top 10 B.CustomerID, SUM(C.Quantity*C.UnitPrice) 交易金額
from Orders B left outer join [Order Details] C on B.OrderID=C.OrderID
where datepart(YEAR,B.OrderDate)=1997
group by B.CustomerID
having SUM(C.Quantity*C.UnitPrice)>5000
order by SUM(C.Quantity*C.UnitPrice)

--K
--16
select ProductID, ProductName, UnitPrice 調漲前價格, 
case 
when UnitPrice>=60 then STR(UnitPrice*1.2, 6, 2)
when UnitPrice>40 and UnitPrice<60 then STR(UnitPrice*1.15, 6, 2)
when UnitPrice<=40 then STR(UnitPrice*1.1, 6, 2)
end 調漲後價格 
from Products
--17
select ProductID, ProductName, UnitPrice 調漲前價格, 
case 
when UnitPrice>=80 and UnitPrice*1.2>120 then STR(UnitPrice*1.2*0.9, 6, 2)
when UnitPrice>=80 and UnitPrice*1.2<=120 then STR(UnitPrice*1.2, 6, 2)
when UnitPrice<80 and UnitPrice>40 then STR(UnitPrice*1.15, 6, 2)
when UnitPrice<=40 then STR(UnitPrice*1.1, 6, 2)
end 調漲後價格 
from Products
order by 4 desc
--18
select ProductID, ProductName, UnitPrice 調漲前價格, 
case 
when CategoryID=1 then STR(UnitPrice*1.15, 6, 2)
when CategoryID=2 then STR(UnitPrice*1.2, 6, 2)
else STR(UnitPrice*1.25, 6, 2)
end 調漲後價格 
from Products
--19
select EmployeeID, FirstName+LastName Name,Title, 
case 
when TitleOfCourtesy='Mr.' then '先生'
when TitleOfCourtesy='Mrs.' or TitleOfCourtesy='Ms.' then '女士'
when TitleOfCourtesy='Dr.' then '博士'
else 'NA'
end TitleOfCourtesy, BirthDate 
from Employees
--20
select ProductID, SUM(Quantity*UnitPrice) 銷售總金額, 
case 
when SUM(Quantity*UnitPrice)>=100000 then '極優'
when SUM(Quantity*UnitPrice)<100000 and SUM(Quantity*UnitPrice)>50000 then '優'
when SUM(Quantity*UnitPrice)<=50000 then '尚可'
end 等級
from [Order Details]
group by ProductID
order by SUM(Quantity*UnitPrice) desc

--L
select *from Orders
--21
select OrderID, OrderDate, CustomerID, EmployeeID from Orders
where OrderID not in (select OrderID from [Order Details])
--22
select CustomerID, CompanyName, ContactName from Customers
where CustomerID not in (select CustomerID from Orders)

--M
select CustomerID,OrderDate from Orders
select CustomerID from Orders where DATEPART(YEAR,OrderDate)='1996' and DATEPART(MONTH,OrderDate)='05'
--23
select CustomerID, CompanyName, ContactName from Customers
where CustomerID not in (select CustomerID from Orders where DATEPART(YEAR,OrderDate)=1996 and DATEPART(MONTH,OrderDate)=5)

--N
select * from Orders
select OrderID from Orders where OrderDate='1997/06/02'
select * from [Order Details]
select OrderID, ProductID from [Order Details] where OrderID in (select OrderID from Orders where OrderDate='1997/06/02')
select * from Products
select ProductID, CategoryID from Products 
where ProductID in (select ProductID from [Order Details] where OrderID in (select OrderID from Orders where OrderDate='1997/06/02'))
--24
select CategoryID, CategoryName
from Categories 
where CategoryID not in (select CategoryID from Products 
where ProductID in (select ProductID from [Order Details] 
where OrderID in (select OrderID from Orders where OrderDate='1997/06/02')))

--O
--25
select ProductID, ProductName, CategoryID
from Products 
where CategoryID not in (select CategoryID from Products 
where ProductID in (select ProductID from [Order Details] 
where OrderID in (select OrderID from Orders where OrderDate='1997/06/02')))

--P
--26
select EmployeeID, FirstName+LastName Name, CONVERT(varchar, HireDate, 111) 到職日, STR(ROUND(DATEDIFF(MONTH, HireDate, GETDATE())/12.0, 1), 4, 1) 年資 from Employees
where DATEDIFF(MONTH, HireDate, GETDATE())/12.0>14

--Q
--27
select top 50 OrderID, ProductID, Quantity, UnitPrice from [Order Details]
order by UnitPrice desc, OrderID desc, ProductID desc

--R
--28
select top 15 A.CustomerID, SUM(B.Quantity*B.UnitPrice) 交易總金額 
from Orders A left outer join [Order Details] B on A.OrderID=B.OrderID
group by A.CustomerID
order by SUM(B.Quantity*B.UnitPrice) desc

--S
select * from Orders
select * from [Order Details]
--29
select AVG(C.TS) 客戶交易總金額前十五名之平均值 
from (select top 15 SUM(B.Quantity*B.UnitPrice) TS from Orders A left outer join [Order Details] B on A.OrderID=B.OrderID
group by A.CustomerID
order by SUM(B.Quantity*B.UnitPrice) desc) C
--30
select C.CategoryID,C.Number
from(select CategoryID,DENSE_RANK()over(order by COUNT(*) desc) RK,COUNT(*) Number from Products 
group by CategoryID) C
where C.RK<=3
order by C.RK 

