-------------------- PLSQL 29.04.2015 TOAD!!
--------------------------- Ex1
set serveroutput on
<<outerBlock>>
declare
v_outer varchar2(50):='dog';
begin
  declare
    v_inner varchar2(50):='cat';
    v_outer varchar2(50):='mouse';
  begin
    dbms_output.put_line('Value 1 :' ||v_inner);
    dbms_output.put_line('Value 2 :' ||v_outer);
    dbms_output.put_line('Value 3 :' ||outerBlock.v_outer);
  exception
    when others
    then
      null;
  end;
dbms_output.put_line('Value 4 :' ||v_outer);
exception
when others
then
  null;
end;


-------------------------------Ex2
declare
  employee_rec employees%rowtype;
begin
  select *
  into employee_rec
  from employees
  where employee_id=&a;
  dbms_output.put_line('ID:' || employee_rec.employee_id);
  dbms_output.put_line('First_name:' || employee_rec.first_name);
end;


-----------------------------EX3
declare
  v_procent number :=0.1;
  v_prag employees.salary%type:=&a;
begin
  update employees 
  set salary=salary+salary*v_procent
  where salary<v_prag;
end;
select * from employees where salary < 10000 and employee_id=198;


------------------------------EX4
declare
  type rec_locations is record 
  (adresa locations.city%type,
  codPostal locations.postal_code%type);
  
  v_locations rec_locations;
begin
  select city, postal_code
  into v_locations.adresa, v_locations.codPostal
  from locations
  where location_id=&p_id;
  dbms_output.put_line('Adresa:' || v_locations.adresa || chr(10)||'Cod postal'||v_locations.codPostal);
  
exception 
  when no_data_found
  then dbms_output.put_line('Nu exista locatia!');
end;


----------------------------EX5
declare
  jobid employees.job_id%type;
  empid employees.employee_id%type;
  sal_raise number (3,2);  
begin
/*  select job_id 
  into jobid
  from employees
  where employee_id=empid;*/
  
  if jobid='PU_CLERK'
    then sal_raise:=.09;
    elsif jobid='SH_CLERK' 
      then sal_raise:=0.8;
      elsif jobid='ST_CLERK'
        then sal_raise:=0.7;
        else sal_raise:=0;
  end if;
  dbms_output.put_line(sal_raise);
exception
  when no_data_found
  then null;
end;


---------------------------------EX6
declare
  grade char(1);
begin
  grade:='B';
  CASE grade
    when 'A' then
    dbms_output.put_line('excellent');
     when 'B' then
    dbms_output.put_line('very good');
     when 'C' then
    dbms_output.put_line('good');
     when 'D' then
    dbms_output.put_line('fair');
  ELSE dbms_output.put_line('No such grade');
  end case;
end;


-----------------------------EX7
declare
i number:=0;
begin
loop
  i:=i+1;
  dbms_output.put_line(to_char(i));
  exit when i=4;
end loop;
end;


-----------------------------EX8
begin
  for i in reverse 1..3 loop
  dbms_output.put_line(to_char(i));
  end loop;
end;


------------------------------EX9
declare 
  i number:=1;
begin
while i<=3 loop
dbms_output.put_line(i);
i:=i+1;
end loop;
end;


--------------------------------EX10
declare 
  cursor departments_curs
  is
    select dep.department_id, dep.department_name, dep.location_id
    from departments dep;
  
  departments_rec departments_curs%rowtype;
begin
  if departments_curs%isopen=false
    then open departments_curs;
  end if;
  
  loop
    fetch departments_curs into departments_rec;
    exit when departments_curs%notfound;
    dbms_output.put_line(departments_rec.department_id || ' '|| departments_rec.department_name);
  end loop;
  close departments_curs;
end;


--------------------------------EX11
declare 
  v_name varchar2(5);
begin
  begin
    v_name:='Justice';
    dbms_output.put_line(v_name);
  exception
    when value_error
    then
      dbms_output.put_line('Error in Inner block');
  end;
exception
  when value_error
  then
    dbms_output.put_line('Error in Outer block');
end;


-----------------------------EX12
declare
  invalid_loc exception;
begin
  update locations loc
  set loc.postal_code='678012'
  where loc.city like '&A';
  
  if sql%notfound
  then
    raise invalid_loc;
  end if;
exception
  when invalid_loc
  then raise_application_error (-20100,'Nu exista localitatea cu denumirea cautata');
end;


--------------------------------EX13
declare
  v_exp number;
  v_hike number (5,2);
begin
 -- select (trunc(sysdate)-trunc(hire_date)) /365
  select floor(months_between(sysdate, hire_date)/12 )
  into v_exp
  from employees
  where employee_id=115;
  if v_exp>10
    then v_hike:=1.20;
    elsif v_exp>5
      then v_hike:=1.10;
      else v_hike:=0.5;
  end if;
  
  update employees
  set salary=salary*v_hike
  where employee_id=115;
  DBMS_OUTPUT.PUT_LINE(v_exp);
end;
select * from employees where employee_id=115;


------------------------------EX14
declare
  v_max number;
  v_year number;
  i number:=0;
  v_nr number;
begin
  select max(count(*))
  into v_max
  from employees
  group by to_char(hire_date, 'yyyy');
  
  select extract(year from hire_date)
  into v_year
  from employees
  group by extract(year from hire_date)
  having count(1)=v_max;
  
  dbms_output.put_line(v_year);
  
  while i<=12
    loop
      select count(1)
      into v_nr
      from employees
      where extract(month from hire_date)=to_char(i) 
      and to_char(hire_date, 'yyyy')=to_char(v_year);
      dbms_output.put_line(v_nr);       
      i:=i+1;
    end loop;    
end;