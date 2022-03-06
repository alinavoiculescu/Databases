--14
create table emp0_avo as select * from employees where 1=0;
insert all
when department_id = 80 then into emp0_avo
when department_id != 80 and salary < 5000 then into emp1_avo
when department_id != 80 and salary between 5000  and 10000  then into emp2_avo
else
into emp3_avo
select * from employees;

--16
update emp_avo
set job_id = 'SA_REP'
where department_id = 80 and nvl(commission_pct, 0) = commission_pct;
rollback;

--18
update emp_avo
set commission_pct = (select sum(commission_pct) from emp_avo)/((select max(employee_id) from emp_avo) - (select min(employee_id) from emp_avo) + 1)
where salary = (select min(salary) from emp_avo);

update emp_avo
set salary = (select sum(salary) from emp_avo)/((select max(employee_id) from emp_avo) - (select min(employee_id) from emp_avo) + 1)
where salary = (select min(salary) from emp_avo);

--19
update emp_avo
set job_id = (select job_id from emp_avo where employee_id = 205)
where employee_id = 114;

update emp_avo
set department_id = (select department_id from emp_avo where employee_id = 205)
where employee_id = 114;

--21
delete from emp_avo where nvl(commission_pct, 0) = 0;

rollback;

--22
delete from dept_avo where nvl(manager_id, 0) = 0;

rollback;