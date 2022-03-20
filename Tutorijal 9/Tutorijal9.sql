SELECT * FROM all_triggers;
SELECT * FROM user_triggers;

--Prijer sa predavanja
DROP TABLE tbl;
CREATE TABLE tbl (id NUMBER PRIMARY KEY,
                  name VARCHAR2(30),
                  datum DATE,
                  suser CHAR(10) DEFAULT USER,
                  sdat DATE DEFAULT SYSDATE,
                  auser CHAR(10) DEFAULT USER,
                  adat DATE DEFAULT SYSDATE,
                  note VARCHAR2(256) );
                  --auser-prvi korisnik koji je napravio update

INSERT INTO tbl(id, name, datum)
       VALUES ('1', 'Emir', Trunc(sysdate));

INSERT INTO tbl(id, name, datum, suser, sdat, auser, adat)
       VALUES ('-1', 'Emir', SYSDATE-1, USER, SYSDATE-1, 'MA12345', SYSDATE-2);


SELECT * FROM tbl;

CREATE OR REPLACE TRIGGER updTBL
BEFORE INSERT ON tbl
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE lv_id NUMBER;
BEGIN
   SELECT Max( Nvl(id, 0) + 1 ) INTO lv_id FROM tbl;
   :new.id := lv_id;
   :new.suser := USER;
   :new.sdat := SYSDATE;
   :new.auser := USER;
   :new.adat := SYSDATE;
   :new.note := 'Slog ubacen u bazu ' || To_Char(SYSDATE);
END;

INSERT INTO tbl(id, name, datum, suser, sdat, auser, adat)
       VALUES ('-2', 'Mujo', SYSDATE-3, USER, SYSDATE-3, 'MA12345', SYSDATE-5);

SELECT * FROM tbl;

--Primjeri Tutorijal
CREATE OR REPLACE TRIGGER Provjera
AFTER INSERT OR DELETE ON Rente
DECLARE sek NUMBER(1)
BEGIN
SELECT testsek.NEXTVAL INTO sek FROM dual;
END;

CREATE TRIGGER Provjera2
BEFORE UPDATE OF Cijena ON Auta
REFERENCING NEW AS NEW AS NEW OLD AS OLD
FOR EACH ROW WHEN(NEW.cijena > OLD.cijena)
BEGIN
   Raise_Application_Error (-)
END;


--Z1
DROP TABLE zap;
CREATE TABLE zap AS
       SELECT e.employee_id "SIFRA_ZAPOSLENOG",
              e.first_name || ' ' || e.last_name "NAZIV_ZAPOSLENOG",
              d.department_name "NAZIV_ODJELA",
              j.job_id "SIFRA_POSLA",
              j.job_title "NAZIV_POSLA",
              e.salary PLATA,
              e.salary*(Nvl(e.commission_pct, 0)) "DODATAK_NA_PLATU"
       FROM employees e, departments d, jobs j
       WHERE e.department_id = d.department_id
         AND e.job_id = j.job_id;

ALTER TABLE zap ADD (Sifra NUMBER );

DROP SEQUENCE Zap_pk;
CREATE SEQUENCE Zap_pk
INCREMENT BY 1
START WITH 1
MAXVALUE 10000
NOCACHE
NOCYCLE;

UPDATE zap
SET sifra = zap_pk.NEXTVAL;

ALTER TABLE zap ADD CONSTRAINT c_zap_p_k PRIMARY KEY(Sifra);

SELECT * FROM zap;


--Raise error (20000-20999)
CREATE OR REPLACE TRIGGER updZAP
BEFORE UPDATE ON zap
REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE lv_god NUMBER(5);
BEGIN
  SELECT To_Char(e.hire_date, 'YYYY') INTO lv_god FROM employees e, zap z WHERE e.employee_id = z.sifra_zaposlenog AND :OLD.sifra_zaposlenog = z.sifra_zaposlenog;
  IF lv_god > 2001  THEN
    Raise_Application_Error(-20500, 'Nije moguce mijenjati podatke zaposlenika koji su zaposleni nakon 2001 godine.');
  END IF;
END;

SELECT * FROM employees WHERE To_Char(hire_date, 'YYYY') LIKE '2001';

UPDATE zap
SET plata = plata + 100
WHERE sifra_zaposlenog = (SELECT employee_id
                          FROM employees
                          WHERE To_Char(hire_date, 'YYYY') = 2001);

SELECT sifra_zaposlenog, e.salary, z.plata
FROM employees e, zap z
WHERE e.employee_id = z.sifra_zaposlenog;

--Z2
CREATE OR REPLACE TRIGGER zapTime
BEFORE INSERT OR UPDATE OR DELETE ON zap
BEGIN
    IF( To_Char(SYSDATE, 'DY') IN ('MON', 'TUE', 'WED', 'THU', 'FRI') AND (To_Char(SYSDATE, 'HH24:mi') BETWEEN '16:23' AND '23:16') ) THEN
       Raise_Application_Error(-20500, 'Nije moguce mijenjati podatke zaposlenika radnim danima u terminu 16:23 do 23:16!!!');
    ELSIF( To_Char(SYSDATE, 'DY') IN ('SUN', 'SAT') AND (To_Char(SYSDATE, 'HH24:mi') BETWEEN  '06:34'  AND '23:56') ) then
       Raise_Application_Error(-20500, 'Nije moguce mijenjati podatke zaposlenika vikendom u terminu 06:34 do 23:56!!!');
    END IF;
END;

UPDATE zap
SET plata = plata + 100;

--Z3
DROP TRIGGER zapTime;
DROP TRIGGER updZap;

ALTER TABLE zap ADD ( suser CHAR(10),
                      sdat DATE );

CREATE OR REPLACE TRIGGER zapUPD
BEFORE UPDATE ON zap
REFERENCES NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
  :new.sifra_zaposlenog := :old.sifra_zaposlenog;
  :new.naziv_zaposlenog := :old.naziv_zaposlenog;
  :new.naziv_odjela := :old.naziv_odjela;
  :new.sifra_posla := :old.sifra_posla;
  :new.naziv_posla := :old.naziv_posla;
  :new.plata := :old.plata;
  :new.dodatak_na_platu := :old.dodatak_na_platu;
  :new.suser := USER;
  :new.sdat := SYSDATE;
END;

UPDATE zap
SET plata = plata + 1000
WHERE sifra_zaposlenog = 200
OR sifra_zaposlenog = 202 ;

SELECT * FROM zap;

--Z4
CREATE TABLE odj (department_id NUMBER,
                  department_name VARCHAR2(50),
                  manager_id NUMBER,
                  location_id NUMBER,
                  id NUMBER,
                  korisnik CHAR(10),
                  datum DATE,
                  CONSTRAINT c_z4_odj_pk PRIMARY KEY (id)  );

CREATE TABLE pos ( job_id CHAR(10),
                   job_title VARCHAR2(50),
                   min_salary NUMBER,
                   max_salary NUMBER,
                   id CHAR(15),
                   korisnik CHAR(10),
                   datum DATE,
                   CONSTRAINT c_z4_pos_pk PRIMARY KEY (id) );


ALTER TABLE zap ADD ( odj_id NUMBER,
                      pos_id CHAR(15));

ALTER TABLE zap ADD CONSTRAINT c_zap_odj_fk FOREIGN KEY (odj_id) REFERENCES odj(id);
ALTER TABLE zap ADD CONSTRAINT c_zap_pos_fk FOREIGN KEY (pos_id) REFERENCES pos(id);

CREATE SEQUENCE z4_odj_seq
START WITH 1
MAXVALUE 200
MINVALUE 1
NOCYCLE
NOCACHE;

CREATE OR REPLACE TRIGGER odjADM
BEFORE INSERT OR UPDATE ON odj
REFERENCES NEW AS NEW
FOR EACH ROW
BEGIN
  :new.id := z4_odj_seq.NEXTVAL;
  :new.korisnik := USER;
  :new.datum := SYSDATE;
END;

CREATE SEQUENCE z4_pos_seq
START WITH 1
MAXVALUE 200
MINVALUE 1
NOCYCLE
NOCACHE;

CREATE OR REPLACE TRIGGER z4_trig_pos
BEFORE INSERT ON pos
REFERENCES NEW AS NEW OLD AS OLD
FOR EACH ROW
BEGIN
  :new.id := z4_seq.NEXTVAL;
  :new.korisnik := USER;
  :new.datum := SYSDATE;
END;


--Z5
CREATE OR REPLACE TRIGGER odjADM
BEFORE INSERT OR UPDATE ON odj
FOR EACH ROW
DECLARE lv_provjera NUMBER;
BEGIN
  lv_provjera := (SELECT z.sifra_zaposlenog
                  FROM zap z
                  WHERE z.sifra_zaposlenog =     (SELECT o.manager_id
                                                  FROM odj o
                                                  GROUP BY o.manager_id
                                                  HAVING Count(o.manager_id) = (SELECT Min( Count(o.manager_id) )
                                                                                FROM odj o
                                                                                GROUP BY o.manager_id);            ) );
  :new.id := z4_odj_seq.NEXTVAL;
  :new.korisnik := USER;
  :new.datum := SYSDATE;

  IF lv_provjera != NULL THEN
     :new.manager_id := lv_provjera;
  ELSE
     :new.manager_id := 102;
  END IF;
END;

SELECT * FROM zap;
SELECT * FROM odj;
