SET SERVEROUTPUT ON;
---------------
DECLARE
a INTEGER := 25;
b INTEGER;
BEGIN
---
b := a mod 10;
SYS.dbms_output.put_line('Pierwszy program w Oracle PL/SQL.');
SYS.dbms_output.put_line(TO_CHAR(1234, '$999999.99'));
---
IF b in (0) THEN
    dbms_output.put_line('Zmienna b jest równa zero');
    ELSE
    dbms_output.put_line('Zmienna b jest równa '||b);
END IF;
---
CASE WHEN b in (0) THEN dbms_output.put_line('Zmienna b jest równa zero');
ELSE dbms_output.put_line('Zmienna b jest równa '||b);
END CASE;
---
a:=1;
LOOP
    dbms_output.put_line('#'||a);
     a:=a+1;
    IF a = 5 THEN
        EXIT;
    END IF;
  END LOOP;
---
a:=1;
LOOP
    dbms_output.put_line('@'||a);
    a:=a+1;
    EXIT WHEN a=5;
  END LOOP;
---
FOR i IN 1..4 LOOP
      dbms_output.put_line('$'||i);
    END LOOP;
---
END;
---------------
CREATE OR REPLACE PROCEDURE pierwsza_procedura
IS
BEGIN
dbms_output.put_line('Uruchomiono prawidłowo');
END;
---
EXEC pierwsza_procedura;
---
CREATE OR REPLACE PROCEDURE przemnoz(x IN NUMBER, y IN OUT NUMBER)
IS
BEGIN
y:= x * x;
END;
---
DECLARE
a INTEGER := 10;
b INTEGER;
BEGIN
przemnoz(a,b);
dbms_output.put_line(b);
END;
---
CREATE OR REPLACE FUNCTION pierwsza_fun(x IN NUMBER)
RETURN NUMBER 
IS
wynik NUMBER := 0;
BEGIN
SELECT 1+1 + x INTO wynik FROM dual;
RETURN wynik;
END;
---
SELECT pierwsza_fun(5) as pierwsza_fun FROM dual;
---
CREATE OR REPLACE FUNCTION zwrot_var(x IN NUMBER)
RETURN varchar 
IS
wynik varchar(20);
BEGIN
SELECT CAST(val+x AS varchar(20))  INTO wynik FROM mytable WHERE ROWNUM = 1;
RETURN wynik;
END;
---
SELECT zwrot_var(1) as zwrot_var FROM dual;
---------------
CREATE OR REPLACE PACKAGE paczka
IS
PROCEDURE przemnoz(x IN NUMBER, y IN OUT NUMBER);
FUNCTION pierwsza_fun(x IN NUMBER) RETURN NUMBER;
END;
---
CREATE OR REPLACE PACKAGE BODY paczka
IS
PROCEDURE przemnoz(x IN NUMBER, y IN OUT NUMBER)
    IS
    BEGIN
        y:= x * x;
    END;

FUNCTION pierwsza_fun(x IN NUMBER)
    RETURN NUMBER 
    IS
        wynik NUMBER := 0;
    BEGIN
        SELECT 1+1 + x INTO wynik FROM dual;
    RETURN wynik;
    END;
END;
---
SELECT paczka.pierwsza_fun(1) as zwrot_var FROM dual;
---------------
CREATE OR REPLACE TRIGGER create_table_trigger
  AFTER CREATE ON SCHEMA
BEGIN
  IF SYS.DICTIONARY_OBJ_TYPE = 'TABLE' THEN
    dbms_output.put_line('Utworzono tabelę.');
  END IF;
END;
---
CREATE TABLE tbl (id NUMBER);
---------------
CREATE TABLE tbl (id NUMBER, nazwa VARCHAR2(20));
---
CREATE OR REPLACE TRIGGER data_change
BEFORE INSERT OR UPDATE ON tbl
FOR EACH ROW
WHEN (REGEXP_LIKE(NEW.nazwa,'-'))
BEGIN
  :NEW.nazwa := REGEXP_REPLACE(:NEW.nazwa,'-','###');
  dbms_output.put_line('Insert zmieniony');
END;
---
INSERT INTO tbl (id, nazwa) VALUES (1, '-@-');
COMMIT;
---------------
CREATE OR REPLACE TRIGGER tbl_on_insert_compound
FOR INSERT ON tbl
COMPOUND TRIGGER
BEFORE EACH ROW IS
BEGIN
dbms_output.put_line('Doing before...');
END BEFORE EACH ROW;
AFTER EACH ROW IS
BEGIN
dbms_output.put_line('Doing after...');
END AFTER EACH ROW;
END;
---
INSERT INTO tbl (id, nazwa) VALUES (1, '-#-');
COMMIT;
---------------
CREATE OR REPLACE TRIGGER data_change_fun_dml
AFTER INSERT OR UPDATE OR DELETE ON tbl
FOR EACH ROW
BEGIN
IF INSERTING THEN
dbms_output.put_line('Inserting row');
ELSIF UPDATING THEN
dbms_output.put_line('Updating row');
ELSIF DELETING THEN
dbms_output.put_line('Deleting row');
END IF;
END;
---
INSERT INTO tbl (id, nazwa) VALUES (1, '-$-');
COMMIT;
---------------
CREATE OR REPLACE TRIGGER system_trigger
AFTER LOGON ON DATABASE
BEGIN
INSERT INTO customers (time_of_day) VALUES (systimestamp); 
END;
---------------
CREATE OR REPLACE TYPE nazwisko AS VARRAY(2) OF VARCHAR2(30);

CREATE TABLE a1 (id number, dane nazwisko);

DESCRIB a1;

INSERT INTO a1 VALUES (1, nazwisko('Malinowski', 'Kowalski'));

SELECT * FROM a1;
---------------
DECLARE
a VARCHAR2(3);
BEGIN
a := 'sto1';
dbms_output.put_line('Zmienna a jest równa '||a);
EXCEPTION
      WHEN VALUE_ERROR THEN
        dbms_output.put_line('Wpisano nieprawidłową wartość');
END;
---------------
DECLARE
x NUMBER;
e EXCEPTION;
BEGIN
x := 102;
IF x>100 THEN RAISE e;
ELSE
dbms_output.put_line('Kod wykonuje się poprawnie '||x);
END IF;
-- OTHERS - obsługa wszelkich błędów
EXCEPTION WHEN OTHERS THEN
        dbms_output.put_line('Zmienna X nie może być większa niż 100');
END;