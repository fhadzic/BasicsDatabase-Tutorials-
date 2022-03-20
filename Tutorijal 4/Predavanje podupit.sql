
--Predavanje GRUPISANJE (AGREGACIJU) PODATAKA

--Max, Min, AVG - prosjecna vrijednost, COUNT- f-ja koja prebrojava, STDDEV - standardna devijacija(kad je kvadriramo dobijamo variance), SUM (suma) VARIANCE

SELECT Max(salary)
FROM employees;


SELECT Max(salary), first_name
FROM employees
GROUP BY salary;

-- Count(*)- daje sve slogove
-- Ako se prevarimo pa stavimo kao arg kolonu koja ima null, te slogove nece prebrojati
Count

SELECT Count(Nvl(commission_pct, 0)) Prosjek
FROM employees;


--Sve kolone koje koriste agregatne f-je, moraju se pobrojati u group by


SELECT e.department_id,
        Avg(e.salary)
FROM departments d, employees e
WHERE d.department_id = e.emploees_id
GROUP BY e.slalary, department_id;


SELECT e.department_id depto,
        sum(e.salary)
FROM departments d, employees e
WHERE d.department_id = e.emploees_id
GROUP BY department_id;


-- Cita indexe a ne slogove, pa je puno brza
-- broj zaposlenih po odjelima
SELECT department_id,
  Count(*)
FROM employees
GROUP BY department_id
order BY 1;


SELECT department_id,
  Count(*),
  Avg(salary),
  Min(salary),
  Sum(salary)/Count(*)
FROM employees
GROUP BY department_id, manager_id, job_id;



-- Povecanjem broja kolona koje ne koriste agregatne f-je, povecava se broj slogova
--Primjer

SELECT department_id, manager_id,
  Count(*),
  Avg(salary),
  Min(salary),
  Sum(salary)/Count(*)
FROM employees
GROUP BY department_id, manager_id, job_id;



SELECT department_id, manager_id, job_id,
  Count(*),
  Avg(salary),
  Min(salary),
  Sum(salary)/Count(*)
FROM employees
GROUP BY department_id, manager_id, job_id;


SELECT employee_id, department_id, manager_id, job_id,
  Count(*),
  Avg(salary),
  Min(salary),
  Sum(salary)/Count(*)
FROM employees
GROUP BY employee_id, department_id, manager_id, job_id;




--U where klauzuli se ne smije koristiti agredatna f-ja
-- Za to koristimo having, i praksa je da se u having koriste samo grupne f-je

SELECT
FROM
WHERE
GROUP BY
HAVING
ORDER BY


SELECT e.department_id, Avg(e.salary)
FROM employees e
GROUP BY e.department_id
HAVING Avg(e.salary) > 10000;



SELECT e.department_id, e.job_id, Avg(e.salary)
FROM employees e
GROUP BY e.department_id, e.job_id
HAVING Avg(e.salary) > 10000;


--Prvo se grupise po vrijednostima kolona job_id i department_id

-- ugnijezdene agregatne funkcije mogu se izvrsiti jedino ako su SAAAME u selectu


--Podupiti

SELECT
FROM
WHERE (SELECT
       FROM )




SELECT employee_id, first_name
FROM employees
WHERE job_id = (SELECT job_id
                FROM employees
                WHERE last_name = 'SMYTHE')




--Napisati upit koji ce prikazati sifru odjela, prosjecnu platu po odjelu i minimalnu platu na nivou firme za sve u odjelu

SELECT e.department_id,
       Round(Avg(e.salary), 2) "Prosjek na nivou odjela",
       (SELECT Min(t.salary)  --t kao temp, privremena
        FROM employees t) "Min na nivou firme"
FROM employees e
GROUP BY e.department_id



--Prikazati naziv zaposlenog i naziv odjela, kao i sumarnu platu za sve one zaposlene koji imaju platu uvecanu za dodatak, vecu od projecne plate u odjelu u kojem plate

SELECT e.first_name,
       d.department_name,
       Sum(e.salary)
FROM employees e, departments d
WHERE e.department_id = d.department_id
AND e.salary + Nvl((e.salary*commission_pct),0) > (SELECT Avg(t.salary)
                                                   FROM employees t
                                                   WHERE t.department_id = e.department_id)
GROUP BY e.first_name, d.department_name;




--Napisati naziv zaposlenog i naziv posla za sve one zaposlene koji su radili na dva ili vise poslova, od pocetka zaposlenja


SELECT e.first_name,
       j.job_title
FROM employees e, jobs j
WHERE e.job_id = j.job_id
AND 2 <= (SELECT Count(DISTINCT t.job_id)
          FROM job_history t
          WHERE e.employee_id = t.employee_id);


SELECT * from job_history;

--Probati od pocetka nekog perioda



--Podupiti više kolona

-- kada se pravi improvizovana kolona, mora se napraviti  kolona koja se moze uvezati sa drugom tabelom

SELECT a.last_name, a.salary, a.department_id, b.salvag
FROM employees a, (SELECT department_Id
                   FROM Avg(salary) salvag
                   GROUP BY department_id) b
WHERE



--Max duzina karaktera za jedan upit je??



































