--Constrains
--Unique ima jedinstvene vrijednosti ali moze biti null
--Surogatni nametnuti kljuc JMBG
--PK = Unique + NOT NULL
--Jedna kolona jedan primarni kljuc za svaku tabelu...
--rownum - broj reda
--5 konstreita: check, unique, pk, fk, not null.
--

SELECT constraint_name, constraint_type
FROM user_constraints
WHERE TABLE_name = 'EMPLOYEES';




--Pogledi(view)

CREATE VIEW emo_30
AS SELECT employee_id EMPLOYEE_NUMBER,
          last_name NAME, salary SALARY
FROM employees;


--Top N analiza



--Cesta greska na ispitu, zaboravimo cesto rownum(onaj redoslijed koji racunar vraca)
SELECT ROWNUM, a.*
FROM (SELECT ROWNUM interownum, last_name, first_name, salary
      FROM employees
      WHERE ROWNUM <= 10
      ORDER BY salary) a
WHERE ROWNUM < 6;



--napisati upit koji ce prikazati 2 pdjela sa najvecom prosjecnom platom
CREATE VIEW john as
(SELECT ROWNUM rb, a.*
FROM(SELECT department_id, Round(Avg(salary), 2) pros_plata
     FROM employees
     GROUP BY department_id
     ORDER BY 2 DESC ) a
WHERE ROWNUM < 3);

SELECT * FROM john

-- mora imati alijas za rownum, jer je to kljucna rijec
--ROWNUM daje jedinstveni broj, i ne smije se pojaviti u unutrasnjem upitu



SELECT * FROM dba_users;

GRANT SELECT ON hr.john TO g1; -- dodjela prava za pristup



--Sekvence




