--PREDAVANJA
--pogledi
-- -(Top N analiza)
SELECT ROWNUM AS Rank, ename, sal
FROM (SELECT e.last_name ename, e.salary sal
      FROM employees e
      ORDER BY e.salary DESC)
WHERE ROWNUM <= 3;

--sequence
SELECT sequence_name, min_value, max_value,increment_by, last_number
FROM user_sequences;

--LAST_NUMBER kolona prikazuje sljedeci raspoloživi broj sekvence

