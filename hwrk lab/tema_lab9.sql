--4
select country_name, count(employee_id) as Numar_Ang
from employees
join departments using(department_id)
join locations using(location_id)
join countries using(country_id)
group by country_name;

--6
select e.employee_id, nvl(to_char(project_id), 'No project') as id_proiecte
from employees e, works_on w
where e.employee_id = w.employee_id(+)
order by 1;