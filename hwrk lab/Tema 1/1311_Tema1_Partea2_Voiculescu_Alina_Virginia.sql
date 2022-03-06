--1
select cust_id, cust_name
from customer_tbl
where cust_state in ('IN', 'OH', 'MI', 'IL')
and cust_name like 'A%' or cust_name like 'B%'
order by 2;

--2 a)
select prod_id, prod_desc, cost
from products_tbl
where cost between 1 and 12.50;

--2 b)
select prod_id, prod_desc, cost
from products_tbl
where cost < 1 or cost > 12.50;

--3
select lower(first_name) || '.' || lower(last_name) || '@ittech.com' as Email
from employee_tbl;

--4
select 'NAME = ' || last_name || ', ' || first_name as NAME,
'EMP_ID = ' || substr(emp_id, 1, 3) || '-' ||  substr(emp_id, 4, 2) ||
'-' || substr(emp_id, 6, 4) as EMP_ID,
'PHONE = ' || '(' || substr(phone, 1, 3) || ')' || substr(phone, 4, 3) || '-' ||
substr(phone, 7, 4) as PHONE
from employee_tbl;

--5
select emp_id, date_hire
from employee_pay_tbl;

--6
select e1.emp_id as Nume, e1.last_name, e1.first_name as Prenume,
e2.salary as Salariu, e2.bonus
from employee_tbl e1, employee_pay_tbl e2
where (e1.emp_id = e2.emp_id);

--7
select c.cust_name, o.ord_num, o.ord_date
from customer_tbl c, orders_tbl o
where (c.cust_id = o.cust_id)
and c.cust_state like 'I%';

--8
select o.ord_num, o.qty, e.last_name, e.first_name, e.city
from orders_tbl o, employee_tbl e
where (o.sales_rep = e.emp_id);

--9
select o.ord_num, o.qty, e.last_name, e.first_name, e.city
from orders_tbl o, employee_tbl e
where (o.sales_rep(+) = e.emp_id);

--10
select emp_id, last_name, first_name
from employee_tbl
where nvl(middle_name, '0') = '0';

--11
select (nvl(salary, 0) + nvl(bonus, 0)) * 12 as "Salariu anual"
from employee_pay_tbl;

--12 Varianta 1 (DECODE)
select e1.last_name || ' ' || e1.first_name as Name, e2.salary, e2.position,
decode(lower(e2.position),
'marketing', e2.salary*1.10,
'salesman', e2.salary*1.15,
e2.salary) "Salariu modificat"
from employee_tbl e1, employee_pay_tbl e2
where (e1.emp_id = e2.emp_id);

--12 Varianta 2 (CASE)
select e1.last_name || ' ' || e1.first_name as Name, e2.salary, e2.position,
case lower(e2.position)
    when 'marketing' then e2.salary*1.10
    when 'salesman' then e2.salary*1.15
    else e2.salary
end "Salariu modificat"
from employee_tbl e1, employee_pay_tbl e2
where (e1.emp_id = e2.emp_id);