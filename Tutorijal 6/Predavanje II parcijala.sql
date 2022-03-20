
--Predavanje 1, parcijala 2

--EXISTS, vraca true ili false, za svaki slog

SELECT d.department_id,
       d.department_name
FROM departments d
WHERE NOT EXISTS( SELECT 'X'
                  FROM employees t
                  WHERE t.department_id = d.department_id );


DELETE FROM...

--WITH klauzula, postoji samo za oracle db


--Povezani upitii

--LEVEL -pseudo kolona


SELECT * FROM user_times;

SELECT Round(Sum( Nvl(active_minutes, 0) )/60, 3) "Radni sati"
FROM user_times;



SELECT * FROM employees;