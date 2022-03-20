DROP TABLE zaposleni;
CREATE TABLE zaposleni ( sifra_zaposlenog,
                         naziv_zaposlenog,
                         plata,
                         sifta_odjela,
                         naziv_odjela,
                         sifra_posla,
                         naziv_posla) AS SELECT e.employee_id,
                                                e.last_name || '' || e.first_name,
                                                e.salary,
                                                d.department_id,
                                                d.department_id,
                                                j.job_id,
                                                j.job_title
                                         FROM employees e, departments d, jobs j
                                         WHERE e.department_id = d.department_id
                                           AND e.job_id = j.job_id
                                           AND e.commission_pct IS NOT NULL;


SELECT * FROM zaposleni;


--Zadatak 1
CREATE TABLE odjeli ( Id        VARCHAR2(25) NOT NULL,
                      Naziv     VARCHAR2(10) NOT NULL,
                      Opis      CHAR(15),
                      Datum     DATE NOT NULL,
                      Korisnik  VARCHAR2(30) NOT NULL,
                      Napomena  VARCHAR2(10) );

SELECT * FROM odjeli;

--Zadatak 2
DESC departments;
INSERT INTO odjeli( Id, naziv, datum, korisnik )
       SELECT To_Char(department_id), SubStr(department_name, 1, 10), SYSDATE, USER
       FROM departments;

SELECT * FROM odjeli;

--Zadatak 3
ALTER TABLE odjeli ADD ( sef_id NUMBER(6),
                         mjesto_id NUMBER(4) );

UPDATE odjeli o
SET (sef_id, mjesto_id ) = ( SELECT d.manager_id, d.location_id
                             FROM departments d
                             WHERE To_Char(d.department_id) = o.id );

SELECT * FROM odjeli;

--Zadatak 4
CREATE TABLE zaposleni ( Id NUMBER(4) NOT NULL,
                         Sifra_zaposlenog VARCHAR2(5) NOT NULL,
                         Naziv_zaposlenog CHAR(50),
                         Godina_zaposlenja NUMBER(4) NOT NULL,
                         Mjesec_zaposlenja CHAR(2) NOT NULL,
                         Sifra_odjela VARCHAR2(5),
                         Naziv_odjela VARCHAR2(15) NOT NULL,
                         Grad CHAR(10) NOT NULL,
                         Sifra_posla VARCHAR2(25),
                         Naziv_posla CHAR(50) NOT NULL,
                         Iznos_dodatak_na_platu NUMBER(5),
                         Plata NUMBER(6) NOT NULL,
                         Kontinent VARCHAR2(20),
                         Datum_unosa DATE NOT NULL,
                         Korisnik_unio CHAR(20) NOT NULL);

SELECT * FROM zaposleni;

--Zadatak 5
Insert INTO zaposleni
                SELECT  1 , e.employee_id, SubStr(e.first_name || ' ' || e.last_name, 0, 50), To_Number(To_Char(e.hire_date, 'YYYY')), SubStr(To_Char(e.hire_date, 'MON'), 1, 2), SubStr(To_Char(d.department_id),1,5),
                        SubStr(To_Char(d.department_name),1,15), SubStr(l.city, 1, 10), SubStr(To_Char(j.job_id), 1, 25), SubStr(To_Char(j.job_title), 1, 50), Mod(e.salary*Nvl(e.commission_pct, 0), 100000),
                        Mod(e.salary, 1000000), SubStr(r.region_name, 1, 20), SYSDATE, SubStr(USER, 1, 20)
                FROM employees e, departments d, locations l, jobs j, countries c, regions r
                WHERE e.department_id = d.department_id
                  AND d.location_id = l.location_id
                  AND e.job_id = j.job_id
                  AND l.country_id = c.country_id
                  AND c.region_id = r.region_id;

SELECT * FROM zaposleni;

--Zadatak 6
CREATE TABLE zaposleni2 AS
       SELECT *
       FROM zaposleni;

SELECT * FROM zaposleni2;

--Zadatak 7
ALTER TABLE zaposleni2 ADD( odjel VARCHAR2(21),
                            zaposleni VARCHAR2(56),
                            posao VARCHAR2(76) );

UPDATE zaposleni2
SET odjel = sifra_odjela || ' ' || naziv_odjela,
    zaposleni = sifra_zaposlenog || ' ' || naziv_zaposlenog,
    posao = sifra_posla || ' ' || naziv_posla;

ALTER TABLE zaposleni2 SET unused(sifra_odjela, naziv_odjela, sifra_zaposlenog, naziv_zaposlenog, sifra_posla, naziv_posla);

ALTER TABLE zaposleni2 MODIFY ( odjel VARCHAR2(21) NOT NULL, zaposleni VARCHAR2(56) NOT NULL, posao VARCHAR2(76) NOT NULL );


--Zadatak 8
RENAME zaposleni2 TO zap_backup;

SELECT * FROM zap_backup;

--Zadatak 9
COMMENT ON TABLE odjeli IS 'Tabela sadrzi kolone tabele Departments(hr diagram), dopunjena kolonama potrebnim za administraciju.';

SELECT *
FROM user_tab_comments
WHERE Lower(table_name) LIKE 'odjeli%';


COMMENT ON TABLE zaposleni IS 'Tabela sadrzi kolone tabele Employees(hr diagram), dopunjena kolonama potrebnim za administraciju i detaljnijim informacijama vezanim za korisnika.'

SELECT *
FROM user_tab_comments
WHERE Lower(table_name) LIKE 'zaposleni%';


COMMENT ON TABLE zap_backup IS 'Tabela sadrzi beck up verziju tabele Zaposleni. U kojoj su udruzene sifre i nazivi kolona(vezanih za odjel, zaposlene i posao) u odnosu na tabelu Zaposleni';

SELECT *
FROM user_tab_comments
WHERE Lower(table_name) LIKE 'zap_backup%';

--Zadatak 10
COMMENT ON COLUMN odjeli.id IS 'Kolona koja jednoznacno odredjuje sve ostale atribute tabele.';
COMMENT ON COLUMN odjeli.naziv IS 'Kolona koja predstavlja naziv odjela.';
COMMENT ON COLUMN odjeli.opis IS 'Kolona koja predstavlja dodatni opis vezan za ovaj odjel.';
COMMENT ON COLUMN odjeli.datum IS 'Kolona koja predstavlja datum unosa odjela.';
COMMENT ON COLUMN odjeli.korisnik IS 'Kolona koja predstavlja nadimak korisnika koji je unieo odjel.';
COMMENT ON COLUMN odjeli.napomena IS 'Predstavlja napomenu koja je bitna informacija vezana za odjel.';
COMMENT ON COLUMN odjeli.sef_id IS 'Predstavlja jedinstvenu sifru uposlenika koji je sef tog odjela.';
COMMENT ON COLUMN odjeli.mjesto_id IS 'Predstavlja jedinstvenu sifru lokacije, pomocu koje mozemo doci do detaljnijih informacija o toj loaciji.';

SELECT *
FROM user_col_comments
WHERE Lower(table_name) LIKE 'odjeli';

--Zadatak 11
ALTER TABLE zap_beckup SET unused(datum_unosa, korisnik_unio);

SELECT * FROM zap_beckup;

--Zadatak 12
SELECT *
FROM user_tab_comments
WHERE Lower(table_name) LIKE 'odjeli'
   OR Lower(table_name) LIKE 'zaposleni';

SELECT *
FROM user_col_comments
WHERE Lower(table_name) LIKE 'odjeli'
   OR Lower(table_name) LIKE 'zaposleni';

--II nacin, sve skupa
SELECT c.*, t.*
FROM user_col_comments c, user_tab_comments t
WHERE c.table_name = t.table_name
  AND (Lower(c.table_name) LIKE 'odjeli'
   OR Lower(c.table_name) LIKE 'zaposleni');

--Zadatak 13
ALTER TABLE zaposleni DROP unused COLUMNS;
ALTER TABLE zap_backup DROP unused COLUMNS;

