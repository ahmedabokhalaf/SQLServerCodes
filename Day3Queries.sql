------------------Problem1--------------
----1----
select * 
from [dbo].[Employee];

----2----
select Fname, Lname, Salary, Dno 
from [dbo].[Employee];

----3----
select Pname, Plocation, Dnum
from [dbo].[Project];

----4----
select Fname+' '+Lname as FullName, Salary*10/100 as ANNUALCOMM
from [dbo].[Employee];

----5----
select SSN, Fname+' '+Lname as FullName
from [dbo].[Employee] 
where Salary>1000;

----6----
select SSN, Fname+' '+Lname as FullName
from [dbo].[Employee] 
where Salary*12>10000;

----7----
select Fname+' '+Lname as FullName,Salary
from [dbo].[Employee] 
where Sex = 'F';

----8----
select Dnum, Dname
from [dbo].[Departments]
where MGRSSN = 968574;

----9----
select [Pnumber],[Pname],[Plocation]
from [dbo].[Project]
where[Dnum]=10;
-------------------------------------------------------------------
------------------DML-----------------
----1----
insert into [dbo].[Employee] 
Values ('Ahmed', 'Khalaf', 102672, Null, Null, 'M', 3000, 112233, 30);

select * from [dbo].[Employee];

update [dbo].[Employee] 
set Bdate = 1997-06-11, Address='Asyut' 
where SSN=102672;

----2----
insert into [dbo].[Employee]([Fname], [Lname], [Dno], [SSN])
Values ('Ahmed', 'Thabet', 30, 102660);

----3----
update [dbo].[Employee] 
set Salary=Salary+(Salary*20/100)
where SSN=102672;