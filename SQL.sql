ALTER SESSION SET NLS_DATE_FORMAT = 'YYYY-MM-DD';
ALTER SESSION SET NLS_TIMESTAMP_FORMAT = 'YYYY-MM-DD HH24:MI:SS';

WITH 
    dwa_lata AS (SELECT TO_CHAR(ADD_MONTHS( SYSDATE, 0), 'YYYY') AS "ROK" FROM DUAL
    UNION ALL SELECT TO_CHAR(ADD_MONTHS( SYSDATE, -12), 'YYYY') FROM DUAL)
SELECT
*
FROM dwa_lata;


DEFINE TEXT = "ONE TWO THREE"
DEFINE DEPARTMENT_ID = 20
SELECT '&TEXT' as TEXT, &DEPARTMENT_ID as DEPARTMENT FROM dual;

SELECT lp, kolumna FROM
(SELECT 1 as lp, null as kolumna from dual
union
SELECT 2 as lp, '' as kolumna from dual)
WHERE kolumna IS NULL;

SELECT pos FROM (
    SELECT LEVEL POS FROM dual CONNECT BY LEVEL <= 20)
WHERE pos BETWEEN 3 AND 12;

SELECT pos FROM (
    SELECT LEVEL POS FROM dual CONNECT BY LEVEL <= 20)
WHERE pos ^= ALL(2, 4, 6, 8, 12);

SELECT pos FROM (
    SELECT LEVEL POS FROM dual CONNECT BY LEVEL <= 20)
WHERE pos = ANY(2, 4, 6, 8, 12);

SELECT pos, val FROM (
SELECT pos,
CASE WHEN pos < 10 THEN pos ELSE NULL END AS val FROM (
    SELECT LEVEL POS FROM dual CONNECT BY LEVEL <= 20))
WHERE val <> 5;

SELECT pos, val FROM (
SELECT pos,
CASE WHEN pos < 10 THEN pos ELSE NULL END AS val FROM (
    SELECT LEVEL POS FROM dual CONNECT BY LEVEL <= 20))
WHERE COALESCE(val, 0) <> 5;

WITH 
    tabela AS (SELECT LEVEL POS FROM dual CONNECT BY LEVEL <= 20)
SELECT
*
FROM tabela a
WHERE NOT EXISTS (SELECT *
                  FROM tabela b
                  WHERE a.pos = b.pos
                    AND b.pos <= 10);
                    
                    
WITH 
    tabela AS (SELECT LEVEL POS FROM dual CONNECT BY LEVEL <= 20)
SELECT
a.pos,
ROW_NUMBER() OVER(ORDER BY a.pos) num,
RANK() OVER(ORDER BY a.pos desc) rnk 
FROM tabela a
ORDER BY a.pos;

SELECT TO_DATE('2022-09-08','YYYY-MM_DD') + ROWNUM -1 AS TECH_REPO_DATE
FROM all_objects
WHERE ROWNUM <= TO_DATE('2022-09-27','YYYY-MM_DD')-TO_DATE('2022-09-08','YYYY-MM_DD')+1;

SELECT 
rownum as lp
, trunc(add_months(sysdate, -rownum), 'MONTH') as start_dt
, last_day(trunc(add_months(sysdate, -rownum), 'MONTH')) as end_dt
FROM DUAL
CONNECT BY rownum <= 24;

SELECT grupa
, LISTAGG(code, ', ') WITHIN GROUP (ORDER BY code DESC) as "Code_Listing"
FROM
(SELECT pos
, case when pos <= 10 then 1 else 2 end AS GRUPA
, CHR(pos+64) as CODE
FROM (
    SELECT LEVEL POS FROM dual CONNECT BY LEVEL <= 20)
WHERE pos BETWEEN 3 AND 15)
GROUP BY grupa;

SELECT TRANSLATE('1tech23', '123', '456') as TRANSLATE
, REPLACE('00  00 123 456', ' ', '') as REPLACE
, COALESCE(NULL, NULL, 0) as COALESCE
, GREATEST(5, 18, 21, 3, 65) AS GREATEST
, LEAST(5, 18, 21, 3, 65) AS LEAST
, TO_NUMBER('1210,73') as TO_NUMBER
, TO_CHAR(21, '000099') as TO_CHAR1
, TO_CHAR('21', '000099') as TO_CHAR2
FROM dual;
        

SELECT sysdate, Trunc(sysdate), current_date FROM dual;
SELECT DATE '2018-01-25', TO_DATE('25-01-2020', 'DD-MM-YYYY'), TIMESTAMP '2018-01-25 01:23:45' FROM dual;

SELECT ADD_MONTHS(current_date, -1) as ADD_MONTHS
, EXTRACT(YEAR FROM current_date) as EXTRACT
, LAST_DAY(current_date) as LAST_DAY
, TRUNC(current_date) as TRUNC
, current_date+3 as ADD_DAYS
, MONTHS_BETWEEN(current_date+31, current_date) as MONTHS_BETWEEN
FROM dual;

SELECT TO_CHAR(LAST_DAY(ADD_MONTHS(TRUNC(sysdate)+17/48,-1))+1,'YYYY-MM-DD HH24:MI:SS') FROM dual;

WITH 
    datatable AS (
    SELECT 'FALL 2014' as data FROM dual
    UNION
    SELECT '2014 CODE-B' as data FROM dual
    UNION
    SELECT 'CODE-A 2014 CODE-D' as data FROM dual
    UNION
    SELECT 'ADSHLHSALK' as data FROM dual
    UNION
    SELECT 'FALL 2004' as data FROM dual
    UNION
    SELECT 'ArtADB123e9876540' as data FROM dual   
    )
SELECT data
, TO_NUMBER(REGEXP_SUBSTR(data, '\d{4}+')) as digits4
, TO_NUMBER(REGEXP_SUBSTR(data, '[0-9]+', 1, 1)) as digits_part1
, TO_NUMBER(REGEXP_SUBSTR(data, '[0-9]+', 1, 2)) as digits_part2
, REGEXP_REPLACE(data, '[^0-9]+', '') as REGEXP_REPLACE
, REGEXP_SUBSTR(data, '[A-Z][a-z]+', 1, 1) as REGEXP_SUBSTR
FROM datatable;

--drop table mytable;
create table mytable (ID Number(5) Primary Key, Val Number(5), Kind Number(5));

insert into mytable values (1,1337,2);
insert into mytable values (2,1337,1);
insert into mytable values (3,3,4);
insert into mytable values (4,3,4);
commit work;

SELECT ROWNUM as row_num, t.* 
FROM
(SELECT Id, Val, Kind FROM mytable
ORDER BY id DESC) t;

SELECT Id, Val, Kind, rk FROM
(
   SELECT t.Id, t.Val, t.Kind, ROW_NUMBER() OVER (PARTITION BY t.Val ORDER BY t.Id desc) AS rk
   FROM mytable t
) WHERE rk = 1;

CREATE SEQUENCE supplier_seq
  MINVALUE 0
  START WITH 10
  INCREMENT BY 1
  CACHE 20;
  
SELECT supplier_seq.NEXTVAL FROM dual;

SELECT INDEX_NAME, TABLE_OWNER, TABLE_NAME, UNIQUENESS FROM ALL_INDEXES;

EXPLAIN PLAN FOR
SELECT * FROM dual;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);


select col.column_id, 
       col.owner as schema_name,
       col.table_name, 
       col.column_name, 
       col.data_type, 
       col.data_length, 
       col.data_precision, 
       col.data_scale, 
       col.nullable,
       c.comments
from sys.all_tab_columns col
inner join sys.all_tables t on col.owner = t.owner 
                              and col.table_name = t.table_name
left join sys.all_col_comments c on col.owner = c.owner 
                              and col.table_name = c.table_name
                              and col.column_name = c.column_name
where col.owner = 'DM_CRM'
---and col.table_name = 'AP_INVOICES_ALL'
order by col.owner, col.table_name, col.column_id;


select col.column_id, 
       col.owner as schema_name,
       col.table_name, 
       col.column_name, 
       col.data_type, 
       col.data_length, 
       col.data_precision, 
       col.data_scale, 
       col.nullable
from sys.all_tab_columns col
inner join sys.all_views v on col.owner = v.owner 
                              and col.table_name = v.view_name
where col.owner = 'DM_CRM'
order by col.owner, col.table_name, col.column_id;
