----1----
select d.Dnum, d.Dname, e.SSN, e.Fname, e.Lname
from Departments d, Employee e
where d.MGRSSN=e.SSN

----2----
select d.Dname, p.Pname
from Departments d, Project p
where d.Dnum=p.Dnum

----3----
select emp.Fname+' '+emp.Lname as EmpFullName, dep.*
from Employee emp, Dependent dep
where emp.SSN=dep.ESSN

----4----
select p.Pnumber, p.Pname, p.Plocation
from Project p
where p.City='Cairo' or p.City='Alex'

----5----
select * 
from Project p
where p.Pname like 'A%'

----6----
select *
from Employee e
where e.Dno=30 and e.Salary between 1000 and 2000

----7----
select e.Fname,e.Lname
from Works_for wf, Project p, Employee e
where e.Dno=10 and e.SSN=wf.ESSn 
	and wf.Hours>=10 and p.Pnumber=wf.Pno and p.Pname='AL Rabwah'

----8----
select emp.Fname+' '+emp.Lname as EmpFullName,
		Supervisor.Fname+' '+Supervisor.Lname as SupervisorFullName
from Employee emp, Employee Supervisor
where Supervisor.SSN=emp.Superssn 
	and Supervisor.Fname='Kamel' and Supervisor.Lname='Mohamed'

----9----
select e.Fname,e.Lname, p.Pname
from Employee e, Works_for wf, Project p
where e.SSN=wf.ESSn and p.Pnumber=wf.Pno
order by p.Pname

----10----
select p.Pnumber, d.Dname, e.Lname, e.Address, e.Bdate
from Departments d, Project p, Employee e
where d.Dnum=p.Dnum and d.MGRSSN=e.SSN and p.City='Cairo'

----11----
select e.*
from Departments d,Employee e
where d.MGRSSN=e.SSN

----12----
select e.*, d.*
from Employee e left outer join Dependent d
on e.SSN=d.ESSN
