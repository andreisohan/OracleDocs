-------------------------PL/SQL 30.04.2015
set serveroutput on
------------------------------EX1 functie
create or replace function verificare_cnp (p_cnp in number)
return boolean
is
  v_result boolean;
begin
  if length (p_cnp)!=13 then v_result:=false;
  elsif substr(p_cnp,1,1)not in (1,2)then v_result:=false;
  elsif substr(p_cnp,4,2) >12 then v_result:=false;
  else v_result:=true;
  end if;
  return v_result;
end;

declare
begin
  if verificare_cnp(/*1901228430035*/&a) then
    dbms_output.put_line('CNP valid');
  else
    dbms_output.put_line('CNP gresit');
  end if;
end;


--------------------------------EX2 Varianta1= Procedura
--sa se creeze o procedura care sa afiseze departamentul si salariul mediu din fiecare departament
create or replace procedure afisare (p_id number)
is
  cursor curs(c_id number) is 
    select department_name, avg(salary) as mediu from departments d, employees e
    where d.department_id=e.department_id and d.department_id=c_id
    group by department_name;
  curs_rec curs%rowtype;
begin
  if curs%isopen = false 
    then open curs(p_id);
  end if;
  
  loop
  fetch curs into curs_rec;
  exit when curs%notfound;
  dbms_output.put_line('Nume departament:'||curs_rec.department_name || ' Salariu mediu: ' || curs_rec.mediu);
  end loop;
close curs;
end;

execute afisare(30);

--------------------------------EX2 Varianta2=Procedura
create or replace procedure afisare2 (p_id number)
is
begin
for i in (select department_name, avg(salary) as mediu from departments d, employees e
    where d.department_id=e.department_id
    group by department_name)
      loop
        dbms_output.put_line('Nume departament:'||i.department_name || ' Salariu mediu: ' || i.mediu);
      end loop;
end;

execute afisare(30);


---------------------------------EX3 Packages!!
create or replace package test_pkg
is
  function verificare_cnp(p_cnp in number)
  return boolean;

  procedure afisare (p_id number);
end test_pkg;

create or replace package body test_pkg
is
  function verificare_cnp (p_cnp in number)
  return boolean
  is
     v_result boolean;
  begin
    if length (p_cnp)!=13 then v_result:=false;
    elsif substr(p_cnp,1,1)not in (1,2)then v_result:=false;
    elsif substr(p_cnp,4,2) >12 then v_result:=false;
    else v_result:=true;
    end if;
    return v_result;
  end;
   procedure afisare (p_id number)
is
  cursor curs(c_id number) is 
    select department_name, avg(salary) as mediu from departments d, employees e
    where d.department_id=e.department_id and d.department_id=c_id
    group by department_name;
  curs_rec curs%rowtype;
begin
  if curs%isopen = false 
    then open curs(p_id);
  end if;
  
  loop
  fetch curs into curs_rec;
  exit when curs%notfound;
  dbms_output.put_line('Nume departament:'||curs_rec.department_name || ' Salariu mediu: ' || curs_rec.mediu);
  end loop;
close curs;
end;

end;
  