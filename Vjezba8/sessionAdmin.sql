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

--2. zadSET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

SELECT request_session_id AS sid
 , CASE WHEN request_mode = 'U' THEN 'S' ELSE request_mode END AS lock_type
 , test.sifra
 FROM sys.dm_tran_locks
 LEFT OUTER JOIN test
 ON sys.fn_PhysLocFormatter(%%physloc%%) = '(' + TRIM(resource_description) + ')'
 WHERE resource_type = 'RID'
 AND request_status = 'GRANT'
 AND request_session_id IN (SELECT session_id FROM sys.dm_exec_sessions where CAST(context_info AS INT) = 7); --3. zad IF OBJECT_ID('proc3') IS NOT NULL DROP PROCEDURE proc3
 CREATE PROCEDURE proc3 @sifra INTEGER AS	BEGIN TRANSACTION	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;	BEGIN TRY	--test		SET LOCK_TIMEOUT -1; 		UPDATE test SET mjera = mjera * 1.1 WHERE test.sifra = @sifra;	--test2		SET LOCK_TIMEOUT 5000; 		UPDATE test2 SET mjera = mjera * 1.1 WHERE test2.sifra = @sifra;			--test3		SET LOCK_TIMEOUT 0;		UPDATE test3 SET mjera = mjera * 1.1 WHERE test3.sifra = @sifra;	END TRY	BEGIN CATCH		ROLLBACK TRANSACTION				IF (ERROR_MESSAGE() LIKE '%Lock%')			THROW 50501, 'Privremeno zaključano, pokušajte kasnije', 1;		ELSE			THROW	END CATCHCOMMIT TRANSACTIONGOEXEC dbo.proc3 @sifra = 2;SELECT * FROM test;SELECT * FROM test2;SELECT * FROM test3;UPDATE test SET mjera=20 where sifra =2