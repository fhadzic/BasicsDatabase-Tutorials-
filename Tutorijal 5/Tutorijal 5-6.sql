
--Poupit jednog sloga
--Nekolerisani

SELECT employee_id,
       last_name,
       first_name,
       salary,
       department_id
FROM employees
WHERE department_id IN (SELECT t.department_id
                       FROM employees t
                       WHERE t.first_name = 'Sarah')
ORDER BY last_name;

--Kolerisani
SELECT e.first_name || ' ' || e.last_name,
       e.salary
FROM employees e
WHERE e.salary != (SELECT Max(t.salary)
                   FROM employees t
                   WHERE t.department_id = e.department_id)
  AND e.salary != (SELECT Min(t.salary)
                   FROM employees t
                   WHERE t.department_id = e.department_id);

--Upotreba podupita u select klauzuli, prethodna tabela plus, naziv odjela, broj zaposlenih
SELECT e.first_name || ' ' || e.last_name,
       e.salary,
       (SELECT t.department_name
        FROM departments t
        WHERE e.department_id = t.department_id) "Naziv odjela",
        ( SELECT Count(*)-1
          FROM employees t
          WHERE e.department_id = t.department_id) "Broj kolega",
        department_id
FROM employees e
WHERE e.salary != (SELECT Max(t.salary)
                   FROM employees t
                   WHERE t.department_id = e.department_id)
  AND e.salary != (SELECT Min(t.salary)
                   FROM employees t
                   WHERE t.department_id = e.department_id);

--Izbaciti podupit za naziv odjela
SELECT e.first_name || ' ' || e.last_name,
       e.salary,
       d.department_name "Naziv odjela",
        ( SELECT Count(*)-1
          FROM employees t
          WHERE e.department_id = t.department_id) "Broj kolega",
       e.department_id
FROM employees e, departments d
WHERE e.salary != (SELECT Max(t.salary)
                   FROM employees t
                   WHERE t.department_id = e.department_id)
  AND e.salary != (SELECT Min(t.salary)
                   FROM employees t
                   WHERE t.department_id = e.department_id)
  AND e.department_id = d.department_id;

--Provjera
SELECT * FROM employees WHERE department_id = 50;



--Podupit više slogova
SELECT *
FROM employees e
WHERE e.salary > any (SELECT Avg(t.salary)
                      FROM employees t
                      GROUP BY t.department_id);

--Prikazati sifru, naziv, platu, i platu uvecanu za dodatak na platu, za sve zaposlene ciji sefovi u tim organiacionim jedinicama primaju prosjecnu platu
--vecu od prosjecne plate svih zaposlenih ostalih organizacionih jedinica
SELECT e.employee_id Sifra,
       e.first_name || ' ' || e.last_name "Naziv",
       e.salary,
       e.department_id,
       Decode( commission_pct,
               NULL, 'Nema dodatka na platu',
               e.salary + (commission_pct *e.salary) )
FROM employees e
WHERE (SELECT Avg(m.salary)
       FROM employees m
       WHERE m.employee_id IN (SELECT r.manager_id
                               FROM employees r
                               WHERE m.department_id = e.department_id)) > (SELECT Avg(t.salary)
                                                                            FROM employees t
                                                                            WHERE t.department_id != e.department_id);


SELECT e.employee_id Sifra,
       e.first_name || ' ' || e.last_name "Naziv",
       e.salary,
       e.department_id,
       Nvl(To_Char ((SELECT t.salary*(1+t.commission_pct)
                     FROM employees t
                     WHERE t.employee_id = e.employee_id)), 'Nema dodatka na platu') "Plata+dodatak"
FROM employees e
WHERE e.department_id NOT IN (60, 80)
AND   e.salary > ALL( SELECT t.salary
                      FROM employees t
                      WHERE t.department_id IN(60, 80) );

--Provjera
SELECT e.department_id,
       Max(e.salary)
FROM employees e
GROUP BY e.department_id;




SELECT d.department_name
FROM employees e, departments d
WHERE e.department_id = d.department_id
HAVING  Avg(e.salary)>7000
GROUP BY d.department_name;



--EXISTS
SELECT e.first_name,
       d.department_name,
       j.job_title,
       l.city,
       e.salary
FROM employees e, departments d, jobs j, locations l
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND e.job_id = j.job_id
  AND e.department_id IN (10,30,50,60,90)
  AND EXISTS (SELECT 'X'
              FROM employees e1,departments d1,locations l1,countries c1, regions r1
              WHERE e1.department_id = d1.department_id
                and d1.location_id = l1.location_id
                and l1.country_id = c1.country_id
                and c1.region_id = r1.region_id
                and d1.department_id IN (10,30,50,60,90)
                AND r1.region_name LIKE 'America%');


--Iz LV
SELECT e.first_name,
       d.department_name odjel,
       l.city grad,
       j.job_title posao,
       e.salary plata
FROM employees e, departments d, jobs j, locations l
WHERE e.department_id = d.department_id
and e.job_id = j.job_id
and d.location_id = l.location_id
and EXISTS (SELECT e1.employee_id, d1.department_id, l1.location_id, c1.country_id, r1.region_id
            FROM employees e1,departments d1,locations l1,countries c1, regions r1
            WHERE e1.department_id = d1.department_id
             and d1.location_id = l1.location_id
             and l1.country_id = c1.country_id
             and c1.region_id = r1.region_id
             and d1.department_id IN (10,30,50,60,90)
             and lower(substr(r1.region_name,1,7)) = 'america')
and d.department_id IN (10,30,50,60,90);




--Podupit vise kolona
SELECT e.employee_id,
       e.first_name,
       j.job_title,
       e.salary
FROM employees e, jobs j
WHERE e.job_id = j.job_id
  AND (e.department_id, e.salary, 2) IN (SELECT t.department_id,t.salary, Count(t.employee_id)
                                         FROM employees t
                                         WHERE t.department_id = 50
                                         GROUP BY t.department_id, t.salary)
ORDER BY e.salary;


SELECT *
FROM employees
WHERE employee_id NOT IN (SELECT t.manager_id
                         FROM employees t
                         WHERE t.manager_id IS NULL);



--Podupit u From klauzuli
SELECT e.employee_id "Sifra zaposlenog",
       e.last_name || ' ' || e.first_name "Naziv zaposlenog",
       a.odjel "Sifra odjela",
       d.department_name "Naziv odjela",
       e.salary "Plata",
       a.pros_plata "Prosjecna plata odjela"
FROM employees e, departments d, (SELECT t.department_id AS odjel,
                                         Round(Avg(t.salary),2) AS pros_plata
                                  FROM employees t
                                  GROUP BY t.department_id) a
WHERE e.department_id = d.department_id
AND e.department_id = a.odjel
AND e.salary > a.pros_plata;









--Z1
SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       d.department_name "Naziv odjela",
       d.department_id,
       j.job_title "Naziv posla"
FROM employees e, jobs j, departments d
WHERE e.department_id = d.department_id
  AND j.job_id = e.job_id
  AND e.employee_id =ANY (SELECT t.employee_id
                          FROM employees t
                          WHERE t.first_name NOT LIKE 'Lex'
                            AND t.department_id IN ( SELECT p.department_id
                                                    FROM employees p
                                                    WHERE p.first_name LIKE 'Lex'));

--ANY se obicno koristi u kombinaciji sa (<,>,=)
--II nacin
SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       d.department_name "Naziv odjela",
       d.department_id,
       j.job_title "Naziv posla"
FROM employees e, jobs j, departments d
WHERE e.department_id = d.department_id
  AND j.job_id = e.job_id
  AND e.department_id IN  (SELECT t.department_id
                           FROM employees t
                           WHERE t.first_name LIKE 'Lex' )
  AND e.first_name NOT LIKE 'Lex';


SELECT *
FROM employees
WHERE department_id = 90;



--Z2
SELECT e.employee_id,
       e.first_name,
       e.last_name,
       e.salary
FROM employees e
WHERE e.salary > (SELECT Avg(t.salary)
                  FROM employees t
                  WHERE t.department_id IN (30,90));

--Z3
SELECT *
FROM employees e
WHERE e.department_id IN (SELECT t.department_id
                        FROM employees t
                        WHERE Upper(t.first_name) LIKE '%C%'
                         AND e.employee_id != t.employee_id);

--Z4
SELECT e.employee_id "Sifra posla",
       e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       j.job_title "Naziv posla"
FROM employees e, jobs j
WHERE e.job_id = j.job_id
  AND e.department_id IN ( SELECT d.department_id
                           FROM departments d, locations l
                           WHERE d.location_id = l.location_id
                             AND l.city LIKE 'Toronto' );

--Z5
SELECT *
FROM employees e
WHERE Nvl(e.manager_id, 0) IN (SELECT t.employee_id
                               FROM employees t
                               WHERE t.last_name LIKE 'King');

--Z6
SELECT *
FROM employees e
WHERE e.department_id IN (SELECT t.department_id
                          FROM employees t
                          WHERE Upper(t.first_name) LIKE '%C%'
                            AND e.employee_id != t.employee_id)
  AND e.salary > (SELECT Avg(t.salary)
                  FROM employees t
                  WHERE t.employee_id != e.employee_id
                    AND e.department_id = t.department_id);

--Z7
SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       d.department_name "Naziv odjela",
       e.salary "Plata"
FROM employees e, departments d
WHERE e.department_id = d.department_id
  AND (e.department_id, e.salary) IN ( SELECT t.department_id, t.salary
                                       FROM employees t
                                       WHERE commission_pct IS NOT NULL )
  AND e.commission_pct IS NULL;

--Z8
SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       d.department_name "Naziv odjela",
       e.salary "Plata",
       l.city "Grad"
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND (e.salary, Nvl(e.commission_pct,0)) IN ( SELECT t.salary, Nvl(t.commission_pct,0)
                                               FROM employees t, departments o, locations m
                                               WHERE t.department_id = o.department_id
                                                 AND o.location_id = m.location_id
                                                 AND m.city LIKE 'Seattle'
                                                 AND e.employee_id != t.employee_id );

--Z9
SELECT e.first_name  || ' ' || e.last_name "Naziv zaposlenog",
       e.hire_date "Datum zaposlenja",
       e.salary "Plata"
FROM employees e
WHERE (e.salary, Nvl(e.commission_pct,0)) IN ( SELECT t.salary, Nvl(t.commission_pct,0)
                                               FROM employees t
                                               WHERE t.first_name LIKE 'Douglas'
                                                 AND t.employee_id != e.employee_id );


--Z10
SELECT *
FROM employees e
WHERE e.salary >ALL ( SELECT t.salary
                      FROM employees t, departments d
                      WHERE t.department_id = d.department_id
                        AND d.department_name LIKE 'Sales' );

--Z11
SELECT e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       d.department_name "Naziv odjela",
       j.job_title "Posao",
       l.city "Grad"
FROM employees e, departments d, locations l, jobs j
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND e.job_id = j.job_id
  AND e.salary > ( SELECT Avg(t.salary)
                   FROM employees t
                   WHERE t.employee_id = Nvl(e.manager_id, 0)
                     AND t.commission_pct IS NOT NULL
                     AND t.department_id = e.department_id );

--Z12
SELECT e.employee_id "Sifra zaposlenog",
       e.first_name || ' ' || e.last_name "Naziv zaposlenog",
       d.department_id "Sifra odjela",
       d.department_name "Naziv odjela",
       e.salary "Plata",
       o.minimalna_plata "Min plata odjela",
       o.prosjecna_plata "Avg plata odjela",
       o.maximalna_plata "Max plata odjela",
       f.minimalna_plata "Min plata firme",
       f.prosjecna_plata "Avg plata firme",
       f.maximalna_plata "Max plata firme"
FROM employees e, departments d, (SELECT t.department_id AS odjel_id,
                                         Min(t.salary) minimalna_plata,
                                         Round (Avg(t.salary),2) prosjecna_plata,
                                         Max(t.salary) maximalna_plata
                                  FROM employees t
                                  GROUP BY t.department_id ) o,                (SELECT Min(t.salary) minimalna_plata,
                                                                                       Round (Avg(t.salary),2) prosjecna_plata,
                                                                                       Max(t.salary) maximalna_plata
                                                                                FROM employees t ) f
WHERE e.department_id = d.department_id
  AND e.department_id = o.odjel_id
  AND e.salary > (SELECT Avg(t.salary)
                  FROM employees t
                  WHERE t.department_id = e.department_id
                    AND t.employee_id IN ( SELECT Nvl( u.manager_id, 0 )
                                           FROM employees u ) );






SELECT * FROM employees;

SELECT * FROM departments;

SELECT * FROM test.testovi;


SELECT * FROM job_history;


SELECT * FROM locations;

SELECT * FROM regions;
