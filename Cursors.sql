
BEGIN
   FOR tbl_rec IN (
        SELECT id, nazwa FROM tbl)
   LOOP
      dbms_output.put_line (tbl_rec.nazwa);
   END LOOP;
END;
---------------
DECLARE
--x tbl.id%TYPE;
--y tbl.nazwa%TYPE;
x NUMBER;
y VARCHAR2(20);

CURSOR dummy_cursor IS
 SELECT id, nazwa FROM tbl;

BEGIN
OPEN dummy_cursor;
    LOOP
        FETCH dummy_cursor INTO x, y;
        EXIT WHEN dummy_cursor%NOTFOUND;
        dbms_output.put_line(x||'-'||y);
    END LOOP;
CLOSE dummy_cursor;
END;
---------------
CREATE OR REPLACE PROCEDURE proc_cursor(i IN NUMBER) AS
--x tbl.id%TYPE;
--y tbl.nazwa%TYPE;
x NUMBER;
y VARCHAR2(20);
z NUMBER := 100;

CURSOR dummy_cursor IS
 SELECT id, nazwa FROM tbl WHERE id = i;
 
row_tbl dummy_cursor%ROWTYPE;

BEGIN
OPEN dummy_cursor;
    LOOP
        FETCH dummy_cursor INTO row_tbl;
        EXIT WHEN dummy_cursor%NOTFOUND;
        x := row_tbl.id;
        y := row_tbl.nazwa;
        dbms_output.put_line(x||'-'||y);
    END LOOP;
CLOSE dummy_cursor;
END;
---
EXEC proc_cursor(1);
---------------
DECLARE
TYPE kolekcja IS VARRAY(10) OF INTEGER;
x kolekcja := kolekcja(1,2,3,4,5,6,7,8,9,10);
BEGIN
FOR i IN 1..10 LOOP
      dbms_output.put_line('Element kolekcji: '||x(i));
    END LOOP;
END;
---------------
DECLARE
TYPE kolekcja IS VARRAY(10) OF INTEGER;
x kolekcja := kolekcja();
BEGIN
FOR i IN 1..10 LOOP
    x.EXTEND;
    x(i):=i*10;
      dbms_output.put_line('Element kolekcji: '||x(i));
    x(i):=NULL;
    END LOOP;
END;
---------------
DECLARE
TYPE asso IS TABLE OF VARCHAR2(20)
INDEX BY binary_integer;
x asso;
BEGIN
FOR i IN 1..10 LOOP
    x(i):='Dodałem element: '||i;
      dbms_output.put_line(x(i));
    END LOOP;
END;
---------------
---CREATE OR REPLACE TYPE kolekt IS TABLE OF CHAR;

DECLARE
x kolekt := kolekt('a','b','c','d');
BEGIN
    dbms_output.put_line(CARDINALITY(x));
    dbms_output.put_line(x.count);    
    IF 'a' MEMBER OF x THEN
        dbms_output.put_line('Należy do kolekcji');
    ELSE
        dbms_output.put_line('Nie należy do kolekcji');
    END IF;
    dbms_output.put_line(x.first);
    dbms_output.put_line(x.last); 
END;