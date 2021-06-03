--session A

use labprof9 -- da ti se obavlja nad bazom labprof8
set context_info 7; -- da ti oni njihovi pomocni upiti rade
select @@spid -- id sjednice


--2.1. zadatak
SET LOCK_TIMEOUT -1; 
BEGIN TRANSACTION;
SET DEADLOCK_PRIORITY LOW; -- 2.2. ZADATAK
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT mjera FROM test WHERE sifra = 5;

UPDATE test SET mjera = 0 WHERE sifra = 8;
UPDATE test SET mjera = 0 WHERE sifra = 9;
UPDATE test SET mjera = 0 WHERE sifra = 10;
UPDATE test SET mjera = 0 WHERE sifra = 11;

UPDATE test SET mjera = 0 WHERE sifra = 4; --čeka na B - potpuni zastoj

ROLLBACK TRANSACTION;

SELECT * FROM test;


--3. zadatak
SET LOCK_TIMEOUT -1; 
BEGIN TRANSACTION;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;


SELECT mjera FROM test WHERE sifra = 5;
SELECT mjera FROM test WHERE sifra = 12;

UPDATE test SET mjera = 0 WHERE sifra = 5;

ROLLBACK TRANSACTION;


--4. zadatak
SET LOCK_TIMEOUT -1; 
BEGIN TRANSACTION;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;


SELECT mjera FROM test WHERE sifra = 3;

SELECT mjera FROM test WHERE sifra = 9;

UPDATE test SET mjera = 0 WHERE sifra = 3 OR sifra=9;

ROLLBACK TRANSACTION;


