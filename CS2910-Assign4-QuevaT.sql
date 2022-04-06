drop database if exists company;
create database Company;

use Company;

create table Employee
(Fname		varchar(15)		not null,
Minit		char,
Lname		varchar(15)		not null,
Ssn		char(9)			not null,
Bdate		Date,
Address		Varchar(30),
Sex		char,
Salary		decimal(10,2),
Super_ssn	char(9),
Dno		int			not null,
primary key (Ssn));

create table Department
(Dname		Varchar(15)		not null,
Dnumber		int			not null,
Mgr_ssn		char(9)			not null,
Mgr_start_date	date,
Primary key(Dnumber),
unique(Dname),
foreign key(Mgr_ssn) references Employee(Ssn));

create table Dept_Locations
(Dnumber	int			not null,
Dlocation	varchar(15)		not null,
Primary key(Dnumber,Dlocation),
foreign key(Dnumber) references Department(Dnumber));

create table Project
(Pname		varchar(15)		not null,
Pnumber		int			not null,
Plocation	varchar(15),
Dnum		int			not null,
Primary key(Pnumber),
unique(Pname),
foreign key(Dnum) references Department(Dnumber));

create table Works_on
(Essn		char(9)			not null,
Pno		int			not null,
Hours		Decimal(3,1),
Primary key(Essn,Pno),
foreign key(Essn) references Employee(Ssn),
foreign key(Pno) references Project(Pnumber));

create table Dependent
(Essn		char(9)			not null,
Dependent_name	varchar(15)		not null,
Sex		char,
Bdate		date,
Relationship	varchar(8),
Primary key(Essn,Dependent_name),
foreign key(Essn) references Employee(Ssn));

insert into Employee(Fname,minit,Lname,Ssn,Bdate,Address,Sex,Salary,Super_ssn,Dno) values
('John','B','Smith','123456789','1965-01-09','731 Frondren, Houston, TX','M','30000','333445555','5'),
('Franklin','T','Wong','333445555','1955-12-08','638 Voss, Houston,TX','M','40000','888665555','5'),
('Alicia','J','Zelaya','999887777','1968-01-19','3321 Castle, Spring,TX','F','25000','987654321','4'),
('Jennifer','S','Wallace','987654321','1941-06-20','291 Berry, Bellaire,TX','F','43000','888665555','4'),
('Ramesh','K','Narayan','666884444','1962-09-15','975 Fire Oak, Humble,TX','M','38000','333445555','5'),
('Joyce','A','English','453453453','1972-07-31','5631 Rice, Houston,TX','F','25000','333445555','5'),
('Ahmad','V','Jabbar','987987987','1969-03-29','980 Dallas, Houston,TX','M','25000','987654321','4'),
('James','E','Borg','888665555','1937-11-10','450 Stone, Houston,TX','M','55000',NULL,'1');

Alter table employee add foreign key(Super_ssn) references employee(Ssn);

insert into Department(Dname,Dnumber,Mgr_ssn,Mgr_start_date) values
('Research','5','333445555','1988-05-22'),
('Administration','4','987654321','1995-01-01'),
('Headquarters','1','888665555','1981-06-19');

insert into Dept_Locations(Dnumber,Dlocation) values
('1','Houston'),
('4','Stafford'),
('5','Bellaire'),
('5','Sugarland'),
('5','Houston');

insert into Project(Pname,Pnumber,Plocation,Dnum) values
('ProductX','1','Bellaire','5'),
('ProductY','2','Sugarland','5'),
('ProductZ','3','Houston','5'),
('Computerization','10','Stafford','4'),
('Reorganization','20','Houston','1'),
('Newbenefits','30','Stafford','4');

insert into Works_on(Essn,Pno,Hours) values	#supposedly an error occurs here
('123456789','1','32.5'),
('123456789','2','7.5'),
('666884444','3','40.0'),
('453453453','1','20.0'),
('453453453','2','20.0'),
('333445555','2','10.0'),
('333445555','3','10.0'),
('333445555','10','10.0'),
('333445555','20','10.0'),
('999887777','30','30.0'),
('999887777','10','10.0'),
('987987987','10','35.0'),
('987987987','30','5.0'),
('987654321','30','20.0'),
('987654321','20','15.0'),
('888665555','20',NULL);

insert into Dependent(Essn,Dependent_name,Sex,Bdate,Relationship) values
('333445555','Alice','F','1986-04-05','Daughter'),
('333445555','Theodore','M','1983-10-25','Son'),
('333445555','Joy','F','1958-05-03','Spouse'),
('987654321','Abner','M','1942-02-28','Spouse'),
('123456789','Michael','M','1988-01-04','Son'),
('123456789','Alice','F','1988-12-30','Daughter'),
('123456789','Elizabeth','F','1967-05-05','Spouse');


/*
----------------------------------------------------------------------------------------------------------------------------------
Answers to Questions from textbook:
*/

#6.10.a.
select distinct Fname,Minit,Lname
from Employee,works_on,Project,department
where dno='5' and Hours>10 and pno=Pnumber and pname='ProductX';

#6.10.a is wrong: forgot condition where employee.ssn=works_on.essn

#6.10.b
select Fname,Minit,Lname from Employee,dependent where Ssn=Essn and Fname=Dependent_name;
\p;

#6.10.c
select Fname,Minit,Lname from Employee where super_ssn in(select ssn from employee where fname='Franklin' and lname='Wong');
\p;

#7.5.a
select dname,count(*) from employee,department where dno=dnumber group by dno having avg(salary)>30000;
\p;

#7.5.b
#Yes, we can specify this query in SQL.
select dname as Department,count(*) as count from employee,department where salary>30000 and sex='M' and dno=dnumber group by dno;
\p;

#7.7.a
select Fname,Lname from employee where dno in(select dno from employee where salary=(select max(salary) from employee));
\p;

#7.7.b
select Fname,Lname from employee where Super_ssn in(select ssn from employee where super_ssn='888665555');
\p;

#7.7.c
select Fname,Lname from employee where salary-10000>(select min(salary) from employee);
select'';


#Notes:
#doing this -->: select "debug message" as "";
#will allow us to debug the code