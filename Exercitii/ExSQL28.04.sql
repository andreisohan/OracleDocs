-----------------------------Exercitii SQL 28.04.2015
--Subselecturile:
--EX1
select last_name, hire_date from employees
where department_id = 
(select department_id from employees where last_name='Zlotkey')
and last_name != 'Zlotkey';

--EX2
select employee_id, last_name from employees
where department_id in
(select department_id from employees where last_name like ('%u%'));

--EX3
select last_name, job_title, salary from employees e, jobs j 
where e.job_id=j.job_id and job_title like ('P%') and salary not in (2500,3500,700)
order by job_title asc, last_name desc;

--EX4
select last_name, job_id, department_id, salary
from employees
where salary> any(select salary from employees where department_id=30);







--Alte obiecte din baza de date:
--VIEW-uri
--EX1
create or replace view V_SALARIATI
as (select e.employee_id, e.first_name, e.last_name, e.job_id, j.job_title, e.department_id, d.department_name, e.salary, e.commission_pct
from employees e, jobs j, departments d
where e.job_id=j.job_id and e.department_id=d.department_id(+));

--EX2
create or replace view V_SALARIATI_FINANCE
as (select * from employees where department_id=100)
with check option;

insert into V_SALARIATI_FINANCE
values (1142312,'Andrei','Andrei','email@email.com','2325678901',sysdate, 'FI_MGR',10000,0.2,101,200);

--SECVENTE
--EX1
create sequence emp_sequence
start with 10
increment by 10
maxvalue 1000
cache 100;

--EX2
insert into employees (employee_id, first_name, last_name, hire_date, email, job_id, salary, commission_pct)
values (emp_sequence.nextval, 'Andrei', 'Sohan', sysdate, 'TNI@gmail.com','AD_PRES',10000,0.2);

--EX3
select emp_sequence.currval, emp_sequence.nextval from dual;








--Manipularea datelor (DML):
--EX1
insert into employees (employee_id, first_name, last_name, hire_date, email, job_id, salary, commission_pct)
values (1000+(select max(employee_id)from employees), 'Andrei', 'Sohan', sysdate, 'TNI@gmail.com','AD_PRES',10000,0.2);

--EX2 ??!!
update employees 
set department_id = (select department_id from departments where department_name = 'IT Support')
where first_name= 'Andrei' and last_name='Sohan';

--EX3
select avg(salary)*12 from employees 
where department_id = (select department_id from departments where department_name='IT Support');

update employees
set salary = salary + salary*commission_pct
where first_name='Andrei' and last_name='Sohan';








--Controlul tranzactiilor
--EX 1-11
create table employees_test (
employee_id number,
first_name varchar2(20),
last_name varchar2(25)
);

insert into employees_test (employee_id, first_name, last_name)
values (1,'Andrei','Sohan');

savepoint a;

insert into employees_test (employee_id, first_name, last_name)
values (2,'Catalin','Marius');

savepoint b;

insert into employees_test (employee_id, first_name, last_name)
values (3,'George','Alex');

savepoint c;

rollback to b;

commit;

select * from employees_test;








--Operatii cu seturi de date
--EX1
select * from employees
minus
select * from employees where first_name like ('S%');

--EX2
create table employees30
as (select * from employees where department_id=30);

--EX3
select first_name, salary, hire_date, department_id from employees
intersect
select first_name, salary, hire_date, department_id from employees30;

--EX4
select first_name, salary, hire_date, department_id from employees
union all
select first_name, salary, hire_date, department_id from employees30;

--EX5
select first_name, salary, hire_date, department_id from employees
union
select first_name, salary, hire_date, department_id from employees30;

























