--Create a scalar function 
--that takes a date and returns 
--the Month name of that date. test (‘1/12/2009’)
create function GetMonth(@date datetime)
returns varchar(20)
begin
	declare @month varchar(20)
	set @month = Format(@date, 'MMMM')

	return @month
end
select dbo.GetMonth('4-12-2009')

--Create a multi-statements table-valued function 
--that takes 2 integers and returns the values between them.
create function Table_Valued(@x int, @y int)
returns @t table(valsBetweenXY int)
as
begin
	while @x<@y
	begin
		select @x+=1
		insert into @t
		select @x
	end
	return 
end

select * from dbo.Table_Valued(10,20)

--Create a tabled valued function 
--that takes Student No and returns 
--Department Name with Student full name
create function StdInfo(@id int)
returns @t table(sName varchar(200), dName varchar(20))
as
begin
	insert into @t 
	select s.St_Fname+' '+s.St_Lname, d.Dept_Name
	from Student s, Department d
	where s.St_Id=@id and d.Dept_Id=s.Dept_Id
	return
end

select * from dbo.StdInfo(3)

--4.Create a scalar function that takes Student ID and returns a message to the user (use Case statement)
--a.If the first name and Last name are null then display 'First name & last name are null'
--b.If the First name is null then display 'first name is null'
--c.If the Last name is null then display 'last name is null'
--d.Else display 'First name & last name are not null'
create function NameCheck(@id int)
returns varchar(200)
begin
	declare @msg varchar(200)
	declare @first varchar(100)
	declare @last varchar(100)
	select @first = St_Fname from Student where St_id=@id
	select @last = St_Lname from Student where St_id=@id
	set @msg = (
	select case
		when @first is null and @last is null then 'First name & last name are null'
		when @first is null and @last is not null then 'First name is null'
		when @first is not null and @last is null then 'Last name is null'
	else
		'First name & last name are not null'
	end
	)
	return @msg
end

select dbo.NameCheck(5)
select * from Student

--5.Create a function that takes an integer 
--that represents the format of the Manager hiring date 
--and displays department name, Manager Name, and hiring date with this format.   
create function ManagerInfo(@hd int)
returns @t table(Dname varchar(20), MgrName varchar(200), hd datetime)
begin
	if @hd=1
		insert into @t
		select d.Dname, e.Fname+' '+e.Lname, Format(d.[MGRStart Date], 'dd-MM-yy')
		from Departments d, Employee e
		where d.Dnum=e.Dno and d.MGRSSN = e.SSN
	else if @hd=2
		insert into @t
		select d.Dname, e.Fname+' '+e.Lname, Format(d.[MGRStart Date], 'dd/MM/yy')
		from Departments d, Employee e
		where d.Dnum=e.Dno and d.MGRSSN = e.SSN
	return
end

select * from dbo.ManagerInfo(2)
-----------------
--6.Create multi-statements table-valued function that takes a string
--If string='first name' returns student first name
--If string='last name' returns student last name 
--If string='full name' returns Full Name from student table 
--Note: Use the “ISNULL” function

create function Std_Info(@id int, @str varchar(30))
returns @t table(StdName varchar(200))
as
begin
	if(@str = 'first name')
		insert into @t 
		select ISNull([St_Fname],'FirstNameEmpty') from [dbo].[Student] where [St_Id]=@id
	else if(@str = 'last name')
		insert into @t 
		select ISNull([St_Lname],'LastNameEmpty') from [dbo].[Student] where [St_Id]=@id
	else if(@str = 'full name')
		insert into @t 
		select ISNull([St_Fname],'FirstNameEmpty')
		+' '+ISNull([St_Lname],'LastNameEmpty') from [dbo].[Student] where [St_Id]=@id
	return 
end

select * from dbo.Std_Info(10, 'full name')
select * from Student

--7.Write a query that returns the 
--Student No and Student first name without the last char
select St_Id, substring(St_Fname,1,len(St_Fname)-1) as FirstName
from Student
----------------------------------
--1.Create a function that 
--takes project number and display all employees in this project

create function ProEmp(@pno int)
returns @t table(Employees varchar(200))
as
begin
	insert into @t
	select e.fname+' '+e.lname
	from [dbo].[Employee] e, Works_for wf
	where e.ssn=wf.essn and wf.pno=@pno
	return
end

select * from dbo.ProEmp(400)