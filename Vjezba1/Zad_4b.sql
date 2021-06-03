IF OBJECT_ID('rasporediPoGrupama') IS NOT NULL DROP PROCEDURE rasporediPoGrupama

GO
CREATE PROCEDURE dbo.rasporediPoGrupama 
AS
BEGIN

	DECLARE @jmbag CHAR(10);
	
	DECLARE db_cursor CURSOR FOR
		SELECT jmbag
		FROM stud
		ORDER BY prezStud ASC, imeStud ASC

	OPEN db_cursor

	FETCH NEXT FROM db_cursor INTO @jmbag

	WHILE (@@FETCH_STATUS = 0) BEGIN

		BEGIN TRY

			EXEC dbo.upisStudenta @jmbag = @jmbag;	

		END TRY
		BEGIN CATCH
			
			IF ERROR_NUMBER() != 50501 AND ERROR_NUMBER() != 50502
			BEGIN

				DECLARE @error_number INT;
				DECLARE @error_message VARCHAR(200);
				DECLARE @error_state INT;

				SET @error_number = ERROR_NUMBER();
				SET @error_message = ERROR_MESSAGE();
				SET @error_state = ERROR_STATE();

				SELECT @error_number, @error_message, @error_state;

			END

		END CATCH

		FETCH NEXT FROM db_cursor INTO @jmbag

	END

	CLOSE db_cursor
	DEALLOCATE db_cursor

END;
GO

EXEC dbo.rasporediPoGrupama;

SELECT * FROM studGrupa;

SELECT * FROM grupa;

--UPDATE grupa SET brojStud = 0;

--DELETE FROM studGrupa;

UPDATE grupa SET kapacitet = 0 WHERE oznGrupa = 'P1';