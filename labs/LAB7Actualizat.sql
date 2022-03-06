--1

select department_id, job_id, sum(salary)
from employees
group by department_id, job_id
order by department_id;


--2
select department_id,department_name, job_id, job_title, sum(salary)
from employees
join departments using(department_id)
join jobs using (job_id)
group by department_id,department_name, job_id, job_title
order by department_id;

--3
select department_name, min(salary)
from employees
join departments using(department_id)
group by department_name 
having avg(salary) = (select max(avg(salary)) 
                        from employees
                        group by department_id);
                        
--4
--a
select e.department_id, d.department_name, count(*)
from employees e, departments d
where e.department_id = d.department_id
group by e.department_id, d.department_name
having count(e.employee_id) < 4;

--b
select e.department_id, d.department_name, count(*)
from employees e, departments d
where e.department_id = d.department_id
group by e.department_id, d.department_name
having count(e.employee_id) = (select max(count(*))
                                from employees
                                group by department_id);
                                
--5
select employee_id, last_name, hire_date
from employees
where to_char(hire_date,'DD') in
(
    select to_char(hire_date,'DD')
    from employees
    group by to_char(hire_date,'DD')
    having count(*) = (select max(count(*))
                        from employees
                        group by to_char(hire_date,'DD'))
);


--6
--tema

--7
select department_id, sum(salary)
from employees
where department_id != 30
group by department_id
having count(*) > 10
order by department_id, sum(salary);


--8
select d.department_id, d.department_name, count(e2.employee_id), round(avg(e.salary)),
e2.last_name, e2.salary, e2.job_id
from departments d
right join employees e on (e.department_id = d.department_id)
right join employees e2 on (e2.department_id = d.department_id)
group by d.department_id, d.department_name, e2.last_name, e2.salary, e2.job_id
order by d.department_id;


select e.employee_id , e.department_id,e2.employee_id , e2.department_id
from departments d
join employees e on (e.department_id = d.department_id)
join employees e2 on (e2.department_id = d.department_id)
where e.employee_id != e2.employee_id
and e.department_id = e2.department_id
order by 1;


select e.department_id, count(*)
from departments d
join employees e on (e.department_id = d.department_id)
join employees e2 on (e2.department_id = d.department_id)
--where e.employee_id != e2.employee_id
where  e.department_id = e2.department_id
group by e.department_id
order by 1;



select d.department_id, d.department_name, count(e.employee_id), avg(e.salary),
e.last_name, e.salary, e.job_id
from departments d
left join employees e on (e.department_id = d.department_id)
group by d.department_id, d.department_name, e.last_name, e.salary, e.job_id
order by d.department_id;


select d.department_id, d.department_name,
(select count(employee_id) 
from employees 
where department_id = e.department_id) as EmployeeNr,
(select avg(salary)  
from employees 
where department_id = e.department_id) as AvgSalary,
e.last_name, e.salary, e.job_id
from employees e 
full outer join departments d on (e.department_id = d.department_id)
order by d.department_id;


--9
select d.department_id, l.city, d.department_name, e.job_id, nvl(sum(e.salary),0)
from departments d, locations l, employees e
where e.department_id(+) = d.department_id and
d.location_id = l.location_id(+)
and d.department_id > 80
group by d.department_id, d.department_name,l.city,e.job_id;

--10
select e.employee_id, e.last_name, count(j.job_id)
from employees e
join job_history j on (j.employee_id = e.employee_id)
group by e.employee_id, e.last_name
having count(j.job_id) >=2;

--11
SELECT AVG(NVL(commission_pct, 0)) FROM employees;

SELECT SUM(commission_pct)/COUNT(*) FROM employees;


--12
select job_title as Job, 
nvl(sum(decode(department_id, 30, salary)),0) as Dep30,
nvl(sum(decode(department_id, 50, salary)),0) as Dep50,
nvl(sum(decode(department_id, 80, salary)),0) as Dep80,
sum(salary)
from jobs
join employees using (job_id)
group by job_title;


select job_title as Job, 
nvl(sum(case department_id when 30 then salary end),0) as Dep30,
nvl(sum(case department_id when 50 then salary end),0) as Dep50,
nvl(sum(case department_id when 80 then salary end),0) as Dep80,
sum(salary) Total
from jobs
join employees using (job_id)
group by job_title;


--13
select count(employee_id),
count(decode(to_char(hire_date, 'YYYY'), 1997, employee_id)) as "1997",
count(decode(to_char(hire_date, 'YYYY'), 1998, employee_id)) as "1998",
count(decode(to_char(hire_date, 'YYYY'), 1999, employee_id)) as "1999",
count(decode(to_char(hire_date, 'YYYY'), 2000, employee_id)) as "2000"
from employees;

--14

SELECT d.department_id, department_name,a.suma 
FROM departments d, 
(SELECT department_id ,SUM(salary) suma 
    FROM employees 
    GROUP BY department_id) a 
WHERE d.department_id = a.department_id;

--15

select j.job_title, a.avgSal, (j.max_salary + j.min_salary)/2 - a.avgSal
from jobs j, 
(
    select e.job_id, avg(e.salary) as avgSal
    from employees e
    group by e.job_id
) a
where j.job_id = a.job_id;


--16
--tema

--17
select d.department_name, e.last_name, a.minSal
from departments d,  employees e, 
(
    select department_id, min(salary) as minSal
    from employees
    group by department_id
) a
where d.department_id = e.department_id 
and d.department_id =  a.department_id
and e.salary = a.minsal;








