--1
select to_char(s_id) as "Cod", s_last as "Student sau curs",
decode(to_char(s_id), s_id, 'Student') "Tip"
from student
where f_id = (select f_id
                from faculty
                where upper(f_last)= 'BROWN')
union
select to_char(c2.course_no), c1.course_name,
decode(to_char(c2.course_no), c2.course_no, 'Curs')
from course c1, course_section c2
where c1.course_no = c2.course_no
and c2.f_id = (select f_id
               from faculty
               where upper(f_last) = 'BROWN');

--2
select s_id, s_last, s_first
from student
where s_id in (select s_id
                 from enrollment
                 where c_sec_id in (select c_sec_id
                                      from course_section
                                      where course_no = (select distinct course_no
                                                         from course
                                                         where course_name = 'Database Management')))
and s_id not in (select s_id
                 from enrollment
                 where c_sec_id in (select c_sec_id
                                      from course_section
                                      where course_no = (select distinct course_no
                                                         from course
                                                         where course_name = 'Programming in C++')));
                                                    
--3
select s_id, s_last, s_first
from student
where s_id in (select distinct s_id
                 from enrollment
                 where nvl(grade, 'unknown') in ('C', 'unknown'));
                 
--4
select loc_id, bldg_code, capacity
from location
where capacity = (select max(capacity)
                  from location);

--5
CREATE TABLE t (id NUMBER PRIMARY KEY);
INSERT INTO t VALUES(1);
INSERT INTO t VALUES(2);
INSERT INTO t VALUES(4);
INSERT INTO t VALUES(6);
INSERT INTO t VALUES(8);
INSERT INTO t VALUES(9);

CREATE TABLE a (id NUMBER PRIMARY KEY);
INSERT INTO a VALUES(1);
INSERT INTO a VALUES(2);
INSERT INTO a VALUES(4);
INSERT INTO a VALUES(6);
INSERT INTO a VALUES(8);
INSERT INTO a VALUES(9);

select min(a.minim) as Minim, max(b.maxim) as Maxim
from (select id+1 Minim from t
      minus
      select id from t) a,
      (select id-1 Maxim from t
       minus
       select id from t) b;
       
--6
select f.f_id, f.f_last, f.f_first,
decode(nvl(student.nrs,0), 0, 'Nu',
       'Da(' || student.nrs || ')') as Student,
decode(nvl(curs.nrc,0), 0, 'Nu',
       'Da(' || curs.nrc || ')') as Curs
from faculty f, (select s.f_id, count(*) as nrs
                from student s
                group by s.f_id) student, (select f_id, count(*) as nrc
                                    from course_section
                                    group by f_id) curs
where f.f_id = student.f_id(+)
and f.f_id = curs.f_id(+);

--7
select *
from (select distinct decode(substr(t.term_desc, 0, length(t.term_desc) - 1), a."desc", t.term_desc || ', ' || a.term_desc) as "Perechi"
      from term t, (select term_desc, substr(term_desc, 0, length(term_desc) - 1) as "desc"
                    from term) a
      where a.term_desc > t.term_desc) b
where b."Perechi" is not null;

--8
select distinct s.s_last as Nume, s.s_first as Prenume
from student s, enrollment e, course_section c
where s.s_id = e.s_id
and e.c_sec_id = c.c_sec_id
and substr(to_char(c.course_no), 5, 1) not in (select substr(to_char(c1.course_no), 5, 1)
                                               from student s1, enrollment e1, course_section c1
                                               where s1.s_id = e1.s_id
                                               and e1.c_sec_id = c1.c_sec_id
                                               and substr(to_char(c.course_no), 5, 1) != substr (to_char(c1.course_no), 5, 1))
and (substr(to_char(c.course_no), 1, 4) || substr(to_char(c.course_no), 6, length(c.course_no))) in (select substr(to_char(c2.course_no), 1, 4) || substr(to_char(c2.course_no), 6, length(c2.course_no))
                                                                                                    from student s2, enrollment e2, course_section c2
                                                                                                    where s2.s_id = e2.s_id
                                                                                                    and e2.c_sec_id = c2.c_sec_id
                                                                                                    and c2.course_no != c.course_no)
and (select count(c3.course_no)
     from student s3, enrollment e3, course_section c3
     where s3.s_id = e3.s_id
     and e3.c_sec_id = c3.c_sec_id
     and substr(to_char(c.course_no), 5, 1) != substr (to_char(c3.course_no), 5, 1)) > 2;

--9
select distinct c.course_no || ', ' || a.course_no as Perechi
from course_section c, (select term_id, course_no
                      from course_section) a
where c.course_no > a.course_no
and a.term_id = c.term_id;

--10
select c.c_sec_id, c.course_no, t.term_desc, c.max_enrl
from course_section c, term t
where c.term_id = t.term_id
and c.max_enrl < all (select max_enrl
                      from course_section
                      where loc_id = 1);
                      
--11
select distinct c1.course_name, c2.max_enrl
from course c1, course_section c2
where c1.course_no = c2.course_no 
and c2.max_enrl = (select min(max_enrl)
                   from course_section);

--12
select f.f_last, f.f_first, a.avgLoc
from faculty f, (select f_id, avg(max_enrl) as avgLoc
                 from course_section
                 group by f_id) a
where a.f_id = f.f_id;

--13
select f.f_last, f.f_first, a.nrs
from faculty f, (select f_id, count(*) as nrs
                 from student
                 group by f_id) a
where a.f_id = f.f_id
and a.nrs >= 3;

--14
select distinct c1.course_name, l.capacity, c2.loc_id
from course c1, location l, course_section c2
where c1.course_no = c2.course_no
and l.loc_id = c2.loc_id;

--15
select t.term_id, a.avgLoc
from term t, (select term_id, avg(max_enrl) as avgLoc
              from course_section
              group by term_id) a
where t.term_id = a.term_id
and term_desc like '%2007';