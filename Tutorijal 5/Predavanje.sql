
--SET operatori

--UNION, UNION ALL, INTERSECT, MINUS

--Union, vraca rezultati iz oba upita nakon cega izbacuje duplikate

--Union all ne izbacuje duplikate

--intersect - zajednicki podaci

--minus - pojavljuju se svi oni podaci koji se nalaze u prvoj tabeli

--izrazi u select listama moraju imati isti brj elemenata i njihovi tipovi...

--Prilagodjene select naredbe


--Group by proširenje klauzule
--rollup, cube, grouping, rollup

--rollup - ispod opširnije

--subtotal- zbir parcijalnih vrijednosti

SELECT department_id, job_id, Sum(salary)
FROM employees
WHERE department_id < 50
GROUP BY rollup(department_id, job_id);


--cube, ima korak vise, daje subtotale i po manjie važnim kolonama - job_id

SELECT department_id, job_id, Sum(salary)
FROM employees
WHERE department_id < 50
GROUP BY cube(department_id, job_id);

--grouping--provera po cemu si grupisao

SELECT department_id, job_id, Sum(salary)
FROM employees
WHERE department_id < 50
GROUP BY rollup(department_id, job_id);

--Grupisanje po skupovima



--Test

SELECT  Count(*)
FROM all_tables;

SELECT  Count(*)
FROM all_objects;

--Z1


--Z5
SELECT Count(*)
FROM studenti s, bodovi b
WHERE b.sid = s.id


--Z6
SELECT Months_Between(Trunc(SYSDATE,'yyyy'), Trunc(t.datum, 'yyyy'))
FROM dual d, test.Testovi t
ORDER BY 1;



--UNION(Unija dva upita, bez duplikata)
--Prikazati podatke o tekucem i prethodnim poslovima svih zaposlenih bez duplikata
SELECT employee_id, job_id
FROM employees

UNION

SELECT employee_id, job_id
FROM job_history;


--UNION ALL(Unija oba upita, sa duplikatima)
--Prikazati podatke o tekucem i prethodnim poslovima svih zaposlenih ukljucujuci i duplikate
SELECT employee_id, job_id
FROM employees

UNION ALL

SELECT employee_id, job_id
FROM job_history;


--INTERSECT (samo presjek, bez duplikata)
--Prikazati ID zaposlenog i ID poslova onih zaposlenih koji rade trenutno isti posao kao i prethodni posao na kojem su prije bili zaposleni
SELECT employee_id, job_id
FROM employees

INTERSECT

SELECT employee_id, job_id
FROM job_history;


--MINUS (samo prvi upit, bez duplikata)
--Prikazati podatke o tekucim poslovima svih zaposlenih koji ranije nisu bili zaposleni
SELECT employee_id "Radnik ID", job_id "Posao ID"
FROM employees

MINUS

SELECT employee_id, job_id
FROM job_history;


--Primjer 1
SELECT e.department_id,
       To_Number(NULL),
       e.hire_date
FROM employees e

UNION

SELECT d.department_id,
       d.location_id,
       To_Date(NULL)
FROM departments d;

--Primjer2
SELECT 'sing' AS "My dream", 3
        a_dummy
FROM dual

UNION

SELECT 'Id like to teach', 1
FROM dual

UNION

SELECT 'the world to', 2
FROM dual
ORDER BY 2;




--Group by klauzula sa proširenim operacijama
--Svrha grupnih funkcija je da rade na gupisanjima redova u cilju formiranja rezultata po specificnim grupama

SELECT  department_id, job_id,
        AVG(salary), STDDEV(salary),
        COUNT(commission_pct),
        Max(hire_date)
FROM   employees
WHERE  department_id=30
GROUP BY department_id, job_id;

--Ispis datuma zadnjeg zaposlenog radnika na nivou firme + tabela i
SELECT i.o,
       i.j,
       i.p,
       i.d,
       i.b,
       Max(e.hire_date)
FROM (SELECT  department_id o, job_id j,
              AVG(salary) p, STDDEV(salary) d,
              COUNT(commission_pct) b
      FROM   employees
      WHERE  department_id=30
      GROUP BY department_id, job_id) i, employees e
GROUP BY i.j, i.o,i.p, i.d, i.b;


--Ispisiva za svakog radnika datum, podatke iz podupita za njegov odjel, i za drugi moguci iz podupita
SELECT i.o,
       i.j,
       i.p,
       i.d,
       i.b,
       e.hire_date
FROM (SELECT  department_id o, job_id j,
              AVG(salary) p, STDDEV(salary) d,
              COUNT(commission_pct) b
      FROM   employees
      WHERE  department_id=30
      GROUP BY department_id, job_id) i, employees e
WHERE i.o = e.department_id;

SELECT * FROM employees WHERE department_id = 30 AND job_id Like 'PU_CLERK%';

--HAVING klauzula se koristi za specificiranje dodatnih uslova selekcije


--ROOLUP
--Korištenjem ROLLUP ili CUBE sa GROUP BY kreiraju se dodatni redovi sa subtotalima i unakrsnim referenciranim kontrolama
--ROLLUP(operacija za prikazivanje sumarnih vrijednosti- totala i subtotala)
--ROLLUP proizvodi skup redova koji sadrže dodatne redove sa vrijednostima subtotala po važnim kolonama grupisanja
--1-Ukljucene su sume svih koloka koje nisu null, 2-Zatim, sume koje nisu null po važnim(prvoj) kolonama, 3-Te, na kraju total sume svih navedenih kolona
--Dakle, prikaziva subtotale za kombinaciju prve dvije kolone, zatim (kada istrosi sve kombinacije u kojoj su razlicite od null) prikaziva subtotal za slog prve kolone(pr. 10 | null | 4400)
--što pretstavlja zbir svih totala za vrijednost sloga iz prve kolone
SELECT e.department_id, e.job_id, Sum(e.salary)
FROM employees e
WHERE department_id < 30
GROUP BY ROLLUP(e.department_id, E.JOB_ID);


--CUBE
--CUBE(Operacija za prikazivanje unakrsnih vrijednosti)
--CUBE proizvodi dodatne redove kao i ROLLUP sa redovima koji sadrže dodatne totale po manje važnim kolonama grupisanja
SELECT e.department_id, e.job_id, Sum(e.salary)
FROM employees e
WHERE department_id < 50
GROUP BY CUBE(e.department_id, E.JOB_ID);


--GROUPING(Operacija za identifikaciju kreiranih redova sa ROLLUP i CUBE)
--Korištenjem GROUPING funkcija mogu se formirati sumarne vrijednosti u redovima
--Upotrebom GROUPING funkcija mogu se  razlikovati  NULL vrijednost iz tabela od NULL vrijednosti kreiranih sa ROLLUP ili CUBE
--GROUPING funkcija vraca 0 (NOT NULL ) ili 1 (NULL)
SELECT e.department_id, e.job_id, Sum(e.salary), Grouping(e.department_id), Grouping(e.job_id)
FROM employees e
WHERE department_id < 50
GROUP BY ROLLUP(e.department_id, E.JOB_ID);


--GROUPING SETS
--Upotrebom GROUPING SETS moguse definisati višestruke grupe podataka nad istim upitom
--Baza podataka za sve grupe navedene u GROUPING SETS klauzuli prvo izvrši pojedinacno grupisanje tih podataka, pa ih potom kombinuje u rezultate sa UNION ALL operacijom
SELECT   department_id, job_id,
         manager_id,avg(salary)
FROM     employees
WHERE department_id< 50
GROUP BY GROUPING SETS
((department_id,job_id), (job_id,manager_id));

--Kombinovane kolone
SELECT   department_id, job_id,
         manager_id,avg(salary)
FROM     employees
WHERE department_id< 50
GROUP BY ROLLUP (department_id,(job_id, manager_id));

--Spajanje grupa
SELECT   department_id, job_id, manager_id,
         SUM(salary)
FROM     employees
where department_id< 30
GROUP BY department_id,
         ROLLUP(job_id),
         CUBE(manager_id);




SELECT department_id , To_Number(NULL), location_id, hire_date
FROM employees
UNION
SELECT department_id, location_id, to_date(NULL)
FROM departments;





