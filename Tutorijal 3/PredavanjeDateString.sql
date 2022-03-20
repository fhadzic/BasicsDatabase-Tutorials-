--Jednostavne DB funkcije

--concat, substr, length, instr, lpad, trim, dovoljni za naše potrebe;
--concat radi sa samo dva parametre, spaja ih
--substr
--instr - da li ima karakter, i na kojoj je poziciji, vraca br. pozicije, Case sesitive
--lpad
--trim -

--lower, upper, initcap , za konverziju mala u velika, velika u mala, pocetna rijeci ide sa pocetnim velikim slovom ostala mala

SELECT SYSDATE,
Trunc(SYSDATE),
To_Date(To_Char(SYSDATE, 'yy'), 'yy'),
To_Date(To_Char(SYSDATE, 'rr'), 'rr'),
To_Date('01012010', 'ddmmyyyy'),
To_Date('59', 'rr')
FROM dual;


SELECT To_Char(SYSDATE, 'ddd'),
       To_Char(to_date('311219', 'ddmmyyy'), 'ddd')
FROM dual;


SELECT SYSDATE, Round(sysdate),Trunc(sysdate),
Round(To_Date('0101210'), 'ddmmyyyy'),
Next_Day(SYSDATE+15,'Fridey')
FROM dual;


                           --Samo oracle
SELECT department_id,
Decode(department_id,
        10, 'Cvijece',
        30, 'Auto',
        40, 'Nesto',
        'Ostalo'
        )
FROM employees;


SELECT department_id,
CASE department_id,
WHEN 10 THEN 'Cvijece',
WHEN 10 THEN 'Cvijece'
ELSE 'ostalo'



-- Potrebno je napisati upit koji ce prikazati, naziv zaposlenog, platu, stepen plate izrazen u hiljadama,
-- za sve one zaposlene koji rade u odjelu ciji naziv sadrzi karakter p na zadnjoj poziciji,
-- tj. da je pozicija karaktera veca od stepena plate

SELECT e.employee_id,
       e.first_name,
       e.salary,
       d.department_name,
       Round(e.salary, -3)/1000,
       LPad('*', Round(e.salary, -3)/1000, '*'), --nadopunjavanje karaktera, prva vodece, dodatno u zavisnosti od visine stepena plate
       InStr (d.department_name, 'p', -1)   --
FROM employees e, departments d
WHERE e.department_id = d.department_id
AND  Round(e.salary, -3)/1000 < InStr (d.department_name, 'p', -1)
ORDER BY employee_id;


SELECT Round(5112.553456, -3)
FROM dual;


--potrebno je sortirati sve zaposlene po datumu zaposlenja tj. danu u sedmici


--Ne valja

SELECT e.employee_id,
       e.first_name,
       e.last_name,
       e.hire_date,
       To_Char(e.hire_Date, 'dy')
FROM employees e
ORDER BY  To_Char(e.hire_Date, 'dy');




SELECT e.employee_id,
       e.first_name,
       e.last_name,
       e.hire_date,
       To_Char(e.hire_Date, 'dy')
FROM employees e
ORDER BY Decode( To_Char(e.hire_Date, 'dy'),
                'mon', 1,
                'tue', 2,
                'wen', 3,
                'thu', 4,
                'fri', 5,
                'sun', 6,
                'sat', 7);



SELECT USER
FROM dual;


SELECT * FROM employees;

UPDATE employees SET first_name = 'Neko';

CREATE TABLE zap AS
SELECT * FROM employees WHERE 1=2;






