use company_emp

-------------Problem 14

CREATE TABLE Emp(
[Group]  varchar(20),
[Sequence]  int )

INSERT INTO Emp VALUES('A',1)
INSERT INTO Emp VALUES('A',2)
INSERT INTO Emp VALUES('A',3)
INSERT INTO Emp VALUES('A',5)
INSERT INTO Emp VALUES('A',6)
INSERT INTO Emp VALUES('A',8)
INSERT INTO Emp VALUES('A',9)
INSERT INTO Emp VALUES('B',11)
INSERT INTO Emp VALUES('C',1)
INSERT INTO Emp VALUES('C',2)
INSERT INTO Emp VALUES('C',3)

-- Write a SQL quary to find the maximum and minimum values of continous 'Sequence' in each 'group'


select * from Emp



select [Group],min([Sequence]) as min_seq,max([Sequence]) as max_seq
from 
( select [Group],
[Sequence],
[Sequence]-ROW_NUMBER() over(partition by [Group] order by [Sequence]) as [Split]
from Emp) as a
group by [Group], [Split]
order by [Group]


-------------Problem 15

CREATE TABLE Student(
[Student_Name]  varchar(30),
[Total_Marks]  int ,
[Year]  int)

INSERT INTO Student VALUES('Rahul',90,2010)
INSERT INTO Student VALUES('Sanjay',80,2010)
INSERT INTO Student VALUES('Mohan',70,2010)
INSERT INTO Student VALUES('Rahul',90,2011)
INSERT INTO Student VALUES('Sanjay',85,2011)
INSERT INTO Student VALUES('Mohan',65,2011)
INSERT INTO Student VALUES('Rahul',80,2012)
INSERT INTO Student VALUES('Sanjay',80,2012)
INSERT INTO Student VALUES('Mohan',90,2012)

select* from Student

--Write an SQl quary to display student_name,total_marks,year,prev_year_marks 
--for those whose total_marks are greater then or equal to the previous year

select Student_Name, Total_Marks,Year,Prev_Yr_Marks
from 
	(select Student_Name,Year,Total_Marks,Prev_Yr_Marks,
	case when Total_Marks >= Prev_Yr_Marks then 1 else 0 end as flag
	from(
		select Student_Name,Year,Total_Marks,
		lag(Total_Marks) over(partition by Student_Name order by Year)
		as Prev_Yr_Marks
		from Student) as a) as b
		where flag=1


---------Problem 16

CREATE TABLE Emp_Details (
EMPID int,
Gender varchar,
EmailID varchar(30),
DeptID int)


INSERT INTO Emp_Details VALUES (1001,'M','YYYYY@gmaix.com',104)
INSERT INTO Emp_Details VALUES (1002,'M','ZZZ@gmaix.com',103)
INSERT INTO Emp_Details VALUES (1003,'F','AAAAA@gmaix.com',102)
INSERT INTO Emp_Details VALUES (1004,'F','PP@gmaix.com',104)
INSERT INTO Emp_Details VALUES (1005,'M','CCCC@yahu.com',101)
INSERT INTO Emp_Details VALUES (1006,'M','DDDDD@yahu.com',100)
INSERT INTO Emp_Details VALUES (1007,'F','E@yahu.com',102)
INSERT INTO Emp_Details VALUES (1008,'M','M@yahu.com',102)
INSERT INTO Emp_Details VALUES (1009,'F','SS@yahu.com',100)


select* from Emp_Details

--Write an SQL quary to derive another column called email_list
--to display all emailid concanated with semicolon associated with a each dept_id


select DeptID,STRING_AGG(EmailID,'---') within group (order by EmailID) as Email_list
from Emp_Details
group by DeptID


------- Problem 17

CREATE TABLE [Order_Tbl](
 [ORDER_DAY] date,
 [ORDER_ID] varchar(10) ,
 [PRODUCT_ID] varchar(10) ,
 [QUANTITY] int ,
 [PRICE] int 
) 

INSERT INTO [Order_Tbl]  VALUES ('2015-05-01','ODR1', 'PROD1', 5, 5)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-01','ODR2', 'PROD2', 2, 10)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-01','ODR3', 'PROD3', 10, 25)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-01','ODR4', 'PROD1', 20, 5)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-02','ODR5', 'PROD3', 5, 25)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-02','ODR6', 'PROD4', 6, 20)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-02','ODR7', 'PROD1', 2, 5)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-02','ODR8', 'PROD5', 1, 50)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-02','ODR9', 'PROD6', 2, 50)
INSERT INTO [Order_Tbl]  VALUES ('2015-05-02','ODR10','PROD2', 4, 10)

select * from Order_Tbl


---write an SQL quary to get the highest sold product(Quantity*Price) on both the days

 select ORDER_DAY,PRODUCT_ID, QUANTITY*PRICE as Sold_Amount 
 from Order_Tbl where QUANTITY*PRICE in  
	(select max(QUANTITY*PRICE) from Order_Tbl
 group by ORDER_DAY)


 --write an SQl quary to get product total sales on 1st may and 2nd may adjacent to each other

 SELECT 
    PRODUCT_ID,
    ISNULL(SUM(CASE WHEN ORDER_DAY = '2015-05-01' THEN Quantity * Price ELSE 0 END), 0) AS TotalSales_1stMay,
    ISNULL(SUM(CASE WHEN ORDER_DAY = '2015-05-02' THEN Quantity * Price ELSE 0 END), 0) AS TotalSales_2ndMay
FROM Order_Tbl p
GROUP BY PRODUCT_ID
ORDER BY PRODUCT_ID;


-- write an SQL quary to gwt all products day wise that was ordered more than once

select ORDER_DAY,PRODUCT_ID,COUNT(*) as Order_more_than_once
FROM Order_Tbl
GROUP BY ORDER_DAY,PRODUCT_ID
HAVING COUNT(*)>1 



----PROBLEM 18

CREATE Table Employee
(
EmpID INT,
EmpName Varchar(30),
Salary Float,
DeptID INT
)

INSERT INTO Employee VALUES(1001,'Mark',60000,2)
INSERT INTO Employee VALUES(1002,'Antony',40000,2)
INSERT INTO Employee VALUES(1003,'Andrew',15000,1)
INSERT INTO Employee VALUES(1004,'Peter',35000,1)
INSERT INTO Employee VALUES(1005,'John',55000,1)
INSERT INTO Employee VALUES(1006,'Albert',25000,3)
INSERT INTO Employee VALUES(1007,'Donald',35000,3)


select * from Employee

select max(Salary) as totalsalary from Employee
where Salary<(select max(Salary) from  Employee)

-- write a SQL quary to find all employee who earn more  than the averrage salary in the corresponding department

SELECT 
    A.EmpName,
    A.DeptID,
    B.AvgSalary,
    A.Salary
FROM Employee A
INNER JOIN 
    (SELECT DeptID,AVG(Salary) AS AvgSalary
     FROM Employee
     GROUP BY DeptID) B
ON A.DeptID = B.DeptID
WHERE A.Salary > B.AvgSalary



----Problem 19

create  table amz_country (id int , country_name nvarchar(100));

insert into amz_country  values (1  ,'India');
insert into amz_country  values (2  ,'Australia');
insert into amz_country  values (3  ,'England');
insert into amz_country  values (4  ,'NewZealand');


select * from amz_country


-- write an SQL quary  which will fetch total schedue of matches between each taem vs opposite team


select CONCAT(t1.country_name,'   Vs   ' ,t2.country_name) as matches
from (select id,country_name from amz_country ) as t1
inner join
(select id, country_name from amz_country) as t2
on t1.id< t2.id



----Problem 20-----

Create Table Match_Result (
Team_1 Varchar(20),
Team_2 Varchar(20),
Result Varchar(20)
)

Insert into Match_Result Values('India', 'Australia','India');
Insert into Match_Result Values('India', 'England','England');
Insert into Match_Result Values('SouthAfrica', 'India','India');
Insert into Match_Result Values('Australia', 'England',NULL);
Insert into Match_Result Values('England', 'SouthAfrica','SouthAfrica');
Insert into Match_Result Values('Australia', 'India','Australia');


select * from Match_Result


---Write an SQL quary  to find number of match played by each team


WITH CTE_match_played AS (
    SELECT team,SUM(total) AS match_played
    FROM (SELECT Team_1 AS team, COUNT(*) AS total
        FROM Match_Result
        GROUP BY Team_1
        UNION ALL
        SELECT Team_2 AS team, COUNT(*) AS total
        FROM  Match_Result
        GROUP BY Team_2) AS a
    GROUP BY  team)
SELECT 
    team, match_played
FROM CTE_match_played;



----Total number of match won by each team

with cte_match_won as (
	select Result, count(*) as match_won from Match_Result
	where Result is not null
	group by Result)
select Result,match_won from cte_match_won


---Problem 21-----


Create Table Transaction_Table
(
AccountNumber int,
TransactionTime DateTime,
TransactionID int,
Balance int
)


Insert into Transaction_Table Values (550,'2020-05-12 05:29:44.120' ,1001,2000)
Insert into Transaction_Table Values (550,'2020-05-15 10:29:25.630' ,1002,8000)
Insert into Transaction_Table Values (460,'2020-03-15 11:29:23.620' ,1003,9000)
Insert into Transaction_Table Values (460,'2020-04-30 11:29:57.320' ,1004,7000)
Insert into Transaction_Table Values (460,'2020-04-30 12:32:44.233' ,1005,5000)
Insert into Transaction_Table Values (640,'2020-02-18 06:29:34.420' ,1006,5000)
Insert into Transaction_Table Values (640,'2020-02-18 06:29:37.120' ,1007,9000)

select * from Transaction_Table


--- Write an SQL quary to get most recent/latest balance--


WITH cte_recent_transactions AS (
    SELECT AccountNumber, TransactionTime, TransactionID, Balance
    FROM Transaction_Table),
cte_max_transactions AS (
    SELECT AccountNumber, MAX(TransactionTime) AS max_time 
    FROM Transaction_Table
    GROUP BY AccountNumber)
SELECT A.AccountNumber, B.max_time AS TransactionTime, A.Balance
FROM cte_recent_transactions A
INNER JOIN cte_max_transactions B 
    ON A.AccountNumber = B.AccountNumber AND A.TransactionTime = B.max_time;

