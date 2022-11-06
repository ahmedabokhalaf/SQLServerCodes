--1.Create a view that displays the student’s full name, 
--course name if the student has a grade of more than 50.
create view DisplayStd
as
select s.St_Fname+' '+s.St_Lname as StudentFullName, c.Crs_Name
from Student s, Stud_Course sc, Course c
where s.St_Id=sc.St_Id and sc.Grade > 50 and sc.Crs_Id = c.Crs_Id
go
select * from DisplayStd
-----------------------------------------
--2.Create an Encrypted view that displays manager names and the topics they teach. 
alter view DisplayMgr
with encryption
as
select i.Ins_Name, t.Top_Name, d.Dept_Name
from Instructor i, Department d, Topic t, Ins_Course ic, Course c
where i.Dept_Id=d.Dept_Id and i.Ins_Id=d.Dept_Manager
		and i.Ins_Id=ic.Ins_Id
		and c.Crs_Id=ic.Crs_Id
		and t.Top_Id=c.Top_Id
go
select * from DisplayMgr
-------------------------------------
--3.Create a view that will display Instructor Name, Department Name 
--for the ‘SD’ or ‘Java’ Department “. 
Create View InsDeptDisplay
as
select i.Ins_Name, d.Dept_Name
from Department d, Instructor i
where i.Dept_Id=d.Dept_Id and (d.Dept_Name='SD' or d.Dept_Name='Java')
go
select * from InsDeptDisplay
-------------------------------------------------------
--4.Create a view “V1” that displays student data for the student who lives in Alex 
--or Cairo.
--Note: Prevent the users to run the following query Update 
--V1 set 	st_address=’tanta’  Where st_address=’alex’;
alter view V1
as 
	select *
	from Student s
	where s.St_Address = 'Cairo' or s.St_Address = 'Alex'
	with check option
go
update V1 
set St_Address='tanta' 
where St_Address='Alex'

select * from V1
select * from Student
---------------------------------------


--------------Company_SD DB-----------------------
--1-Create a view that will display the project name and the number of employees 
--works on it.
alter view DisplayProj
as
select p.Pname, COUNT(e.SSN) as NumberOfEmps
from Project p, Employee e, Works_for wf
where p.Pnumber=wf.Pno and e.SSN=wf.ESSn
group by p.Pname
go
select * from DisplayProj
-----------------------------------------------
--2)Create a view named “v_D30” that will display employee number, 
--project number, hours of the projects in department 30.
create view V_D30
as
select p.Pnumber, SUM(wf.Hours) as Houres, Count(e.SSN) as NumOfEmps
from Employee e, Project p, Departments d, Works_for wf
where e.SSN=wf.ESSn and p.Pnumber=wf.Pno and d.Dnum=p.Dnum and d.Dnum=30
group by p.Pnumber
go
select * from V_D30
----------------------------------------------------------------
--3)Create a view named  “v_count “ that will display the project name and 
--the number of hours for each one. 
create view V_Count
as 
select p.Pnumber, SUM(wf.Hours) as NumHoures
from Project p, Works_for wf
where p.Pnumber=wf.Pno
group by p.Pnumber
go
select * from V_Count
--------------------------------------------------------
--Create a view named ” v_project_500” that will display the emp no. 
--for the project 500, use the previously created view  “v_D30”
create view V_Project_500
as
select p.Pnumber, SUM(wf.Hours) as Houres, Count(e.SSN) as NumOfEmps
from Employee e, Project p, Works_for wf
where e.SSN=wf.ESSn and p.Pnumber=500 and p.Pnumber=wf.Pno
group by p.Pnumber
go
select * from V_Project_500
---------------------------------------------------------------
--5)modify the view named  “v_without_budget”  to display 
--all DATA in project 300 and 400
create view V_Without_Budget
as
select p.*, d.Dname, wf.Hours as ProjectHoures, e.Fname+' '+e.Lname as EmpFullName
from Project p, Employee e, Works_for wf, Departments d
where p.Pnumber=wf.Pno and e.SSN=wf.ESSn and d.Dnum=p.Dnum and (p.Pnumber=300 or p.Pnumber=400)
go
select * from V_Without_Budget
----------------------------------------------------------
--6)Delete the views  “v_D30” and “v_count”
drop view V_D30
drop view V_Count

