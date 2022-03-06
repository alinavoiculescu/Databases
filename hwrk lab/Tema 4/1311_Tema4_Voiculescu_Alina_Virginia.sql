--1
select s.s_last, s.s_first
from student s
join enrollment e on (s.s_id = e.s_id)
group by s.s_id, s.s_last, s.s_first
having count(grade) = (select count(nvl(grade, 0))
                       from student
                       join enrollment using(s_id)
                       where s_id = s.s_id
                       group by s_id);

--2
select bldg_code
from location l
group by bldg_code
having count(*) = (select count(distinct loc_id)
                  from location
                  join course_section using(loc_id)
                  where bldg_code = l.bldg_code
                  group by bldg_code);

--3
select distinct f.f_id, f_last, f_first
from faculty f
join student s on (f.f_id = s.f_id)
join enrollment e on (e.s_id = s.s_id)
join course_section c1 on (c1.f_id = f.f_id)
join course c2 on (c1.course_no = c2.course_no)
where grade = 'A'
and course_name = 'Database Management';

--4
select f_last, f_first
from faculty f
join course_section c on (f.f_id = c.f_id)
join location l on (c.loc_id = l.loc_id)
where max_enrl = (select max(max_enrl)
                  from course_section)
and capacity = (select max(capacity)
                from location);
                
--5
select f_last, f_first
from faculty f
join course_section c on (f.f_id = c.f_id)
join location l on (f.loc_id = l.loc_id)
where f.loc_id in (select loc_id
                   from location
                   where capacity = (select min(capacity)
                                     from location))
and c_sec_id in (select c_sec_id
                 from course_section c1
                 join location l1 on (c1.loc_id = l1.loc_id)
                 where max_enrl = (select min(max_enrl)
                                   from course_section
                                   where loc_id = (select loc_id
                                                   from location
                                                   where capacity = (select max(capacity)
                                                                     from location))));

--6
with avgTeresaTammy as (select decode(f_first,
                        'Teresa', (select avg(distinct capacity)
                                   from course_section
                                   join location using (loc_id)
                                   join faculty using (f_id)
                                   where f_first = 'Teresa' and f_last = 'Marx')) avgName
                        from faculty
                        union
                        select decode(s_first,
                        'Tammy',  (select avg(max_enrl)
                                   from enrollment
                                   join course_section using (c_sec_id)
                                   join location using (loc_id)
                                   join student using (s_id)
                                   where s_first = 'Tammy' and s_last = 'Jones')) avgName
                        from student)
select avg(avgName) "Media"
from avgTeresaTammy;

--7
with filtrare as (select distinct l.loc_id, bldg_code, capacity
                  from location l
                  join course_section c1 on (l.loc_id = c1.loc_id)
                  join course c2 on (c1.course_no = c2.course_no)
                  where course_name like '%Systems%')
select bldg_code, avg(capacity) "Media capacitatilor"
from filtrare
group by bldg_code;

--8
with filtrare as (select distinct l.loc_id, bldg_code, capacity
                  from location l
                  join course_section c1 on (l.loc_id = c1.loc_id)
                  join course c2 on (c1.course_no = c2.course_no)
                  where course_name like '%Systems%')
select avg(capacity) as "Media capacitatilor"
from filtrare;

--9
select distinct
case
    when exists (select course_no
                 from course
                 where course_name like '%Java%') then (select course_no
                                                        from course
                                                        where course_name like '%Java%')
    else course_no
end "ID_Curs",
case
    when exists (select course_name
                 from course
                 where course_name like '%Java%') then (select course_name
                                                        from course
                                                        where course_name like '%Java%')
    else course_name
end "Nume_Curs"
from course c;



--10
with decoding as (select course_name,
decode(capacity,
42, 1,
0
) Capacitate,
decode(f_id,
(select f_id
 from faculty
 where f_last = 'Brown'), 1,
 0) Profesor,
decode(s_id,
(select s_id
 from student
 where s_first = 'Tammy' and s_last = 'Jones'), 1,
 0) Student,
decode(course_name,
(select course_name
 from course
 where course_name like '%Database%'), 1,
 0) Curs,
decode(start_date,
(select start_date
 from term
 where start_date like '%2007%'), 1,
 0) Semestru
from course_section c1
join course c2 on (c1.course_no = c2.course_no)
join location l on (c1.loc_id = l.loc_id)
join enrollment e on (e.c_sec_id = c1.c_sec_id)
join term t on (t.term_id = c1.term_id))
select distinct course_name
from decoding
where capacitate + profesor + student + curs + semestru >= 3;

--11
select term_desc, count(*) "Numar cursuri DB"
from course_section
join term using (term_id)
join course using (course_no)
where course_name like '%Database%'
group by course_name, term_desc
having count(*) = (select max(count(*))
                   from course_section
                   join term using (term_id)
                   join course using (course_no)
                   where course_name like '%Database%'
                   group by course_name, term_desc);

--12
select grade, count(*) "Numar studenti"
from (select distinct s_id, grade
      from enrollment
      where grade is not null)
group by grade
having count(*) in (select max(count(*))
                    from (select distinct s_id, grade
                          from enrollment
                          where grade is not null)
                    group by grade);

--13
select * from course;
select '(' || term_desc || ', ' || count(*) || ' cursuri' || ')' "(Semestru, NrCursuri)"
from (select distinct term_desc, course_name
      from course c1
      join course_section c2 on (c1.course_no = c2.course_no)
      join term t on (t.term_id = c2.term_id)
      where credits = 3)
group by term_desc
having count(*) = (select max(count(*))
                  from (select distinct term_desc, course_name
                        from course c1
                        join course_section c2 on (c1.course_no = c2.course_no)
                        join term t on (t.term_id = c2.term_id)
                        where credits = 3)
                  group by term_desc);

--sau

select '(Semestrul ' || term_id || ', ' || count(*) || ' cursuri' || ')' "(Semestru, NrCursuri)"
from (select distinct t.term_id, course_name
      from course c1
      join course_section c2 on (c1.course_no = c2.course_no)
      join term t on (t.term_id = c2.term_id)
      where credits = 3)
group by term_id
having count(*) = (select max(count(*))
                  from (select distinct t.term_id, course_name
                        from course c1
                        join course_section c2 on (c1.course_no = c2.course_no)
                        join term t on (t.term_id = c2.term_id)
                        where credits = 3)
                  group by term_id);

--14
select distinct loc_id
from location
join course_section using (loc_id)
join course using (course_no)
where course_name like '%Database%'
and loc_id in (select distinct loc_id
              from location
              join course_section using (loc_id)
              join course using (course_no)
              where course_name like '%C++%');

--15
select bldg_code
from (select l.loc_id, bldg_code
      from location l
      join course_section c on (l.loc_id = c.loc_id)
      union
      select l.loc_id, bldg_code
      from location l
      join faculty f on (l.loc_id = f.loc_id))
group by bldg_code
having count(*) = 1;

--sau

select bldg_code
from (select loc_id, bldg_code
      from location
      minus
      (select l.loc_id, bldg_code
      from location l
      join course_section c on (l.loc_id = c.loc_id)
      union
      select l.loc_id, bldg_code
      from location l
      join faculty f on (l.loc_id = f.loc_id)))
group by bldg_code
having count(*) = 1;