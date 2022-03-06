--10
select last_name, salary, department_id, max_sal
from employees e
join viz_dept_sum_av v on (v.cod_dept = e.department_id);

--11
create or replace view viz_sal_av(Nume, NumeDept, Sal, Oras) as
select last_name, department_name, salary, city
from employees
join departments using (department_id)
join locations using (location_id);

select * from USER_UPDATABLE_COLUMNS 
where table_name = 'VIZ_SAL_AV';
--Coloanele actualizabile sunt Nume si Salariu

--12
--b
alter view viz_emp_s_av
add constraint pk_viz_emp_s_av primary key (employee_id) disable novalidate;
