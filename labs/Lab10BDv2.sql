CREATE TABLE EMP_prof AS SELECT * FROM employees; 
CREATE TABLE DEPT_prof AS SELECT * FROM departments;

ALTER TABLE emp_prof 
ADD CONSTRAINT pk_emp_prof PRIMARY KEY(employee_id); 
ALTER TABLE dept_prof 
ADD CONSTRAINT pk_dept_prof PRIMARY KEY(department_id); 
ALTER TABLE emp_prof 
add CONSTRAINT fk_emp_dept_prof FOREIGN KEY(department_id) REFERENCES dept_prof(department_id);


--1
create or replace  view viz_emp30_prof as
select employee_id, last_name, email, salary
from emp_prof
where department_id = 30;

select * from viz_emp30_prof;
describe viz_emp30_prof;

insert into viz_emp30_prof values(300, 'Nume300', 'Nume300@gmail.com', 1200);

--2
create or replace  view viz_emp30_prof as
select employee_id, last_name, email, salary, hire_date, job_Id
from emp_prof
where department_id = 30;

select * from emp_prof;
insert into viz_emp30_prof values(300, 'Nume300', 'Nume300@gmail.com', 
1200, to_date('14-10-1999', 'DD-MM-YYYY'),'IT_PROG');

UPDATE viz_emp30_prof
SET hire_date=hire_date-15
WHERE employee_id=300;

update emp_prof
SET department_id=30
WHERE employee_id=300;

select * from viz_emp30_prof;

delete from viz_emp30_prof where employee_id = 300;

--3
create or replace view VIZ_EMPSAL50_PROF as
select employee_id, last_name, email, salary * 12 sal_anual, hire_date, job_id
from emp_prof
where department_id = 50;

select * from VIZ_EMPSAL50_PROF;

describe VIZ_EMPSAL50_PROF;

--4
--a
insert into VIZ_EMPSAL50_PROF values(301, 'Nume301', 'Nume301@gmail.com',
12000, sysdate, 'IT_PROG');

--b
desc USER_UPDATABLE_COLUMNS;

select * from USER_UPDATABLE_COLUMNS 
where table_name = 'VIZ_EMPSAL50_PROF';

--c
insert into VIZ_EMPSAL50_PROF(employee_id, last_name, email, hire_date, job_id)
values(301, 'Nume301', 'Nume301@gmail.com', sysdate, 'IT_PROG');

select * from VIZ_EMPSAL50_PROF;

select * from emp_prof;

--5
--a

create or replace view VIZ_EMP_DEP30_PROF as
select employee_id, last_name, email, salary, hire_date, job_id, e.department_id employee_dept,
department_name
from emp_Prof e, dept_prof d
where e.department_id = d.department_id
and e.department_id = 30;

select * from VIZ_EMP_DEP30_PROF;

--b
insert into VIZ_EMP_DEP30_PROF values(302, 'Nume302', 'Nume302@gmail.com',
1200,sysdate, 'IT_PROG', 40, 'Test');

--c
select * from USER_UPDATABLE_COLUMNS 
where table_name = 'VIZ_EMP_DEP30_PROF';

insert into VIZ_EMP_DEP30_PROF(employee_id, last_name, email, salary, hire_date, job_id, employee_dept) 
values(302, 'Nume302', 'Nume302@gmail.com',1200,sysdate, 'IT_PROG', 30);

select * from VIZ_EMP_DEP30_PROF;
select * from emp_prof;
select * from dept_prof;

--d
delete from VIZ_EMP_DEP30_PROF where employee_id = 302;

--6
create or replace view VIZ_DEPT_SUM_PROF(cod_dept, min_sal, max_sal, avg_sal) as
select department_id , min(salary), max(salary), avg(salary)
from emp_prof
group by department_id;

select * from VIZ_DEPT_SUM_PROF;

select * from USER_UPDATABLE_COLUMNS 
where table_name = 'VIZ_DEPT_SUM_PROF';


--7
create or replace  view viz_emp30_prof as
select employee_id, last_name, email, salary, hire_date, job_Id, department_id 
from emp_prof
where department_id = 30
WITH CHECK OPTION CONSTRAINT viz_check_constr2;


describe USER_CONSTRAINTS;
select * from USER_CONSTRAINTS;

insert into viz_emp30_prof values(305, 'Nume305', 'Nume305@gmail.com', 
1200, to_date('14-10-1999', 'DD-MM-YYYY'),'IT_PROG', 30);

select * from viz_emp30_prof;
select * from emp_prof;

update viz_emp30_prof
set department_id = 60
where employee_id = 305;

 --8
 --a
 create or replace view  VIZ_EMP_S_PROF as
 select employee_id, last_name, email, salary, hire_date, job_Id, e.department_id emp_dept
 from emp_prof e, dept_prof d
 where e.department_id = d.department_id
 and upper(d.department_name) like 'S%';
 
 select * from VIZ_EMP_S_PROF;
 
select * from USER_UPDATABLE_COLUMNS 
where table_name = 'VIZ_EMP_S_PROF';

--b
 create or replace view  VIZ_EMP_S_PROF as
 select employee_id, last_name, email, salary, hire_date, job_Id, e.department_id emp_dept
 from emp_prof e, dept_prof d
 where e.department_id = d.department_id
 and upper(d.department_name) like 'S%'
 WITH READ ONLY;
 
 insert into VIZ_EMP_S_PROF values(306, 'Nume306', 'Nume306@gmail.com', 
1200, to_date('14-10-1999', 'DD-MM-YYYY'),'IT_PROG', 50);

--9

SELECT view_name, text FROM user_views WHERE view_name LIKE '%PROF';

--10
-- tema

--11 
--tema

--12
CREATE VIEW viz_emp_prof2 (employee_id, first_name, last_name, 
email UNIQUE DISABLE NOVALIDATE, phone_number, 
CONSTRAINT pk_viz_emp_prof3 PRIMARY KEY (employee_id) DISABLE NOVALIDATE) AS
SELECT employee_id, first_name, last_name, email, phone_number 
FROM emp_prof;


describe viz_emp_prof2;
--b
--tema

--13

ALTER TABLE emp_prof
ADD CONSTRAINT ck_name_emp_prof CHECK (UPPER(last_name) NOT LIKE 'WX%');

CREATE OR REPLACE VIEW viz_emp_wx_prof AS 
SELECT * FROM emp_prof 
WHERE UPPER(last_name) NOT LIKE 'WX%' 
WITH CHECK OPTION CONSTRAINT ck_name_emp_prof22; 
select * from viz_emp_wx_prof;

UPDATE viz_emp_wx_prof SET last_name = 'Wxyz' WHERE employee_id = 150;


--14
create index IDX_EMP_LAST_NAME_Prof on
emp_prof(last_name);

--15
create index IDX_EMP_LNH on
emp_prof(last_name, first_name, hire_date);

alter table emp_prof
add constraint uniq_lfh_prof Unique(last_name, first_name, hire_date);


--16
create index idx_emp_dept_prof on emp_Prof(department_id);

--17
create index idx_dept_name_Prof on dept_prof(upper(department_name));

drop index IDX_EMP_LAST_NAME_Prof;

create index IDX_EMP_LAST_NAME_Prof on
emp_prof(lower(last_name));

--18
select * from USER_INDEXES where table_name = 'EMP_PROF' or
table_name = 'DEPT_PROF';

select * from USER_IND_COLUMNS  where table_name = 'EMP_PROF' or
table_name = 'DEPT_PROF';


--20
select * from USER_SYNONYMS;

create public synonym emp_public_prof for emp_prof;

select * from emp_public_prof;

--21
create synonym v30_Prof for VIZ_EMP30_Prof;

select * from v30_Prof;

--22
create synonym dept_syn_prof2 for dept_prof2;

select * from dept_syn_prof2;

rename dept_prof2 to dept_prof;

--23

select 'DROP SYNONYM '|| synonym_name || ' ;' from USER_SYNONYMS
where upper(synonym_name) like '%PROF';
-- spool caleaX/numeFisier.sql 