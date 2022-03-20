--Tutorijal 3

--Funkcije za datum i vrijeme
SELECT last_name,
        first_name,
        Round(Months_Between(SYSDATE, hire_date), 2) "Broj mjeseci zaposlenja",
        hire_date,
        sysdate
FROM employees
WHERE department_id IN(10,20,30);


SELECT last_name,
        first_name,
        Months_Between(SYSDATE, hire_date),
        Add_Months(hire_date, 6),
        SYSDATE,
        hire_date
FROM employees
WHERE department_id IN(10,20,30);




--Funkcija Last_Day vraca poslijednji dan u mjesecu za zadani datum
SELECT SYSDATE,
       Last_Day(SYSDATE)
FROM dual;

--Funkcija Next_Day vraca sljedeci dan u sedmici(koji je naveden kao argument f-je) za zadani datum
SELECT SYSDATE,
       Next_day(SYSDATE, 'SUNDAY')
FROM dual;


--Funkcije Round i Trunc
SELECT Round(SYSDATE),
        Trunc(SYSDATE),
        Round(SYSDATE,'mm'),
        Trunc(SYSDATE, 'yyyy')
FROM dual;



--Aritmetick funkcije


SELECT Abs(-0.12789)
FROM dual;

--Funkcije CEIL i FLOOR
SELECT Ceil(12.45),
       floor(12.45),
       Trunc(12.55),
       Round(12.55)
FROM dual;


--Zadatak 1
SELECT SYSDATE "DATE",
       USER
FROM dual;

--Zadatak 2
SELECT employee_id,
       first_name,
       last_name,
       salary,
       Round(salary*1.25) "Plata uvecana za 25%"
FROM employees;

--Zadatak 3
SELECT employee_id,
       first_name,
       last_name,
       salary,
       Round(salary*1.25) "Plata uvecana za 25%",
       Mod(Round(salary*1.25), 100) "Ostatak plate"
FROM employees;

--Zadatak 4

SELECT first_name,
        To_Char(hire_date, 'DAY- MONTH, YYYY'),
        To_Char(Next_Day(Add_Months(hire_date, 6), 'MONDAY'), 'DAY- MONTH, YYYY')
FROM employees;

--Zadatak 5

SELECT  e.first_name,
        d.department_name,
        r.region_name,
        Round(Months_Between(sysdate, e.hire_date))
FROM employees e, departments d, locations l, countries c, regions r
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
AND l.country_id = c.country_id
AND c.region_id = r.region_id;


--Zadatak 6
SELECT e.first_name || ' prima platu ' || e.salary || ' ali on bi zelio platu ' || (e.salary+(e.salary*Nvl(e.commission_pct, 0)))*4.5 AS "Plata u snovima"
FROM employees e
WHERE e.department_id IN (10,30,50);


--Zadatak 7
SELECT e.first_name || ' + ' || e.salary,
       LPad(e.first_name || ' + ' || e.salary, 50, '$')
FROM employees e;


--Zadatak 8
SELECT Concat(SubStr(Lower(e.first_name),1,1), SubStr(Upper(e.first_name), 2, Length(e.first_name))),
       Length(e.first_name)
FROM employees e
WHERE e.first_name LIKE ('A%')
  Or e.first_name LIKE ('J%')
  Or e.first_name LIKE ('M%')
  Or e.first_name LIKE ('S%');


--Zadatak 9
SELECT e.first_name,
       e.hire_date,
       To_Char(e.hire_date,'DAY')
FROM employees e
ORDER BY Decode ( To_Char(e.hire_date,'DY'),
                 'MON', 1,
                 'TUE', 2,
                 'WED', 3,
                 'THU', 4,
                 'FRI', 5,
                 'SUN', 6,
                 'SAT', 7,
                 8);


--Zadatak 10
SELECT e.first_name,
       l.city,
       Decode(Nvl(e.commission_pct, 0),
              0, 'Nema dodatka',
              e.commission_pct, e.salary * e.commission_pct)
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id;


--Zadatak 11
SELECT e.first_name,
       e.salary,
       Round(e.salary, -3)/1000,
       LPad('*',Round(e.salary, -3)/1000, '*')
FROM employees e;


--Zadatak 12
SELECT e.first_name || ' ' || e.last_name,
       j.job_title,
       Decode(j.job_title,
              'President', 'A',
              'Manager', 'B',
              'Analyst', 'C',
              'Sales manager', 'D',
              'Programmer', 'E',
              'Ostali') "Stepen posla"
FROM employees e, jobs j
WHERE e.job_id = j.job_id;






SELECT * FROM jobs;
SELECT * FROM departments;
SELECT * FROM locations;




--ekvivalentno swith - case
SELECT e.first_name, Decode(e.department_id,
                            10, 'deset',
                            20, 'puno',
                            'ostalo')
FROM employees e;


--funkcije za konverziju
--To_Date, To_Char
--

SELECT Mod(32,10)
FROM dual;

