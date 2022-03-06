--19
drop table angajati_avo;

create table angajati_avo
(cod_ang number(4),
nume varchar2(20) not null,
prenume varchar2(20) unique,
email varchar2(15) unique,
data_ang date default sysdate,
job varchar2(15),
cod_sef number(4) constraint fk_cod_sef_avo references angajati_avo(cod_ang),
salariu number(8,2) not null,
cod_dep number(2),
comision number(2,2),
constraint pk_ang_avo primary key(cod_ang),
constraint ck_dept_avo check(cod_dep > 0),
constraint u_nume_prenume unique(nume, prenume),
constraint ck_salariu_comision_avo check (salariu > comision*100),
constraint fk_cod_dept_prof foreign key(cod_dep)
references departamente_avo(cod_dep)
);

--24
alter table angajati_avo
modify (email not null);