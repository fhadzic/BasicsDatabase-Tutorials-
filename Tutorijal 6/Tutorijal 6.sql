DROP TABLE z17685;
DROP TABLE o17685;

--Z1
Create table z17685 as ( Select *
                         From employees );

--Z2
Desc z17685;
--Kolone: employee_id, last_name, email,
--        hire_date, job_id. Ne smiju biti NULL.
--Svaka kolona ima svoje ogranicenje vezano za tip.

--Z3
--Ako se sve kolone dodaju, njihovi nazivi (nakon naziva tabele), se ne moraju navoditi.
Insert all
       into z17685 (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
       values (207, 'Ferid', 'Hadzic', 'feridlive.com', '258-211', to_date( '08.12.2019', 'dd.mm.yyyy' ), 'IT_PROG', 10000, 0.3, 100, (select d.department_id
                                                                                                                                       from departments d
                                                                                                                                       where d.department_name like 'Marketing'))
       into z17685 (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
       values (208, 'Mujo', 'Mujic', 'mujolive.com', '253-233', to_date( '08.12.2019', 'dd.mm.yyyy' ), 'SH_CLERK', 8500, 0.15, 100, (select d.department_id
                                                                                                                                       from departments d                                                                                                                                where d.department_name like 'Marketing'))
       into z17685 (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
       values (209, 'Pero', 'Peric', 'perolive.com', '225-883', to_date( '08.12.2019', 'dd.mm.yyyy' ), 'IT_PROG', 500, 0.3, 100, (select d.department_id
                                                                                                                                       from departments d
                                                                                                                                       where d.department_name like 'Marketing'))
       into z17685 (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
       values (210, 'Niko', 'Neznanovic', 'nikolive.com', '233-233', to_date( '08.12.2019', 'dd.mm.yyyy' ), 'SH_CLERK', 6500, 0.15, 100, (select d.department_id
                                                                                                                                       from departments d
                                                                                                                                       where d.department_name like 'Marketing'))
       into z17685
       values (211, 'Harun', 'Agic', 'harunlive.com', '532-211', to_date( '08.12.2019', 'dd.mm.yyyy' ), 'IT_PROG', 9000, 0.2, 100, (select d.department_id
                                                                                                                                       from departments d
                                                                                                                                       where d.department_name like 'Marketing'))
Select 1 from dual;


--Z4
Update z17685
set commission_pct = 0.1
where salary > 3000;

rollback z17685;

Update z17685
set commission_pct = 0.1
where salary < 3000;


--Z5
--Dodao jedan slog, za provjeru korektnosti rada UPDATE-a
Insert into z17685 (employee_id, first_name, last_name, email, phone_number, hire_date, job_id, salary, commission_pct, manager_id, department_id)
values(211, 'Faruk', 'Ohran', 'faruklive.com', '592-211', to_date( '08.12.2019', 'dd.mm.yyyy' ), 'IT_PROG', 6000, 0.2, 100, (select d.department_id
                                                                                                                                       from departments d
                                                                                                                                       where d.department_name like 'Public Relations'));
Update z17685 z
set z.salary = z.salary + z.salary * Decode (z.commission_pct,
                                             null, -0.1,
                                             z.commission_pct),
    z.commission_pct =  Decode (z.commission_pct,
                                null, 0.15,
                                z.commission_pct)
where z.department_id in ( select d.department_id
                           from departments d, locations l
                           where d.location_id = l.location_id
                             and l.city like 'Munich');
--Provjera nakon update
select e.first_name,
       e.salary,
       e.commission_pct,
       l.city,
       d.department_id,
       department_name
from departments d, locations l, z17685 e
where d.location_id = l.location_id
  and e.department_id = d.department_id
  and l.city like 'Munich';



--Z6
Update z17685 z
set z.department_id = (select d.department_id
                       from departments d
                       where d.department_name like 'Marketing')
where z.department_id in ( select d.department_id
                           from departments d, locations l, countries c, regions r
                           where d.location_id = l.location_id
                             and l.country_id = c.country_id
                             and c.region_id = r.region_id
                             and r.region_name Like 'Europe%')
  and z.salary < (select avg(e.salary)
                  from z17685 e
                  where e.department_id = z.department_id
                    and e.employee_id != z.employee_id)
  and ( z.salary, z.department_id)  not in  (select min(e.salary),
                                                    e.department_id
                                              from z17685 e
                                              group by e.department_id)
  and ( z.salary, z.department_id)  not in  (select max(e.salary),
                                                    e.department_id
                                              from z17685 e
                                              group by e.department_id);
--Predugo izvrsava America-u, pa sam napisao select za nju
select z.department_id "stari id",
       (select d.department_id
        from departments d
        where d.department_name like 'Marketing') "novi id"
from z17685 z
where z.department_id in ( select d.department_id
                           from departments d, locations l, countries c, regions r
                           where d.location_id = l.location_id
                             and l.country_id = c.country_id
                             and c.region_id = r.region_id
                             and r.region_name Like 'America%')
  and z.salary < (select avg(e.salary)
                  from z17685 e
                  where e.department_id = z.department_id
                    and e.employee_id != z.employee_id)
  and ( z.salary, z.department_id)  not in  (select min(e.salary),
                                                    e.department_id
                                              from z17685 e
                                              group by e.department_id)
  and ( z.salary, z.department_id)  not in  (select max(e.salary),
                                                    e.department_id
                                              from z17685 e
                                              group by e.department_id);

--proba
select * from z17685 z
where ( z.salary, z.department_id)  not in  (select min(e.salary),
                                                    e.department_id
                                              from z17685 e
                                              group by e.department_id)
  and ( z.salary, z.department_id)  not in  (select max(e.salary),
                                                    e.department_id
                                              from z17685 e
                                              group by e.department_id);

--provjera
--employees tabela, dakle, prije update
select z.department_id "stari id",
       (select d.department_id
        from departments d
        where d.department_name like 'Marketing') "novi id"
from employees z
where z.department_id in ( select d.department_id
                           from departments d, locations l, countries c, regions r
                           where d.location_id = l.location_id
                             and l.country_id = c.country_id
                             and c.region_id = r.region_id
                             and r.region_name Like 'Europe%')
  and z.salary < (select avg(e.salary)
                  from z17685 e
                  where e.department_id = z.department_id
                    and e.employee_id != z.employee_id)
  and ( z.salary, z.department_id)  not in  (select min(e.salary),
                                                    e.department_id
                                              from z17685 e
                                              group by e.department_id)
  and ( z.salary, z.department_id)  not in  (select max(e.salary),
                                                    e.department_id
                                              from z17685 e
                                              group by e.department_id);
--poslije update-a, 14 redova update-ovano
select z.department_id "stari id",
       (select d.department_id
        from departments d
        where d.department_name like 'Marketing') "novi id"
from z17685 z
where z.department_id in ( select d.department_id
                           from departments d, locations l, countries c, regions r
                           where d.location_id = l.location_id
                             and l.country_id = c.country_id
                             and c.region_id = r.region_id
                             and r.region_name Like 'Europe%')
  and z.salary < (select avg(e.salary)
                  from z17685 e
                  where e.department_id = z.department_id
                    and e.employee_id != z.employee_id)
  and ( z.salary, z.department_id)  not in  (select min(e.salary),
                                                    e.department_id
                                              from z17685 e
                                              group by e.department_id)
  and ( z.salary, z.department_id)  not in  (select max(e.salary),
                                                    e.department_id
                                              from z17685 e
                                              group by e.department_id);




--Z7
Update z17685 z
set z.manager_id = (SELECT s.employee_id
                    FROM z17685 s
                    WHERE (SELECT Count(e.manager_id)
                           FROM z17685 e
                           WHERE s.employee_id = e.manager_id)  <ALL  (SELECT Count(m.employee_id)
                                                                       FROM z17685 m
                                                                       WHERE m.employee_id IN ( SELECT e.manager_id
                                                                                                FROM employees e )
                                                                         AND s.employee_id != m.employee_id) )
where z.employee_id in (Select s.manager_id
                        from z17685 s
                        where ( select count(u.manager_id)
                                from z17685 u
                                where s.employee_id = u.manager_id) > ( select avg(u.manager_id)
                                                                        from z17685 u
                                                                        where z.employee_id IN (SELECT n.manager_id
                                                                                                FROM z17685 n
                                                                                                WHERE n.employee_id = u.manager_id
                                                                                                  AND n.employee_id != s.employee_id));

--Z8
Create table o17685 as ( Select *
                         From departments );


--Z9
UPDATE o17685 d
SET d.department_name = 'US -' || d.department_name
WHERE d.location_id IN ( SELECT l.location_id
                         FROM locations l, countries c, regions r
                         WHERE l.country_id = c.country_id
                           AND c.region_id = r.region_id
                           AND r.region_name LIKE 'America%' );

UPDATE o17685 d
SET d.department_name = 'OS -' || d.department_name
WHERE d.location_id NOT IN ( SELECT l.location_id
                             FROM locations l, countries c, regions r
                             WHERE l.country_id = c.country_id
                               AND c.region_id = r.region_id
                               AND r.region_name LIKE 'America%' );
--II nacin
UPDATE o17685 d
SET d.department_name = Decode(d.department_name,
                               (SELECT d.department_name
                                FROM locations l, countries c, regions r
                                WHERE d.location_id = l.location_id
                                  AND l.country_id = c.country_id
                                  AND c.region_id = r.region_id
                                  AND r.region_name LIKE 'America%'), 'US -'||d.department_name,
                               'OS -'|| d.department_name);

--Z10
DELETE z17685 z
WHERE z.department_id IN (SELECT d.department_id
                          FROM departments d
                          WHERE Upper (d.department_name) LIKE '%A%' );

--Z11
DELETE o17685 o
WHERE Nvl(o.department_id, 0)  NOT IN ( SELECT Nvl(z.department_id, 0)
                                        FROM z17685 z );

--Z12
DELETE z17685 z
WHERE z.department_id NOT IN (SELECT d.department_id
                              FROM locations l, countries c, regions r, departments d
                              WHERE d.location_id = l.location_id
                                AND l.country_id = c.country_id
                                AND c.region_id = r.region_id
                                AND r.region_name LIKE 'Asia%')
  AND 3 <=  ( SELECT Count(s1.manager_id)
              FROM z17685 s1, z17685 s
              WHERE z.employee_id = s1.manager_id
                AND s.employee_id = z.manager_id
                AND s.salary > ((SELECT m.employee_id
                                 FROM z17685 m
                                 WHERE (SELECT Count(e.manager_id)
                                        FROM z17685 e
                                        WHERE m.employee_id = e.manager_id)  <ALL  (SELECT Count(m.employee_id)
                                                                                    FROM z17685 m
                                                                                    WHERE m.employee_id IN ( SELECT e.manager_id
                                                                                                             FROM employees e )
                                                                                    AND s.employee_id != m.employee_id) );
)))



--Ispis osobe koja je sef najvise uposlenika
SELECT  m.employee_id,
        m.first_name || ' ' || m.last_name  "Naziv sefa",
        m.manager_id,
        m.salary,
       (SELECT Max(Count(g.manager_id))
        FROM z17685 g
        WHERE g.manager_id IS NOT NULL
        GROUP BY g.manager_id ) "Broj podredjenih"
FROM z17685 m
WHERE m.employee_id IN (SELECT s.manager_id
                       FROM z17685 s
                       WHERE s.manager_id IS NOT NULL
                       GROUP BY s.manager_id
                       HAVING Count(s.manager_id) = (SELECT Max(Count(g.manager_id))
                                                     FROM z17685 g
                                                     WHERE g.manager_id IS NOT NULL
                                                     GROUP BY g.manager_id) );








--Vraca minimalan broj osoba, kojima je neka osoba sef
SELECT Min( Count(s.manager_id) )
FROM z17685 s
WHERE s.manager_id IS NOT null
GROUP BY s.manager_id;




select * from z17685;
SELECT * FROM o17685;
select * from regions;
select * from departments;
select * from locations;