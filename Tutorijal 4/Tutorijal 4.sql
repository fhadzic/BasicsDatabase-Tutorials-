
--GROUP BY i Having

SELECT d.department_name,
       Sum(e.salary)
FROM employees e, departments d
WHERE e.department_id = d.department_id
GROUP BY d.department_name;


SELECT Sum(Nvl(e.commission_pct*e.salary, 0)),
       Count( e.commission_pct )
FROM employees e;


SELECT Sum(e.commission_pct*e.salary),
       Count( e.commission_pct )
FROM employees e;


SELECT  d.department_name,
        Count(e.employee_id)
FROM employees e, departments d
WHERE e.department_id = d.department_id
GROUP BY  d.department_name;


SELECT Count(e.employee_id)
FROM employees e
GROUP BY  e.department_id;



SELECT j.job_title,
       e.department_id,
       Count(e.employee_id)
FROM employees e, jobs j
WHERE e.job_id = j.job_id
GROUP BY j.job_title,
         e.department_id;


SELECT d.department_name,
       Sum(e.salary),
       Round(Avg(e.salary), -2)
FROM employees e, departments d
WHERE e.department_id = d.department_id
GROUP BY d.department_name
HAVING Avg(e.salary) > 7000;


SELECT d.department_name,
       Sum(e.salary),
       Round(Avg(e.salary), -2)
FROM employees e, departments d
WHERE e.department_id = d.department_id
AND Lower(d.department_name) LIKE '%a%'
GROUP BY d.department_name
HAVING Avg(e.salary) > 7000
ORDER BY 2, 1;









--Zadatak 1
SELECT Sum(Nvl(e.commission_pct*e.salary, 0)),
       Count( e.commission_pct ),
       Count(*)
FROM employees e;

--Zadatak 2
SELECT j.job_title "Naziv posla",
       d.department_name "Naziv organizacione jedinice",
       Count(employee_id) "Broj uposlenih"
FROM employees e, departments d, jobs j
WHERE e.department_id = d.department_id
AND j.job_id = e.job_id
GROUP BY j.job_title, d.department_name;

--Zadatak 3
SELECT Max(e.salary),
       Min(e.salary),
       Sum(e.salary),
       Round(Avg(e.salary), 6)
FROM employees e;

--Zadatak 4
SELECT Max(e.salary),
       Min(e.salary),
       Sum(e.salary),
       Round(Avg(e.salary), 6),
       Count(e.employee_id)
FROM employees e, jobs j
WHERE e.job_id = j.job_id
GROUP BY j.job_title;

--Zdatak 5
SELECT j.job_title,
       Count(e.employee_id)
FROM employees e, jobs j
WHERE j.job_id = e.job_id
GROUP BY j.job_title;

--Zadatak 6
SELECT Count(DISTINCT e.manager_id)
FROM employees e;

--Zadatak 7
SELECT DISTINCT m.first_name,
                m.salary
FROM employees m, employees e
WHERE e.manager_id = m.employee_id
AND   m.salary <= (SELECT Min(s.salary)
                   FROM employees t, employees s
                   WHERE t.manager_id = s.employee_id
                   AND s.department_id != m.department_id);

--Provjere
SELECT DISTINCT m.first_name,
                m.salary
FROM employees m, employees e
WHERE e.manager_id = m.employee_id
AND m.department_id = 50;

SELECT DISTINCT m.first_name,
                m.salary,
                m.department_id
FROM employees m, employees e
WHERE e.manager_id = m.employee_id
AND m.department_id != 50
AND m.salary <= (SELECT Min(s.salary)
                FROM employees t, employees s
                WHERE t.manager_id = s.employee_id
                AND s.department_id != 50);

--Zadatak 8
SELECT d.department_name,
       l.city,
       Count(e.employee_id),
       Round(Avg(e.salary),2)
FROM employees e, departments d, locations l
WHERE e.department_id = d.department_id
AND d.location_id = l.location_id
GROUP BY d.department_name, l.city ;

--Zadatak 9
SELECT (SELECT Count(t.employee_id)
        FROM employees t
        WHERE To_Char(t.hire_date, 'YYYY') LIKE '2003') "2003g",

        (SELECT Count(t.employee_id)
        FROM employees t
        WHERE To_Char(t.hire_date, 'YYYY') LIKE '2004') "2004g",

        (SELECT Count(t.employee_id)
        FROM employees t
        WHERE To_Char(t.hire_date, 'YYYY') LIKE '2005') "2005g",

        (SELECT Count(t.employee_id)
        FROM employees t
        WHERE To_Char(t.hire_date, 'YYYY') LIKE '2006') "2006g",

        Count (e.employee_id) "Ukupan broj zaposlenih"

FROM employees e
WHERE To_Char(e.hire_date, 'YYYY') BETWEEN '2003' and '2006'
GROUP BY 1;

--Mozda moguc nacin
SELECT Decode (To_Char(e.hire_date, 'YYYY'),
               '2003', Count(e.hire_date)
              ) "2003g",
       Decode (To_Char(e.hire_date, 'YYYY'),
               '2004', Count(e.hire_date)
              ) "2004g",
       Decode (To_Char(e.hire_date, 'YYYY'),
               '2005', Count(e.hire_date)
              ) "2005g",
       Decode (To_Char(e.hire_date, 'YYYY'),
               '2006', Count(e.hire_date)
              ) "2006g",

       (SELECT Count (t.employee_id)
        FROM employees t
        WHERE To_Char(t.hire_date, 'YYYY') BETWEEN '2003' and '2006'
        ) "Ukupan broj zaposlenih"

FROM employees e
GROUP BY To_Char(e.hire_date, 'YYYY');


--Zadatak 10
SELECT j.job_title "Posao",
       (SELECT Sum(t.salary)
        FROM employees t
        WHERE t.department_id = 10
        AND t.job_id = j.job_id) "Odjel 10",

        (SELECT Sum(t.salary)
        FROM employees t
        WHERE t.department_id = 30
        AND t.job_id = j.job_id) "Odjel 30",

        (SELECT Sum(t.salary)
        FROM employees t
        WHERE t.department_id = 50
        AND t.job_id = j.job_id) "Odjel 50",

        (SELECT Sum(t.salary)
        FROM employees t
        WHERE t.department_id = 90
        AND t.job_id = j.job_id) "Odjel 90",

        Sum(e.salary)
FROM employees e, jobs j
WHERE j.job_id = e.job_id
AND e.department_id IN (10, 30, 50, 90)
GROUP BY j.job_title, j.job_id;


SELECT j.job_title,
       d.department_id,
       Count(e.employee_id)
FROM employees e, jobs j, departments d
WHERE e.department_id = d.department_id
AND e.job_id = j.job_id
GROUP by j.job_title, d.department_id;


SELECT DISTINCT department_id
FROM departments;


SELECT 4400+24900+156400+5800
FROM dual;


SELECT * FROM employees;
SELECT * FROM job_history;






