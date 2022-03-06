--EX 3
select e.last_name, e.salary, j.job_title, l.city,
 c.country_name
from employees e, employees m, jobs j, departments d,
locations l, countries c
where e.manager_id = m.employee_id and e.job_id = j.job_id and
e.department_id(+) = d.department_id and l.location_id(+) = d.location_id and
c.country_id(+) = l.country_id and m.last_name = 'King';





--EX 16
select first_name, hire_date, salary,
decode(to_char (hire_date, 'yyyy'),
1989, salary * 1.20,
1990, salary * 1.15,
1991, salary * 1.10,
salary) Marire
from employees;

select first_name, hire_date, salary,
case to_char (hire_date, 'yyyy')
    when '1989' then salary * 1.20
    when '1990' then salary * 1.15
    when '1991' then salary * 1.10
    else salary
end Marire
from employees;

select first_name, hire_date, salary,
case
    when to_char (hire_date, 'yyyy') = '1989' then salary * 1.20
    when to_char (hire_date, 'yyyy') = '1990' then salary * 1.15
    when to_char (hire_date, 'yyyy') = '1991' then salary * 1.10
    else salary
end Marire
from employees;