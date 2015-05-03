------------------------------Exercitii SQL 27.04.2015
--Creerea si managementul tabelelor + Constrangeri + Alte obiecte de baza de date
--EX1
create table TAB1_tema1 (
TAB1_ID number primary key,
nume varchar(20) not null,
prioritate number);

create table TAB2_tema2 (
TAB2_ID number primary key,
nume_detaliu varchar(20) not null);

--EX2
alter table TAB2_tema2
add (TAB1_ID number);

alter table TAB2_tema2
add constraint f_key foreign key (TAB1_ID) references TAB1_tema1 (TAB1_ID)
constraint unique_key UNIQUE (TAB1_ID);

--EX3
create sequence TAB_secventa_SQ
start with 1
increment by 1
;

--EX4!!!
insert into TAB1_tema1 (TAB1_ID, nume, prioritate)
values (TAB_secventa_SQ.nextval,'Dacia',1);
insert into TAB1_tema1 (TAB1_ID, nume, prioritate)
values (TAB_secventa_SQ.nextval, 'Honda', 2);
insert into TAB1_tema1 (TAB1_ID, nume, prioritate)
values(TAB_secventa_SQ.nextval, 'Audi', 3);

--EX5
insert into TAB2_tema2 (TAB2_ID, nume_detaliu, TAB1_ID)
values (TAB_secventa_SQ.nextval,'Logan', 1),(TAB_secventa_SQ.nextval, 'Sandero', 1),
(TAB_secventa_SQ.nextval, 'Accord', 2),(TAB_secventa_SQ.nextval, 'Civic', 2),
(TAB_secventa_SQ.nextval, 'TT', 3),(TAB_secventa_SQ.nextval, 'A4', 3);

--EX6
select nume_detaliu, nume 
from tab1_tema1 t1,tab2_tema2 t2 on t1.tab1_id=t2.tab1_id
order by prioritate;

--EX7
insert into tab1_tema1 (tab1_id, prioritate, nume)
values (1, 'error');

insert into tab2_tema2 (tab2_id, tab1_id, nume_detaliu)
values (1,30);









--Interogarea datelor
--EX1
select last_name, job_id, salary as sal from employees;

--Ex2
select * from jobs;

--EX3
select employee_id, last_name, salary*12 as salariu_anual from employees;

--EX4
select distinct department_id from employees;

--EX5
select first_name, job_id from employees
where AngajatulSiTitulatura like '%,%';







--Restrictionarea si sortarea datelor:
--EX1
select last_name, salary from employees
where salary > 14000;

--EX2
select last_name, salary from employees 
where salary between 2000 and 14000
order by salary desc;

--EX3
select last_name from employees
where department_id=50;

--EX4
select last_name, salary, commission_pct from employees
where commission_pct is not null
order by commission_pct;

--EX5
select last_name, job_id, salary from employees
where job_id in ('ST_CLERK', 'SA_REP') and salary not in (2500,3500,7000)
order by last_name desc;






--Functii single-row:
--EX1
select sysdate as Data_Curenta from dual;

--EX2
select last_name, salary, trunc(salary+(15/100)*salary) as newsal from employees;

--EX3
select upper(first_name),length(first_name),nvl(salary,0)*nvl(commission_pct,1) as SAL 
from employees
where substr(first_name, 1,1) in ('J','A','M');

--EX4
select last_name,months_between(sysdate,to_date('25-12-2002','dd-mm-rrrr' )) as vechime from employees
order by vechime desc;

--EX5
select last_name, LPAD(salary,10,'*') from employees
where commission_pct is not null and commission_pct<>0;

--EX6 
select job_id,decode(job_id,'AD_PRES','A','ST_MAN','B','IT_PROG','C','SA_REP','D','ST_CLERK','E',0 )as grade from employees; 










--Afisarea datelor din mai multe tabele:
--EX1
select first_name||' '||last_name as FullName, department_name, round(hire_date,'month') 
from employees e, departments d, locations l 
where e.department_id=d.department_id and d.location_id=l.location_id and d.department_name is not null and e.manager_id<>0;

--EX2 !!!???
select first_name, 
decode(manager_ID,null,'N/A',LAST_NAME) as nume_sef
--case manager_id
--when null then 'N/A' 
--else last_name 
--end 
from employees e1,  employees e2
where e1.manager_id=e1.employee_id;

--EX3
select*from employees cross join departments;








--Agregarea datelor folosind funtii de grup:
--EX1
select count(*)as num from employees;

--EX2
select department_id, count(*)as num from employees
group by department_id;

--EX3 ??!!
select avg(salary)as media, min(salary), max(salary), sum(salary), d.department_name ,count(department_name)
from employees e, departments d
where e.department_id=d.department_id
group by d.department_name
having d.department_name in ('Sales','Marketing','Human Resources','Public Relations');

--EX4
select job_title, count(*) from jobs
group by job_title;
