UPDATE employees SET salary = 
    ( SELECT AVG(salary) FROM employees);
    
UPDATE employees 
SET salary = ( SELECT AVG(salary) FROM employees)
WHERE (hire_date, department_id) IN 
        (SELECT MIN(hire_date), department_id
        FROM employees 
        GROUP BY department_id);
        
SELECT s_id, s_last, s_address
FROM student
WHERE s_id = '&p_cod';

DEFINE p_cod;
SELECT s_id, s_last, s_address
FROM student
WHERE s_id = '&p_cod';
UNDEFINE p_cod;

DEFINE p_cod = 'JO100';
SELECT s_id, s_last, s_address
FROM student
WHERE s_id = '&p_cod';
UNDEFINE p_cod;

ACCEPT p_cod PROMPT "cod = ";
SELECT s_id, s_last, s_address
FROM student
WHERE s_id = '&p_cod';


-- 18
SELECT s_id, s_last, s_address, s_class
FROM student
WHERE s_class = '&id_class';

-- 19
ACCEPT vdate date format 'yyyy-mm-dd' PROMPT 'date= ';
SELECT s_id, s_last, s_address, s_dob
FROM student
WHERE s_dob > TO_DATE('&vdate', 'yyyy-mm-dd');

-- 20
SELECT &&p_coloana  
FROM     &p_tabel
WHERE    &p_where
ORDER BY &p_coloana;

-- 21
ACCEPT min_date date format 'mm/dd/yy' PROMPT 'min_date= ';
ACCEPT max_date date format 'mm/dd/yy' PROMPT 'max_date= ';
SELECT s_first || s_last || s_dob "min student"
FROM student
WHERE s_dob BETWEEN TO_DATE('&min_date', 'mm/dd/yy') AND TO_DATE('&max_date', 'mm/dd/yy');

-- 22
SELECT s_first || s_last || s_dob "min student"
FROM student
WHERE LOWER(s_city) = LOWER('&city');

SELECT 'INSERT INTO tabel VALUES(' || col1 || col2 || ');'
FROM tabel2;