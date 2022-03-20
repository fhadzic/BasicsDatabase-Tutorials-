
--Sa START WITH kreiramo pocetnu tacku od koje ce se poceti graditi drvo

--BUTTOM UP, od dna ka vise
SELECT employee_id, last_name, job_id, manager_id
FROM employees
START WITH employee_id = 105
CONNECT BY PRIOR manager_id = employee_id;

--TOP DOWN - od vrha ka dnu
SELECT last_name || ' reports to ' ||
PRIOR last_name "Top down"
FROM employees
START WITH last_name = 'King'
CONNECT BY PRIOR employee_id = manager_id;

SELECT employee_id, last_name, job_id, manager_id
FROM employees
START WITH employee_id = 100
CONNECT BY PRIOR employee_id = manager_id;

--LEVEL i LPAD
SELECT LPad ( last_name,  Length(last_name) + LEVEL*2-2, '_' ) org_chart                                                      1
FROM employees
START WITH last_name = 'King'
CONNECT BY PRIOR employee_id = manager_id;

--Koristenjem where kaluzule eliminisu se cvorovi Pr where last_name != 'Higgins'
--Koristenjem connect by eliminisu se grane Pr.
--CONNECT BY PRIOR employee_id = manager_id
--AND last_name != 'Higgins'




--TOP N analiza
SELECT ROWNUM AS Rank, ename, sal
FROM ( SELECT last_name ename,
              salary sal
       FROM employees
       ORDER BY salary desc )
WHERE ROWNUM <= 3;


--Synoym-i
CREATE SYNONYM n_p
FOR narudzba_proizvoda;

SELECT * FROM n_p;

DROP SYNONYM n_p;



--Kursori
DECLARE
  lv_rows_deleted VARCHAR2(30);
  lv_department_id NUMBER := 30;
BEGIN
  DELETE FROM proizvod
  WHERE proizvod_id = lv_department_id;

  lv_rows_deleted := (SQL%ROWCOUNT ||' slogova izbrisano.');
  dbms_output.put_line(lv_rows_deleted);
END;
/



SELECT * FROM proizvod;
SELECT * FROM employees;