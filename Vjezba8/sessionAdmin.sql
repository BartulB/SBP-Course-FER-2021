--session Admin

use labprof8 -- da ti se obavlja nad bazom labprof8
set context_info 7; -- da ti oni njihovi pomocni upiti rade
select @@spid -- id sjednice


--1.2.
SELECT session_id, login_time, DB_NAME(database_id) AS DB
FROM sys.dm_exec_sessions

--1.3.
SELECT session_id, login_time, DB_NAME(database_id) AS DB
FROM sys.dm_exec_sessions
WHERE CONTEXT_INFO = 7;

--2. zad

SELECT request_session_id AS sid
 , CASE WHEN request_mode = 'U' THEN 'S' ELSE request_mode END AS lock_type
 , test.sifra
 FROM sys.dm_tran_locks
 LEFT OUTER JOIN test
 ON sys.fn_PhysLocFormatter(%%physloc%%) = '(' + TRIM(resource_description) + ')'
 WHERE resource_type = 'RID'
 AND request_status = 'GRANT'
 AND request_session_id IN (SELECT session_id FROM sys.dm_exec_sessions where CAST(context_info AS INT) = 7);
