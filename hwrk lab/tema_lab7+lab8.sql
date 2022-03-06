--LAB 7
--6
select d.department_name
from departments d, employees e
where d.department_id = e.department_id
group by d.department_name
having count(*) >= 15;

--16
select j.job_title, a.avgSal, (j.max_salary + j.min_salary)/2 - a.avgSal, a.nrAng
from jobs j, (select e.job_id, avg(e.salary) as avgSal,
              count(e.employee_id) as nrAng
              from employees e
              group by e.job_id) a
where j.job_id = a.job_id;

--LAB 8
--3
--from
select last_name, salary
from (select last_name, salary
      from employees e
      where salary = (select min(salary)
                      from employees
                      where e.department_id = department_id));

--4
select d.department_id, d.department_name, e.last_name
from departments d, employees e
where d.department_id = e.department_id
and e.hire_date = (select min(hire_date)
                   from employees
                   where e.department_id = department_id);
                   
--9
--not in
select department_id, department_name
from departments d
where department_id not in (select distinct nvl(department_id,0)
                            from employees);
                            
--14
--VARIANTA 1 (la cerinta 2 -> jobul avand salariul maxim = jobul care are
--            angajatul cu cel mai mare salariu dintre joburile al caror cod
--            incepe cu litera S)
with cerinta1 as (select job_id, sum(salary) as sumSal, count(*) as nrAng
                from employees
                join jobs using (job_id)
                group by job_id
                having job_id like 'S%'),
     cerinta2 as (select max(e.salary) as maxSal
                  from employees e, (select job_id, sum(salary) as sumSal, count(*) as nrAng
                                     from employees
                                     join jobs using (job_id)
                                     group by job_id
                                     having job_id like 'S%') cer1
                 where e.job_id = cer1.job_id)
select c1.sumSal,
decode(c1.job_id, (select c.job_id
                from cerinta1 c, employees e
                where c.job_id = e.job_id
                and e.salary = (select maxSal
                                from cerinta2)), (c1.sumSal / c1.nrAng),
       (select min(emp.salary)
        from employees emp, jobs j
        where emp.job_id = j.job_id
        group by emp.job_id
        having emp.job_id = c1.job_id)) as "Cerinta 2+3"
from cerinta1 c1;

--VARIANTA 2 (la cerinta 2 -> jobul avand salariul maxim = jobul care are
--            suma salariilor cea mai mare dintre joburile al caror cod
--            incepe cu litera S)

with cerinta1 as (select job_id, sum(salary) as sumSal, count(*) as nrAng
                from employees
                join jobs using (job_id)
                group by job_id
                having job_id like 'S%'),
     cerinta2 as (select max(cer1.sumSal) as maxSal
                  from employees e, (select job_id, sum(salary) as sumSal, count(*) as nrAng
                                     from employees
                                     join jobs using (job_id)
                                     group by job_id
                                     having job_id like 'S%') cer1
                 where e.job_id = cer1.job_id)
select c1.sumSal,
decode(c1.job_id, (select c.job_id
                   from cerinta1 c, employees e
                   where c.job_id = e.job_id
                   group by c.job_id
                   having sum(salary) = (select maxSal
                                         from cerinta2)), (c1.sumSal / c1.nrAng),
       (select min(emp.salary)
        from employees emp, jobs j
        where emp.job_id = j.job_id
        group by emp.job_id
        having emp.job_id = c1.job_id)) as "Cerinta 2+3"
from cerinta1 c1;