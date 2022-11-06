--1.Create a stored procedure 
--to show the number of students per department. [use ITI DB]
create proc NumStd @dept int
as 
select COUNT(s.St_Id), d.Dept_Name
from Department d, Student s
where d.Dept_Id=s.Dept_Id
group by Dept_Name

execute NumStd 10
------------------------
--2.Create a stored procedure that will check for the number of employees 
--in the project 100 if they are more than 3 print a message to the user 
--“'The number of employees in the project 100 is 3 or more'” if they are less 
--display a message to the user “'The following employees work for the project 100” 
--in addition to the first name and last name of each one. [Company DB] 
alter proc NumEmp @project int
as
begin
	declare @n int
	select @n = Count(e.SSN)
	from Employee e, Works_for wf, Project p
	where e.SSN=wf.ESSn and p.Pnumber=@project and p.Pnumber=wf.Pno
	if @n>3
		select concat('The number of employees in the project ',@project,' is ', @n)
	else
		begin
			select CONCAT('The following employees work for the project ',@project)
			select e.Fname, e.Lname 
			from Employee e, Works_for wf, Project p
			where e.SSN=wf.ESSn and p.Pnumber=@project and p.Pnumber=wf.Pno
		end
end

execute NumEmp 500
------------------------
--3.Create a stored procedure that will be used in case there is an old employee 
--has left the project and a new one become instead of him. 
--The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) 
--and it will be used to update works_for table. [Company DB]
ALTER proc ChkEmp @oldEmpNo int, @newEmpNo int, @projectNo int
as
begin
	if exists(
		select wf.ESSn
		from Works_for wf
		where wf.ESSn=@oldEmpNo and wf.Pno=@projectNo
	)
		begin
			update Works_for
			set ESSn=@newEmpNo
			where Pno=@projectNo and ESSn=@oldEmpNo
		end
end
execute ChkEmp 9, 512463, 500
select * from Works_for
----------------------------------------------------
--4.Create an Audit table with the following structure
create table ProHistory
(
	ProjectNo int,
	UserName varchar(300),
	ModifiedDate datetime,
	Hours_Old int,
	Hours_New int
)
go
create trigger myTrig
on works_for
after update
as
	if UPDATE([Hours])
	begin
		declare @oldHours int, @newHours int, @id int
		select @oldHours=[Hours] from deleted
		select @newHours=[Hours] from inserted
		select @id=[Pno] from deleted

		insert into ProHistory values
		(@id, suser_name(), getdate(), @oldHours, @newHours)
	end

go
update Works_for set Hours=70 where Pno=200
go
select * from Prohistory
----------------------------------------------------------------
--5.Create a trigger to prevent anyone from inserting a new record in the Department table [ITI DB]
--Print a message for the user to tell him that he ‘can’t insert a new record in that table’
alter trigger Prevent
on Department
instead of insert
as
	print 'cant insert a new record in that table'
insert into Department(Dept_Id, Dept_Name) values(15,'IT')
-----------------------------------------------------------------
--6.Create a trigger that prevents the insertion Process 
--for the Employee table in September and test it [Company DB].
alter trigger Prevent
on Employee
after insert
as
	if Month(GETDATE())=9
		print 'Cant insert a new record in that table in September'
	else
		print 'Insertion Done'
	rollback
insert into Employee(SSN,Fname,Lname) values (10,'Mahmoud','Mohamed')
select * from Employee
-------------------------------------------------------------------
--7.Create a trigger that prevents users from altering any table in Company DB.
create trigger Prevent
on database
for alter_table
as
	print'Cant Altering Any Table'
rollback

alter table departments add fname varchar(10)
---------------------------------------------------------------
--8.Create a trigger on student table after insert to add Row in a 
--Student Audit table (Server User Name, Date, Note) where the note will be 
--“[username] Insert New Row with Key= [Key Value] in table [table name]”
create table AuditStd
(
	Suser varchar(300),
	DateModified datetime,
	Note varchar(500)
)
go
alter trigger myTrig
on Student
after insert
as
	insert into [dbo].[AuditStd]
	select SUSER_NAME(), GETDATE(), 
	SUSER_NAME()+' insert new row with Key='+ CAST(s.St_Id as varchar(10))+' in Student' 
	from Student s where St_Id in (select St_Id from inserted)
go
insert into Student(St_Id,St_Fname,St_Lname)
values (102,'aaaaaaaa','bbbbbbbb')

select * from Student
select * from [dbo].[AuditStd]
-------------------------------------------------------
--9.Create a trigger on student table instead of delete to add Row 
--in Student Audit table (Server User Name, Date, Note) 
--where the note will be "try to delete Row with Key= [Key Value]”
create trigger delTrig
on Student
instead of delete
as 
insert into [dbo].[AuditStd]
	select SUSER_NAME(), GETDATE(), 
	'Try to delete Row with Key='+ CAST(s.St_Id as varchar(10)) 
	from Student s where St_Id in (select St_Id from deleted)

delete from Student where St_Id=100
select * from AuditStd
--------------------------------------------------------