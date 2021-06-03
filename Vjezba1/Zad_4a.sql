IF OBJECT_ID('upisStudenta') IS NOT NULL DROP PROCEDURE upisStudenta

GO
CREATE PROCEDURE dbo.upisStudenta @jmbag CHAR(10)
AS
BEGIN
	DECLARE @min_grupa CHAR(10);

	SET @min_grupa =
	(SELECT TOP(1) oznGrupa
		FROM grupa
		ORDER BY CAST(brojStud AS DECIMAL)/kapacitet, oznGrupa
	);

	DECLARE @broj_slobodnih_grupa INT;

	SET @broj_slobodnih_grupa = (SELECT COUNT(*) FROM grupa WHERE grupa.brojStud < grupa.kapacitet)

	IF @jmbag IN (SELECT jmbag FROM studGrupa)
		THROW 50501, 'Student je već upisan u nastavnu grupu', 1

	IF @jmbag NOT IN (SELECT jmbag FROM stud)
		THROW 50502, 'Student ne postoji', 1

	IF (@broj_slobodnih_grupa = 0)
		THROW 50503, 'Sve grupe su već popunjene', 1

	INSERT INTO studGrupa VALUES(@jmbag, @min_grupa);
	UPDATE grupa
		SET brojStud = brojStud + 1
		WHERE oznGrupa = @min_grupa;

END;
GO

EXEC dbo.upisStudenta @jmbag = '0555000828';

SELECT * FROM studGrupa;

SELECT * FROM grupa;
