CREATE SEQUENCE customers_seq START WITH 1
INCREMENT BY 1 CACHE 20 NOCYCLE;

CREATE TABLE customers (
id NUMBER(10) NOT NULL,
description  VARCHAR2(50),
time_of_day TIMESTAMP,
CONSTRAINT customers_pk PRIMARY KEY (id));

CREATE OR REPLACE TRIGGER customers_on_insert
  BEFORE INSERT ON customers
  FOR EACH ROW
BEGIN
  SELECT customers_seq.nextval
  INTO :new.id
  FROM dual;
END;


DECLARE
    process_name VARCHAR2( 100 ) := 'Oracle Scheduler';
BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
   job_name           =>  'plsql_program',
   job_type           =>  'PLSQL_BLOCK',
   job_action         =>  'BEGIN INSERT INTO customers (description, time_of_day) VALUES (process_name, current_timestamp); END;',
   start_date         =>  SYSTIMESTAMP,
   repeat_interval    =>  'FREQ=MINUTELY; INTERVAL=1;',
   end_date           =>  SYSTIMESTAMP + INTERVAL '1' day,
   auto_drop          =>   FALSE,
   comments           =>  'Every 1 minutes');
END;


BEGIN
  DBMS_SCHEDULER.enable (name=>'plsql_program');
END;
----

SELECT * FROM USER_SCHEDULER_JOBS;
SELECT * FROM USER_SCHEDULER_JOB_RUN_DETAILS;

----

BEGIN
  DBMS_SCHEDULER.disable (name=>'plsql_program');
END;

BEGIN
  DBMS_SCHEDULER.drop_job (job_name=>'plsql_program');
END;