--1
--a
SELECT last_name, salary, department_id 
FROM employees e 
WHERE salary > (SELECT AVG(salary) 
                FROM employees 
                WHERE department_id = e.department_id);
                
--b
-- from

SELECT last_name, salary, e.department_id, a.department_name, a.avg_sal, a.nr_ang
FROM employees e, (select department_id, department_name, avg(salary) avg_sal, count(*) nr_ang
                    from employees 
                    join departments using(department_id)
                    group by department_id, department_name) a
where e.department_id = a.department_id
and salary > (SELECT AVG(salary) 
                FROM employees 
                WHERE department_id = e.department_id);
                
-- select
SELECT last_name, salary, department_id, 
(select department_name
from departments
where department_id = e.department_id) nume_dept,
(select avg(salary)
from employees
where department_id = e.department_id) avg_sal,
(select count(*)
from employees
where department_id = e.department_id) nr_ang
                    
FROM employees e 
WHERE salary > (SELECT AVG(salary) 
                FROM employees 
                WHERE department_id = e.department_id);
                
--2
-- all

SELECT last_name, salary, department_id 
FROM employees e 
WHERE salary > all (SELECT AVG(salary) 
                    FROM employees 
                    group by department_id );
                    
                    
--max
SELECT last_name, salary, department_id 
FROM employees e 
WHERE salary > (SELECT max(AVG(salary)) 
                FROM employees 
                 group by department_id);
                 
                 
--3
--sync
SELECT last_name, salary, department_id 
FROM employees e 
WHERE salary = (select min(salary)
                FROM employees 
                WHERE department_id = e.department_id);
                
                
-- nu e sync              
SELECT last_name, salary, department_id 
FROM employees e 
WHERE  (department_id, salary) in (select department_id, min(salary)
                                    from employees
                                    group by department_id);      
                
--from
--tema

--4
--tema

--5
SELECT last_name, salary 
FROM employees e 
WHERE EXISTS (SELECT 1 
                FROM employees 
                WHERE e.department_id = department_id 
                AND salary = (SELECT MAX(salary) 
                                FROM employees
                                WHERE department_id =30));
                                
--7
select employee_id, last_name, first_name
from employees e
where ( select count(*)
        from employees
        where manager_id = e.employee_id) >= 2;
        
--8
-- exists

select l.city
from locations l
where exists( select 1
                from departments
                where location_id = l.location_id);
                
--in
select l.city
from locations l
where location_id in (select location_id
                        from departments);
                        
--9
--not exists

select department_name
from departments d
where not exists (
                    select 1
                    from employees
                    where department_id = d.department_id);
-- not in
--tema



--10
WITH val_dep AS (select department_name, sum(salary) total
                    from employees 
                    join departments using(department_id)
                    group by department_name), 
val_medie AS (select avg(total) medie
                from val_dep) 
SELECT * 
FROM val_dep 
WHERE total > (SELECT medie 
                FROM val_medie) 
ORDER BY department_name;

--11

with steven_id as (select employee_id
                    from employees
                    where lower(first_name) = 'steven'
                    and lower(last_name) = 'king'),
subordonati_steven as (select * 
                        from employees
                        where manager_id = (select employee_id
                                            from steven_id)),
vechime as (select min(hire_date) vechime_max
            from subordonati_steven)
select employee_id, first_name || last_name, job_id, hire_date
from employees
where manager_id = (select employee_id
                    from subordonati_steven, vechime
                    where hire_date = vechime_max);


--12
select last_name, salary
from (select last_name, salary
        from employees
        order by salary desc)
where rownum <= 10;

-- connect by 

--13
select job_title
from (select job_title 
        from jobs j
        order by (select avg(salary)
                    from employees
                    where job_id = j.job_id ) asc)
where rownum <=3;


with medie_job as (select job_id, avg(salary) medie
                    from employees
                    group by job_id
                    order by medie asc)
select job_title
from jobs
join medie_job using(job_id)
where rownum <=3;


with medie_job as (select job_id, avg(salary) medie
                    from employees
                    group by job_id
                    )
select job_title
from (select job_title 
        from jobs
        join medie_job using(job_id)
        order by medie asc)
where rownum <=3;


-- 6
select last_name, salary
from employees
where rownum < 4
order by salary desc;


select last_name, salary
from employees e
where (select count(*)
        from employees
        where salary > e.salary) <=2;
        
   
select last_name, salary
from employees e
where (select count(distinct salary)
        from employees
        where salary > e.salary) <=2;     

--14 tema

                        
            

                