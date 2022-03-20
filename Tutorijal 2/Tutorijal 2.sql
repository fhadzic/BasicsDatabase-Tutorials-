
-- Zadatak 1

SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       e.employee_id "Sifra",
       d.department_name "Naziv odjela"
FROM employees e, departments d
where e.department_id = d.department_id;


--Zadatak 2

SELECT DISTINCT j.job_title "Poslovi iz odjela 30"
FroM jobs j, employees e
WHERE j.job_id = e.job_id
AND e.department_id = 30;


--Zadatak 3

SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       d.department_name "Naziv odjela",
       l.street_address
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND e.commission_pct IS NULL;


--Zadatak 4

SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       d.department_name "Naziv odjela"
FROM employees e, departments d
WHERE e.department_id = d.department_id
 AND (e.first_name LIKE '%a%'
 OR   e.first_name LIKE '%A%');


--Zadatak 5

SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       j.job_title "Posao",
       e.phone_number "Broj",
       d.department_name "Naziv odjela"
FROM employees e, departments d, jobs j, locations l
WHERE j.job_id = e.job_id
  AND e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND (l.city LIKE 'DALLAS'
  OR l.city LIKE 'Seattle');


-- Zadatak 6

SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       e.employee_id "Sifra zaposlenog",
       m.first_name || ' ' || m.last_name "Naziv sefa",
       m.employee_id "Sifra sefa",
       l.city "Grad sefa"
FROM employees e, employees m, departments d, locations l
WHERE m.employee_id = e.manager_id
AND m.department_id = d.department_id
AND d.location_id = l.location_id;


-- Provjera

SELECT e.employee_id,
       e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       l.city
FROM employees e, locations l, departments d
WHERE e.employee_id = 124
 AND e.department_id = d.department_id
 AND d.location_id = l.location_id;



-- Zadatak 7

SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       e.employee_id "Sifra zaposlenog",
       m.first_name || ' ' || m.last_name "Naziv sefa",
       m.employee_id "Sifra sefa",
       l.city "Grad sefa"
FROM  employees e
LEFT OUTER JOIN employees m
ON m.employee_id = e.manager_id
LEFT OUTER JOIN departments d
ON m.department_id = d.department_id
LEFT OUTER JOIN locations l
ON  d.location_id = l.location_id;


--II nacin
--(+) ide na stranu koja se treba popuniti sa <null> ili drugim podacima
-- plusevi se stavljaju na cijelom putu(od prve do zadnje tabele) spajanja, uz fk (ne istih tabela na tom putu)

SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       e.employee_id "Sifra zaposlenog",
       m.first_name || ' ' || m.last_name "Naziv sefa",
       m.employee_id "Sifra sefa",
       l.city "Grad sefa"
FROM employees e, employees m, departments d, locations l
WHERE m.employee_id(+) = e.manager_id
AND m.department_id = d.department_id(+)
AND d.location_id = l.location_id(+);



-- Zadatak 8

SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       e.department_id "Sifra odjela",
       k.first_name || ' ' || k.last_name "Kolege zaposlenog"
FROM employees e, employees k
WHERE e.department_id = k.department_id
  AND e.employee_id = '198'
  AND e.employee_id(+) != k.employee_id;

-- II nacin

SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       e.department_id "Sifra odjela",
       k.first_name || ' ' || k.last_name "Kolege zaposlenog"
FROM employees e
LEFT OUTER JOIN employees k
ON e.employee_id != k.employee_id
WHERE e.employee_id = '198'
AND e.department_id = k.department_id;


--Zadatak 9

SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       j.job_title "Posao",
       d.department_name "Naziv odjela",
       e.salary "Plata",
       e.salary * Nvl(e.commission_pct,0) "Stepen plate"
FROM employees e, jobs j, departments d
WHERE e.job_id = j. job_id
  AND e.department_id = d.department_id
  AND ( ( e.salary * Nvl(commission_pct, 0) ) < j.min_salary OR ( e.salary * Nvl(commission_pct, 0) ) > j.max_salary );



--Zadatak 10

SELECT k.first_name || ' ' || k.last_name "Naziv",
       k.hire_date "Datum zaposlenja"
FROM employees e, employees k
WHERE e.last_name LIKE 'Fay'
AND k.hire_date > e.hire_date;



--Zadatak 11


SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       e.hire_date "Datum zaposlenja",
       s.first_name || ' ' || s.last_name "Naziv sefa",
       s.hire_date "Datum zaposlenja",
       z.first_name || ' ' || s.last_name "Zaposleni poslije sefa",
       z.hire_date "Datum zaposlenja"
FROM employees e, employees s, employees z
WHERE e.manager_id = s.employee_id
AND s.hire_date < z.hire_date;




SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       e.hire_date "Datum zaposlenja",
       s.first_name || ' ' || s.last_name "Naziv sefa",
       s.hire_date "Datum zaposlenja"
FROM employees e, employees s
WHERE e.manager_id = s.employee_id
AND e.hire_date < s.hire_date;








SELECT * FROM employees;
SELECT * FROM departments;
SELECT * FROM jobs;
SELECT * FROM locations;








--Tutorijal 2 fax

SELECT e.first_name, d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id(+)
ORDER BY e.first_name;


SELECT e.first_name, m.first_name
FROM employees e, employees m
WHERE e.manager_id = m.employee_id;








--Join-i  - Wikpedia

--CROSS JOIN

SELECT *
FROM employees CROSS JOIN departments;


--INNER JOIN

SELECT e.Last_Name, e.Department_ID, d.Department_Name
FROM employees e
INNER JOIN departments d
ON e.Department_ID = d.Department_ID;


-- Sa tri tabele

SELECT e.Last_Name, e.Department_ID, d.Department_Name, l.city
FROM employees e
INNER JOIN departments d
ON e.Department_ID = d.Department_ID
INNER JOIN locations l
ON d.location_id = l.location_id;

--Kombinacija

SELECT e.Last_Name, e.Department_ID, d.Department_Name, l.city
FROM locations l, employees e
INNER JOIN departments d
ON e.Department_ID = d.Department_ID
WHERE  d.location_id = l.location_id;


--Ako tabele imaju isti naziv za kolone spajanja, možemo koristiti

SELECT *
FROM employees INNER JOIN departments USING (Department_ID);


--Natural JOIN

SELECT *
FROM employees NATURAL JOIN departments;


--LEFT OUTER JOIN

SELECT *
FROM employees e
LEFT OUTER JOIN departments d
ON e.Department_ID = d.Department_ID;

--Sa tri tabele

SELECT *
FROM employees e
LEFT OUTER JOIN departments d
ON e.Department_ID = d.Department_ID
left OUTER JOIN locations l
ON d.location_id = l.location_id;

-- II nacin
--(+) ide na stranu koja se treba popuniti sa <null> ili drugim podacima

SELECT *
FROM employees e, departments d
WHERE e.Department_ID = d.Department_ID(+)
ORDER BY e.salary;



--RIGHT OUTER JOIN

SELECT *
FROM employees e
RIGHT OUTER JOIN departments d
  ON e.Department_ID = d.Department_ID;


--Sa tri tabele

SELECT *
FROM employees e
Right OUTER JOIN departments d
ON e.Department_ID = d.Department_ID
Right OUTER JOIN locations l
ON d.location_id = l.location_id;


-- II nacin
--(+) ide na stranu koja se treba popuniti sa <null> ili drugim podacima

SELECT e.employee_id,
       e.first_name,
       e.last_name,
       e.department_id,
       d.department_id,
       d.department_name
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id;

-- Dodatni primjer

SELECT e.employee_id,
       e.first_name,
       e.last_name,
       e.department_id,
       d.department_id,
       d.department_name
FROM employees e
RIGHT OUTER JOIN departments d
ON d.department_id = 10;














-- Predavanje 4 sedmica


SELECT e.last_name,
      d.department_name,
      j.job_title,
      e.salary
FROM employees e, departmentts d, jobs j
WHERE e.department_id = d.department_id(+)
AND e.job_id  = j.job_id
AND e.salary> 10000
AND e.department_id IS NOT NULL;


SELECT *
FROM employees e, departments d
WHERE e.department_id(+) = d.department_id;

--svi sefovi i njihovi zaposleni

SELECT z.last_name || '' || z.first_name "zaposleni",
       s.last_name || ' ' || s.first_name "Sef",
       s.employee_id "sid",
       z.employee_id "zid"
FROM employees s, employees z
WHERE z.manager_id = s.employee_id
ORDER BY 4 DESC, 2 ASC;


SELECT first_name,
        last_name,
        e.salary,
        j.min_salary,
        j.max_salary
FROM employees e, jobs j
WHERE e.job_id = j.job_id
  AND e.salary BETWEEN j.min_salary
  AND j.max_salary;



SELECT *
FROM  employees e
Cross join departments;



-- Kartezijan nastane množenjem svih redova jedne tabele, sa redovima druge tabele
SELECT 107*27
FROM dual;
