--session B

use labprof9 -- da ti se obavlja nad bazom labprof8
set context_info 7; -- da ti oni njihovi pomocni upiti rade
select @@spid -- id sjednice

--2.1. zadatak
SET LOCK_TIMEOUT -1; 
BEGIN TRANSACTION;
SET DEADLOCK_PRIORITY HIGH; -- 2.2. ZADATAK
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT mjera FROM test WHERE sifra = 4;

UPDATE test SET mjera = 100 WHERE sifra = 9; --čeka na A

ROLLBACK TRANSACTION;

SELECT * FROM test;


--3. zadatak
SET LOCK_TIMEOUT -1; 
BEGIN TRANSACTION;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT mjera FROM test WHERE sifra = 5;
SELECT mjera FROM test WHERE sifra = 12;
SELECT mjera FROM test WHERE sifra = 17;

UPDATE test SET mjera = 100 WHERE sifra = 5;

ROLLBACK TRANSACTION;


--4. zadatak
SET LOCK_TIMEOUT -1; 
BEGIN TRANSACTION;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

UPDATE test SET mjera = 100 WHERE sifra = 3;

UPDATE test SET mjera = 100 WHERE sifra = 9;

ROLLBACK TRANSACTION;
