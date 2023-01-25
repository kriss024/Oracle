sqlplus / as sysdba
SQL> connect SYS/oracle as sysdba;

SHOW con_name;
SHOW pdbs;
ALTER SESSION SET CONTAINER=<name of your pluggable database>;
SHOW con_name;

alter profile DEFAULT limit PASSWORD_REUSE_TIME unlimited;
alter profile DEFAULT limit PASSWORD_LIFE_TIME  unlimited;

CREATE USER test IDENTIFIED BY test DEFAULT TABLESPACE users TEMPORARY TABLESPACE temp PROFILE default;
GRANT CREATE SESSION TO test;
GRANT ALL PRIVILEGES TO test;

SELECT username, account_status, expiry_date FROM dba_users WHERE username='TEST';
SELECT username, account_status, default_tablespace, profile, authentication_type FROM  dba_users WHERE username='TEST';

GRANT CREATE SESSION, ALTER SESSION, CREATE DATABASE LINK,
  CREATE MATERIALIZED VIEW, CREATE PROCEDURE,
  CREATE PUBLIC SYNONYM, CREATE ROLE, CREATE SEQUENCE, 
  CREATE SYNONYM, CREATE TABLE,
  CREATE TRIGGER, CREATE TYPE, CREATE VIEW, 
  UNLIMITED TABLESPACE
  TO test;
  
DROP USER test CASCADE;

# Connect database with following setting:
# hostname: localhost
# port: 51521
# service_name: ORCLPDB1.localdomain
# username: test
# password: test

SQL> exit
cd $ORACLE_HOME/network/admin
cat tnsnames.ora
SERVICE_NAME: XEPDB1

sqlplus / as sysdba
SQL> connect SYS/oracle as sysdba;
shutdown immediate;
startup
exit