set serveroutput on
EXEC FILTER_POLAND_TABLE;

-- ******************************************************************

CREATE OR REPLACE PROCEDURE FILTER_POLAND_TABLE
IS
zmienna varchar2(255);

CURSOR C1 IS  SELECT "Email" FROM v_poland;

BEGIN

OPEN C1;

LOOP
    FETCH C1 INTO zmienna;
    EXIT WHEN C1%NOTFOUND;
    INSERT INTO student_courses (Email)
    values (zmienna);
    
END LOOP;

CLOSE C1;
 
END

