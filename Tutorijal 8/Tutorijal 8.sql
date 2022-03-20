--Constraint-i
DROP TABLE zaposleni;
CREATE TABLE zaposleni ( id NUMBER,
                         ime VARCHAR2(50)  NOT NULL,
                         prezime VARCHAR2(50) NOT NULL,
                         plata NUMBER NOT NULL,
                         CONSTRAINT c_zap_PK PRIMARY KEY (id) );


--View
CREATE VIEW zap_view AS
       SELECT *
       FROM employees
       WHERE department_id = 30;

DESC VIEW zap_view;

SELECT * FROM zap_view;

DROP VIEW zap_view;

CREATE VIEW plata_odjela(odjel, min_plata, max_plata, sre_plata)
AS
SELECT d.department_name,
       Min(e.salary),
       Max(e.salary),
       Round(Avg(e.salary), 2)
FROM employees e, departments d
WHERE e.department_id = d.department_id
GROUP BY d.department_name;

SELECT * FROM plata_odjela;

DROP VIEW plata_odjela;


SELECT * FROM all_views;
SELECT * FROM USER_views;


--Sekvence
CREATE SEQUENCE test_seq
INCREMENT BY 1
START WITH 50012
MAXVALUE 50100
NOCACHE
NOCYCLE;

--NEXTVAL-vraca sljedeci broj seqvence
SELECT test_seq.NEXTVAL FROM dual;

--CURRVAL-vraca trenutno generisani broj sekvence
SELECT test_seq.CURRVAL FROM dual;

DROP SEQUENCE test_seq;

SELECT * FROM all_sequences;

SELECT * FROM user_sequences;


--Promjena za neku od definisanih vrijednosti sekvenci moguce je izvrsiti putem ALTER SEQUENCE komande,
--ali sa jednom iznimkom, a to je da nije moguce mijenjati START WITH vrijednost seqvence.

ALTER SEQUENCE test_seq
INCREMENT BY 1
MAXVALUE 100000
NOCACHE
NOCYCLE;

DROP SEQUENCE test_seq;





--Z1
CREATE TABLE emp_zaposleni AS
       SELECT * FROM employees;

ALTER TABLE emp_zaposleni ADD ( id NUMBER );

CREATE SEQUENCE zap_seq
INCREMENT BY 1
START WITH 1
MAXVALUE 500
NOCACHE
NOCYCLE;

UPDATE emp_zaposleni
SET id = zap_seq.NEXTVAL;

ALTER TABLE emp_zaposleni DROP COLUMN employee_id;

ALTER TABLE emp_zaposleni ADD CONSTRAINT c_zap_PK PRIMARY KEY(id);

SELECT * FROM all_cons_columns
WHERE owner = 'FH17685' AND Lower(column_name) = 'id';

SELECT * FROM emp_zaposleni;

DROP TABLE emp_zaposleni;
DROP SEQUENCE zap_seq;

--Z2
CREATE TABLE dep_odjeli AS
       SELECT * FROM departments;

DELETE FROM dep_odjeli;

ALTER TABLE dep_odjeli DROP COLUMN department_id;

ALTER TABLE dep_odjeli ADD( id NUMBER,
                            datum DATE,
                            CONSTRAINT c_odj_id_datum_PK PRIMARY KEY (id, datum) );

INSERT INTO dep_odjeli(id, department_name, manager_id, location_id, datum)
       SELECT d.department_id, d.department_name, d.manager_id, d.location_id, SYSDATE
       FROM departments d;

SELECT * FROM dep_odjeli;

--Z3
SELECT * FROM all_cons_columns
WHERE owner = 'FH17685'
AND ( table_name = 'EMP_ZAPOSLENI'
OR table_name = 'DEP_ODJELI');

ALTER TABLE emp_zaposleni
      ADD ( dep_odjel_id NUMBER,
            datum_odjela DATE );

UPDATE emp_zaposleni z
SET z.dep_odjel_id = z.department_id,
    z.datum_odjela = (SELECT d.datum
                      FROM dep_odjeli d
                      WHERE d.id = z.department_id);

ALTER TABLE emp_zaposleni DROP COLUMN department_id;

ALTER TABLE emp_zaposleni ADD CONSTRAINT c_odjeli_id_dat_fk FOREIGN KEY (dep_odjel_id, datum_odjela)
                              REFERENCES dep_odjeli (id, datum);

--Z4
SELECT *
FROM user_constraints;

SELECT *
FROM all_constraints
WHERE Lower(owner) = 'hr';

SELECT *
FROM all_constraints
WHERE Lower(owner) = 'test';

--Z5
SELECT *
FROM all_constraints
WHERE Lower(owner) = 'hr'
  AND Lower(table_name) IN ('employees', 'departments');

--6
ALTER TABLE emp_zaposleni ADD(plata_dodatak NUMBER);

UPDATE emp_zaposleni z
SET z.plata_dodatak = z.salary * (1 + Nvl(z.commission_pct, 0) )
WHERE z.dep_odjel_id IN (SELECT d.department_id
                         FROM departments d, locations l, countries c, regions r
                         WHERE d.location_id = l.location_id
                           AND c.country_id = l.country_id
                           AND c.region_id = r.region_id
                           AND Lower(r.region_name) LIKE 'america%');

--7
ALTER TABLE emp_zaposleni ADD CONSTRAINT kol_dodatak_ck
                              CHECK ( plata_dodatak BETWEEN 0 AND 50000 );

--8
CREATE VIEW zap_pog AS
       SELECT e.employee_id "sifra zaposlenog",
              e.last_name || '' || e.first_name "naziv zaposlenog",
              d.department_name "naziv odjela"
       FROM employees e, departments d
       WHERE e.department_id = d.department_id
         AND e.salary > ( SELECT Avg(t.salary)
                          FROM employees t
                          WHERE t.department_id = e.department_id );

--9
SELECT * FROM zap_pog;

--10
CREATE OR REPLACE VIEW Z10 AS
       SELECT j.job_title "Naziv posla",
              d.department_name "Naziv odjela",
              Round(Avg(e.salary), 2) "Prosjek plata",
              Sum(e.salary*Nvl(e.commission_pct, 0)) "Suma dodataka na platu"
       FROM employees e, departments d, jobs j
       WHERE e.department_id = d.department_id
         AND e.job_id = j.job_id
         AND REGEXP_Like(j.job_title, '[abc]')
         AND REGEXP_Like(d.department_name, '[abc]')
       GROUP BY j.job_title, d.department_name
WITH READ ONLY;

SELECT * FROM Z10;

--11
CREATE OR REPLACE VIEW Z10 AS
       SELECT j.job_title "Naziv posla",
              d.department_name "Naziv odjela",
              Round(Avg(e.salary), 2) "Prosjecna plata",
              Sum(e.salary*Nvl(e.commission_pct, 0)) "Suma dodataka na platu",
              plate.prosjek "Prosjecna plata odjela"
       FROM employees e, departments d, jobs j, (SELECT department_id, Round(Avg(salary)) prosjek
                                                 FROM employees
                                                 GROUP BY department_id) plate
       WHERE e.department_id = d.department_id
         AND plate.department_id = d.department_id
         AND e.job_id = j.job_id
         AND REGEXP_Like(j.job_title, '[abc]')
         AND REGEXP_Like(d.department_name, '[abc]')
       GROUP BY j.job_title, d.department_name, plate.prosjek
WITH READ ONLY;

--12
CREATE OR REPLACE VIEW Z10 AS
       SELECT j.job_title "Naziv posla",
              d.department_name "Naziv odjela",
              Round(Avg(e.salary), 2) "Prosjecna plata",
              Sum(e.salary*Nvl(e.commission_pct, 0)) "Suma dodataka na platu",
              plate.prosjek "prosjecna plata odjela"
       FROM employees e, departments d, jobs j, (SELECT department_id, Round(Avg(salary)) prosjek
                                                 FROM employees
                                                 GROUP BY department_id) plate
       WHERE e.department_id = d.department_id
         AND plate.department_id = d.department_id
         AND e.job_id = j.job_id
         AND REGEXP_Like(j.job_title, '[abc]')
         AND REGEXP_Like(d.department_name, '[abc]')
       GROUP BY j.job_title, d.department_name, plate.prosjek
WITH READ ONLY;

--13
CREATE VIEW Z13 AS
       SELECT m.last_name || ' ' || m.first_name "Naziv managera",
              Count(e.manager_id) "Broj podredjenih",
              odjel_sefa.min_plata "Min plata sef-ovog odjela",
              odjel_sefa.max_plata "Max plata sef-ovog odjela"
       FROM employees m, employees e, (SELECT t.department_id odjel_id,
                                              Min(t.salary) min_plata,
                                              Max(t.salary) max_plata
                                       FROM employees t
                                       GROUP BY t.department_id ) odjel_sefa
       WHERE m.employee_id = e.manager_id
         AND odjel_sefa.odjel_id = m.department_id
       GROUP BY m.last_name || ' ' || m.first_name, odjel_sefa.min_plata, odjel_sefa.max_plata;

--14
CREATE OR REPLACE VIEW Z13 AS
       SELECT m.last_name || ' ' || m.first_name "Naziv managera",
              Count(e.manager_id) "Broj podredjenih",
              odjel_sefa.min_plata "Min plata sef-ovog odjela",
              odjel_sefa.max_plata "Max plata sef-ovog odjela",
              sume.plate "Sum plata+dodatak podredjenih"
       FROM employees m, employees e, (SELECT t.department_id odjel_id,
                                              Min(t.salary) min_plata,
                                              Max(t.salary) max_plata
                                       FROM employees t
                                       GROUP BY t.department_id ) odjel_sefa, (SELECT manager_id, Sum(salary) plate
                                                                               FROM employees
                                                                               GROUP BY manager_id) sume
       WHERE m.employee_id = e.manager_id
         AND odjel_sefa.odjel_id = m.department_id
         AND m.employee_id = sume.manager_id
       GROUP BY m.last_name || ' ' || m.first_name, odjel_sefa.min_plata, odjel_sefa.max_plata, sume.plate
       ORDER BY 1
WITH READ ONLY;



SELECT * FROM emp_zaposleni;
SELECT * FROM dep_odjeli;

SELECT* FROM regions r;
SELECT * FROM locations ;
SELECT * FROM countries;
SELECT * FROM jobs;
SELECT * FROM employees;
