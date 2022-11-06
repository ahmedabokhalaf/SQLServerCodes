--1.Add new column (derived column) named age in Dependent table--
alter table [dbo].[Dependent] 
add Age as year(getdate())-year(Bdate)

--2.Display max and min salary for employees for each gender--
select MAX(Salary) as MaxSal, MIN(Salary) as MinSal, Sex
from Employee
group by Sex

--3.Display number of employees in each department that are supervised by 321654.--
select COUNT(*), Dno
from Employee
where Superssn=321654
group by Dno

----4----

--5.A new law has been applied to the company to hire employees 
--with only birth dates after 1990
--, Make appropriate changes to the table.
create rule LowRule as year(@x)>1990
sp_bindrule LowRule, 'Employee.Bdate'

--6.Create a new user data type named gender with the following Criteria:
--nchar(1) 
--default: M 
create default genderDefault as 'M'
sp_bindefault genderDefault, Gender
create type Gender from nchar(1)

--9.create a rule for this Data type :values must be in (F,M) 
--and associate it to the sex column in Dependent then try 
--to insert in the table without sex column value. What’ll happen?--
create rule Gender as @x='F' or @x='M'
sp_bindrule Gender, 'Dependent.Sex'

--10.Create New table Named newTable with location 
--column, and use the new UDD (gender) you’ve just created on it.
--a.Make also name, ID column (don’t make it identity).
--
create table newTable
(
	_Name nvarchar(200),
	id int not null,
	UDD gender,
	_Location nvarchar(300)
)

----11----
create sequence IdSequence
as int
start with 1
increment by 1

insert into newTable(_Name, id)
values ('Hassan', NEXT VALUE FOR idsequence)

insert into newTable(_Name, id)
values ('Mahmoud', NEXT VALUE FOR idsequence)

insert into newTable(_Name, id)
values ('Ali', NEXT VALUE FOR idsequence)

delete from newTable 
where id=2;
select * from newTable

insert into newTable(_Name, id)
values ('Mostafa', NEXT VALUE FOR idsequence)

insert into newTable(_Name, id)
values ('Bateekh', NEXT VALUE FOR idsequence)

insert into newTable(_Name)
values ('Mshmsh')