
CREATE OR REPLACE FUNCTION get_sal
 (lv_id IN employees.employee_id%TYPE )

 RETURN NUMBER

IS
  v_salary employees.salary%TYPE := 0;
BEGIN

    SELECT e.salary
    INTO v_salary
    FROM employees e
    WHERE e.employee_id = lv_id;
    RETURN( v_salary );
END get_sal;
/

START get_salary.sql;
VARIABLE G_SALARY NUMBER
EXECUTE :g_salary := get_sal(199);

SELECT :g_salary, sysdate
FROM dual;

DROP FUNCTION get_sal;




--Primjer sa predavanja
CREATE OR REPLACE FUNCTION gStaz ( pid IN OUT NUMBER )
     RETURN NUMBER IS
CURSOR c IS
         SELECT Months_Between(SYSDATE, hire_date)
         FROM employees
         WHERE employee_id = pid;

lv_m NUMBER;
lv_y NUMBER;

BEGIN
    OPEN c;
    FETCH c INTO lv_m;
    IF(c%FOUND) THEN
       lv_y := Trunc(lv_m/12);
       lv_m := Round(Mod(lv_m,12));
    ELSE
       lv_m := 0;
       lv_y := 0;
    END IF;
    CLOSE c;

    pid := lv_m;
    RETURN lv_y;

END gStaz;
/

VARIABLE v_m NUMBER
VARIABLE v_y NUMBER
EXECUTE :v_m := 198;
EXECUTE :v_y := gStaz(:v_m);

SELECT :v_y, :v_m
FROM dual;

SELECT * FROM employees;



