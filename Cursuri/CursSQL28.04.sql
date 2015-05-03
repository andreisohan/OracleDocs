create table TAB1_tema1 (
TAB1_ID number primary key,
nume varchar(20) not null,
prioritate number);

create table TAB2_tema2 (
TAB2_ID number primary key,
nume_detaliu varchar(20) not null);

alter table TAB2_tema2
add (TAB1_ID number);

alter table TAB2_tema2
add constraint f_key foreign key (TAB1_tema1) references TAB1_tema1 (TAB1_ID);

select last_name||' '||first_name nume, email, salary,
       (select job_title from jobs where job_id = employees.job_id) post
        from employees
        where DEPARTMENT_ID = (select DEPARTMENT_ID
                                        from departments
                                        where department_name = 'Purchasing');
                                        
select last_name||' '||first_name nume, email, salary,
       (select job_title from jobs where job_id = employees.job_id) post
        from employees
        where DEPARTMENT_ID IN (select DEPARTMENT_ID
                                        from departments
                                        where department_name like 'A%');      
										
--Pentru a afisa salariatii care castiga mai mult decat salariul cel mai scazut din departamentul 30, se introduce:
 SELECT FIRST_NAME, SALARY, JOB_ID, DEPARTMENT_ID
		FROM EMPLOYEES
		WHERE SALARY > /*ANY--*/SOME
				(SELECT DISTINCT SALARY
					 FROM EMPLOYEES
					 WHERE DEPARTMENT_ID = 30)
		ORDER BY SALARY DESC; 
		
--ALL compara o valoare  cu fiecare valoare returnata de o subinterogare. Urmatoarea interogare gaseste salariatii care castiga mai mult decat orice salariat din Departamentul 30.
	SQL> SELECT FIRST_NAME, SALARY, JOB_ID, DEPARTMENT_ID
		FROM EMPLOYEES
		WHERE	SALARY > ALL
				(SELECT DISTINCT SALARY
				 FROM EMPLOYEES
				 WHERE DEPARTMENT_ID = 30)
		ORDER BY SALARY DESC;
    
select last_name, hire_date 
from employees 
where department_id = (select department_id from employees where last_name='Zlotkey') and last_name!='Zlotkey';
		
select employee_id,last_name 
from employees 
where department_id in (select department_id from employees where last_name like ('%u%'));    

select last_name, job_title, salary 
from employees, jobs
where employees.job_id = jobs.job_id 
and salary in (select salary from employees where salary not in (2500,3500,7000)) 
and job_title in (select job_title from jobs where job_title like ('P%'))
order by job_title asc,last_name desc;

select last_name,job_id,department_id, salary 
from employees 
where salary> any(select salary from employees where department_id=30);

-- DML

INSERT INTO EMP_TEST (ID, NUME, HIRE_DATE) 
VALUES ( 1, 'BUBU Mihai', add_months(trunc(sysdate,'MM')-4,-48));

INSERT INTO EMP_TEST (ID, NUME, SALARY, HIRE_DATE) 
select employee_id, first_name||' '||last_name, salary, hire_date
from employees
where employee_id between 101 and 107;

commit;

update EMP_TEST
set salary = 10000
where salary is null;


delete emp_test
where HIRE_DATE = add_months(trunc(sysdate,'MM')-4,-48); 


merge into EMP_TEST et
using (select employee_id, first_name||' '||last_name emp_nume, salary, hire_date, department_id
            from employees) e
on (et.id = e.employee_id)
WHEN MATCHED THEN
	UPDATE SET
    et.nume = e.emp_nume,
    et.salary = e.salary,
    et.hire_date = e.hire_date,
    et.dep_id = e.department_id
WHEN NOT MATCHED THEN
	INSERT (ID, NUME, SALARY, HIRE_DATE, DEP_ID)
    VALUES (e.employee_id, e.emp_nume, e.salary, e.hire_date, e.department_id);   
    
commit;

insert into employees (employee_id, first_name, last_name, hire_date, email, job_id, salary, commission_pct) 
values(1000+(select max(employee_id) from employees), 'Andrei', 'Sohan', sysdate, 'TNI@gmail.com','AD_PRES',10000,0.2);

commit

update employees
set  department_id=(select department_id from departments where department_name='IT Support')
where first_name='Andrei' and last_name='Sohan';

commit

select avg(salary)*12 from employees;
update employees
set salary = salary+ salary*commission_pct
where first_name = 'Andrei' and last_name='Sohan';
commit
select avg(salary)*12 from employees;

-- controlul tranzactiilor

delete emp_test
where id not between 100 and 110;

savepoint a;

INSERT INTO EMP_TEST (ID, NUME, HIRE_DATE) 
VALUES ( 1, 'BUBU Mihai', add_months(trunc(sysdate,'MM')-4,-48));

update EMP_TEST
set salary = 10000
where salary is null;

savepoint b;

INSERT INTO EMP_TEST (ID, NUME, HIRE_DATE) 
VALUES ( 2, 'Test Test', add_months(trunc(sysdate,'MM')-4,-48));

rollback to savepoint b;

rollback to savepoint a;

rollback;

-- alte obiecte

create view dep2_test as
select department_id, department_name
from departments;

drop view dep2_test;

CREATE SEQUENCE test_SQ
  START WITH 1
  MAXVALUE 999999999999999999999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER;
  
select test_SQ.NEXTVAL
        from dual;   
  
select test_SQ.CURRVAL
        from dual;
        
ALTER SEQUENCE test_SQ
  MAXVALUE 999999999
  MINVALUE 1
  NOCYCLE
  NOCACHE
  NOORDER; 
  
create index epm_idx on emp_TEST (dep_id);  

create synonym emp for employees;

select *
        from emp;
        
drop synonym emp;

create or replace view V_SALARIATI 
as (select e.Employee_id, e.first_name, e.last_name, e.job_id, j.job_title, e.department_id,d.department_name,e.salary, e.commission_pct
from employees e,departments d,jobs j where e.department_id=d.department_id(+) and e.job_id=j.job_id );

create view V_SALARIATI_FINANCE 
as(select * from employees where department_id=100)
with check option;

insert into V_SALARIATI_FINANCE values (1142312,'Andrei','Andrei','email@email.com','2325678901',sysdate, 'FI_MGR',10000,0.2,101,100);

create sequence emp_sequence 
start with 10
increment by 10
maxvalue 1000
cache 100;

select emp_sequence.nextval from dual;

insert into employees (employee_id, first_name, last_name, hire_date, email, job_id, salary, commission_pct) 
value (semp_sequence.nextval, 'Andrei', 'Sohan', sysdate, 'TNI@gmail.com','AD_PRES',10000,0.2);

select * from ZTH_29.employees where employee_id=10;
update employees 
set last_name = '123'
where employee_id=10;

commit


