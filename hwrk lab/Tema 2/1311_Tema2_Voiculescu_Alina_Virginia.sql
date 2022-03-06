--I
---1
select count(employee_id) as Angajati
from employees
where last_name like 'K%';

---2
select employee_id, last_name, first_name
from employees
where salary = (select min(salary)
                from employees);

---3
select employee_id, last_name
from employees
where employee_id in (select distinct manager_id
                      from employees
                      where department_id = 30)
order by 2;

---4
select e1.employee_id as "Cod", e1.last_name "Nume", e1.first_name "Prenume",
count(e2.employee_id) "Numar subalterni"
from employees e1, employees e2
where e1.employee_id = e2.manager_id
and e1.employee_id in (select distinct manager_id
                        from employees)
group by e2.manager_id, e1.employee_id, e1.last_name, e1.first_name
order by e1.employee_id;

---5
select employee_id, last_name, first_name
from employees e1
where last_name in (select last_name
                    from employees
                    where e1.employee_id != employee_id);
                    
---6
select d.department_id, d.department_name
from departments d
where 2 <= (select count(distinct job_id)
          from employees
          where department_id = d.department_id) 
group by d.department_id, d.department_name
order by 1;



--II
---7
select sum(qty)
from orders_tbl
where prod_id in (select prod_id
                from products_tbl
                where lower(prod_desc) like '%plastic%')
group by prod_id;

---8
select cust_name as "Nume", nvl2(cust_id, 'Client', '0') as "Tip"
from customer_tbl
union all
select last_name || ' ' || first_name, nvl2(emp_id, 'Angajat', '0')
from employee_tbl;

---9
select distinct p.prod_desc
from orders_tbl o, products_tbl p
where o.prod_id = p.prod_id
and o.sales_rep in ( select o1.sales_rep
                    from orders_tbl o1, products_tbl p1
                    where o1.prod_id = p1.prod_id
                    and length(p1.prod_desc) - length(replace(p1.prod_desc, ' ', '')) + 1 >= 2
                    and upper(p1.prod_desc) like '% P%'
                    group by o1.sales_rep
                    having count(*) = 1);


---10
select c.cust_name
from customer_tbl c, orders_tbl o
where c.cust_id = o.cust_id
and o.ord_date like '17%';

---11
--Metoda 1
select e1.last_name, e1.first_name, nvl(e2.salary, 0) as Salary , nvl(e2.bonus,0) as Bonus
from employee_tbl e1, employee_pay_tbl e2
where e1.emp_id = e2.emp_id
and greatest(nvl(e2.salary, 0), nvl(e2.bonus, 0)*17) < 32000;

--Metoda 2
select e1.last_name, e1.first_name, nvl(e2.salary, 0) as Salary , nvl(e2.bonus,0) as Bonus
from employee_tbl e1, employee_pay_tbl e2
where e1.emp_id = e2.emp_id
and (case
    when nvl(e2.salary, 0) > (nvl(e2.bonus, 0)*17) then nvl(e2.salary, 0)
    else nvl(e2.bonus, 0)*17
    end) < 32000;

---12
select e.last_name, nvl(sum(o.qty), 0) as QTY
from employee_tbl e, orders_tbl o
where e.emp_id = o.sales_rep(+)
group by e.last_name
having (sum(o.qty) > 50 or nvl(sum(o.qty), 0) = 0);

---13
select e1.last_name, e1.first_name, e2.salary, max(o.ord_date) as "LAST ORD_DATE"
from orders_tbl o, employee_tbl e1, employee_pay_tbl e2
where e1.emp_id = o.sales_rep
and e1.emp_id = e2.emp_id
group by e1.last_name, e1.first_name, e2.salary
having (count(o.ord_num) >= 2);

---14
select prod_desc
from products_tbl
where cost > (select avg(cost)
              from products_tbl);
              
---15
select e1.last_name, e1.first_name, nvl(e2.salary,0) as Salariu, nvl(e2.bonus,0) as Bonus,
nvl(salary,0)*round((sysdate - date_hire)/12) as "Salariu total",
nvl(bonus,0)*round((sysdate - date_hire)/12) as "Bonus total"
from employee_tbl e1, employee_pay_tbl e2
where e1.emp_id = e2.emp_id;

---16
select e.city
from orders_tbl o, employee_tbl e
where e.emp_id = o.sales_rep
group by e.city
having (count(o.ord_num) = (select max(count(ord_num))
                            from orders_tbl
                            group by sales_rep));

---17
select distinct e.emp_id, e.last_name, e.first_name,
max(nvl(decode(to_char(ord_date, 'MON'),
'SEP', (select sum(qty)
        from orders_tbl
        where sales_rep = e.emp_id
        and ord_date like '%SEP%'
        group by emp_id)), 0)) "SEP",
max(nvl(decode(to_char(ord_date, 'MON'),
'OCT', (select sum(qty)
        from orders_tbl
        where sales_rep = e.emp_id
        and ord_date like '%OCT%'
        group by emp_id)), 0)) "OCT"
from employee_tbl e, orders_tbl o
where e.emp_id = o.sales_rep
group by e.emp_id, e.last_name, e.first_name;

---18
select cust_name, cust_city
from customer_tbl
where substr(to_char(cust_address), 1, 1) in ('0', '1', '2', '3', '4', '5', '6', '7', '8', '9')
and cust_id not in (select cust_id
                    from orders_tbl);
                    
---19
select distinct e.emp_id, e.last_name || ' ' || e.first_name as "EMP_NAME", e.city,
       c.cust_id, c.cust_name, c.cust_city
from employee_tbl e, customer_tbl c, orders_tbl o
where o.cust_id = c.cust_id
and o.sales_rep = e.emp_id
and c.cust_city != e.city;

---20
select avg(nvl(salary, 0)) as Media
from employee_pay_tbl;

---21
--A) Da, este corecta.
--B) Nu este corecta deoarece nu exista tabelul EMPLOYEE_ID. Daca ar fi inlocuit
-- cu EMPLOYEE_PAY_TBL, ar fi totul ok si corect.

---22
select e1.last_name, e2.pay_rate
from employee_tbl e1, employee_pay_tbl e2
where e1.emp_id = e2.emp_id
and e2.pay_rate > ALL (select e4.pay_rate
                       from employee_pay_tbl e4, employee_tbl e3
                       where e3.emp_id = e4.emp_id
                       and upper(e3.last_name) like '%LL%');