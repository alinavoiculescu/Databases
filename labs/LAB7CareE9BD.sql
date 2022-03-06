SELECT DISTINCT employee_id 
FROM works_on a 
WHERE NOT EXISTS (SELECT 1 
                    FROM project p 
                    WHERE budget=10000 
                    AND NOT EXISTS (SELECT 'x'
                                    FROM works_on b 
                                    WHERE p.project_id=b.project_id 
                                    AND b.employee_id=a.employee_id));
                                    
SELECT employee_id 
FROM works_on 
WHERE project_id IN (   SELECT project_id 
                        FROM project 
                        WHERE budget=10000) 
GROUP BY employee_id 
HAVING COUNT(project_id)= (SELECT COUNT(*) 
                            FROM project 
                            WHERE budget=10000);
                            
                            
SELECT employee_id 
FROM works_on 
MINUS 
SELECT employee_id from (SELECT employee_id, project_id 
                        FROM (SELECT DISTINCT employee_id FROM works_on) t1, 
                            (SELECT project_id FROM project WHERE budget=10000) t2 
                        MINUS 
                        SELECT employee_id, project_id FROM works_on ) t3;
    

                        
SELECT DISTINCT employee_id 
FROM works_on a 
WHERE NOT EXISTS ( (SELECT project_id 
                    FROM project p 
                    WHERE budget=10000) 
                    MINUS 
                    (SELECT p.project_id 
                        FROM project p, works_on b 
                        WHERE p.project_id=b.project_id 
                        AND b.employee_id=a.employee_id));                        
                        
--1
-- metoda 1

select distinct employee_id, last_name
from employees e
where not exists
                (select 1
                from project p
                where to_char(start_date, 'yyyy') = 2006
                and to_char(start_date, 'mm') <= 6
                and not exists
                    (select 'x'
                    from works_on b
                    where b.project_id = p.project_id
                    and b.employee_id = e.employee_id)
                );
                
--met 2

SELECT employee_id 
FROM works_on 
WHERE project_id IN (SELECT project_id 
                    FROM project
                    where to_char(start_date, 'yyyy') = 2006
                    and to_char(start_date, 'mm') <= 6)
GROUP BY employee_id 
HAVING COUNT(project_id) = (SELECT COUNT(*) 
                            FROM project                    
                             where to_char(start_date, 'yyyy') = 2006
                            and to_char(start_date, 'mm') <= 6);
                            
--met 3

SELECT employee_id
FROM works_on 
MINUS 
SELECT employee_id from (SELECT employee_id, project_id 
                        FROM (SELECT DISTINCT employee_id FROM works_on) t1,
                        (SELECT project_id FROM project
                        where to_char(start_date, 'yyyy') = 2006
                        and to_char(start_date, 'mm') <= 6) t2
                        minus
                        SELECT employee_id, project_id FROM works_on ) t3;
                        
--met 4

SELECT DISTINCT employee_id 
FROM works_on a 
WHERE NOT EXISTS (SELECT project_id FROM project
                    where to_char(start_date, 'yyyy') = 2006
                    and to_char(start_date, 'mm') <= 6
                    minus 
                    (SELECT p.project_id 
                    FROM project p, works_on b 
                    WHERE p.project_id=b.project_id 
                    AND b.employee_id=a.employee_id)
                    );


--2
--met 1
select *
from project p
where not exists
(
    select 1
    from employees e
    where employee_id in
                        (select employee_id
                        from job_history
                        group by employee_id
                        having count(job_id) = 2)
    
    and not exists(
                    select 'x'
                    from works_on b
                    where b.project_id = p.project_id
                    and b.employee_id = e.employee_id
                    )
);

-- met 2

select project_id, project_name
from project join works_on using(project_id)
where employee_id in (select employee_id
                        from job_history
                        group by employee_id
                        having count(job_id) = 2)
group by project_id, project_name
having count(employee_id) = (select count(count(*))
                            from job_history
                             group by employee_id
                            having count(job_id) = 2);

--ex 3 
select count(*)
from employees e
where (select count(job_id)
        from (select employee_id, job_id
                from job_history
                union
                select employee_id, job_id
                from employees)
        where employee_id = e.employee_id) >=3;


--ex 4 tema

--5
select project_id
from project
where nvl(delivery_date, sysdate) > deadline;

select e.employee_id, e.last_name
from employees e 
join works_on w on (e.employee_id = w.employee_id)
join project p on (w.project_id = p.project_id)
where nvl(delivery_date, sysdate) > deadline
group by e.employee_id, e.last_name
having count(w.project_id) >1;

--ex 6 tema
--7

with manageri as (select project_manager from project),
dep_manageri as (select department_id from employees
                where employee_id in (select * from manageri))
select *
from employees
where department_id in (select * from dep_manageri );

--8
with manageri as (select project_manager from project),
dep_manageri as (select department_id from employees
                where employee_id in (select * from manageri))
select *
from employees e
where not exists(
                select * 
                from dep_manageri
                where e.department_id = department_id);
--10

select first_name, last_name, salary, count(p.project_id)
from employees e
join project p on (p.project_manager = e.employee_id)
where (select count(*) from project 
        where project_manager = e.employee_id) = 2
group by first_name, last_name, salary;


select first_name, last_name, salary, count(p.project_id)
from employees e
join project p on (p.project_manager = e.employee_id)
group by first_name, last_name, salary
having count(p.project_id) = 2;

--11 data viitoare

--12
--a

with project_200 as (select project_id
                        from works_on
                        where employee_id = 200)
select last_name
from employees e
where not exists(
    select project_id
    from project_200
    minus
    select project_id
    from works_on w
    where w.employee_id = e.employee_id);
    
 --b
 with project_200 as (select project_id
                        from works_on
                        where employee_id = 200)
select last_name
from employees e
where not exists(
    select project_id
    from works_on w
    where w.employee_id = e.employee_id
    minus 
    select project_id
    from project_200);

--13
 with project_200 as (select project_id
                        from works_on
                        where employee_id = 200)
select last_name
from employees e
where not exists(
    select project_id
    from works_on w
    where w.employee_id = e.employee_id
    minus 
    select project_id
    from project_200)
and not exists(
    select project_id
    from project_200
    minus
    select project_id
    from works_on w
    where w.employee_id = e.employee_id);


--14
select * from job_grades;

describe job_grades;

select first_name, last_name, salary, grade_level
from employees e, job_grades 
where salary between lowest_sal and highest_sal;

--15
update employees e
set salary = (select salary
                from employees
                where employee_id = (select manager_id
                                        from employees
                                        where employee_id = e.employee_id))
where e.employee_id = (select employee_id
from employees 
where salary = (select min(salary)
                from employees));

select * from employees order by salary; -- 132 2100 121 8200

rollback;

--16
update employees e
set email = (select substr(nvl(last_name, '.'), 1,1) || first_name
            from employees
            where employee_id = e.employee_id)
where (e.department_id, e.salary) in (select department_id, max(salary)
                                        from employees
                                        group by department_id);

rollback;
select * from employees;











