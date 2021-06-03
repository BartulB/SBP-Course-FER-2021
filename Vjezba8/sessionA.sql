--session A

use labprof8 -- da ti se obavlja nad bazom labprof8
set context_info 7; -- da ti oni njihovi pomocni upiti rade
select @@spid -- id sjednice

--2. zad
 
 --Naizmjenice A:
SET LOCK_TIMEOUT -1; 
BEGIN TRANSACTION;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

SELECT mjera FROM test WHERE sifra = 5;

UPDATE test SET mjera = 81.0 WHERE sifra = 8;

ROLLBACK TRANSACTION; 