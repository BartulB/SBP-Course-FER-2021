
GO
CREATE PROCEDURE montirajBezTrans @sifAlat INT, @oznStroj CHAR(10)
AS
BEGIN

	BEGIN TRY

		BEGIN TRY

			INSERT INTO montaza VALUES (@oznStroj, @sifAlat)

		END TRY

		BEGIN CATCH

			DECLARE @errorPKMontaza INT = ERROR_NUMBER()

			--error 2627 is violation of unique constraint (including primary key). Cannot insert duplicate key in object
			IF (@errorPKMontaza = 2627)
				THROW 50511, 'Alat je zauzet', 1;

		END CATCH
		
		UPDATE alat SET montiran = 'D' WHERE sifAlat = @sifAlat

		BEGIN TRY 
			UPDATE stroj SET brojMontiranih = brojMontiranih+1 WHERE oznStroj = @oznStroj
		END TRY

		BEGIN CATCH 
		
			DECLARE @errorKapacitet INT = ERROR_NUMBER()

			--error 547 is used dor any constraint violation
			IF (@errorKapacitet = 547) 
				THROW 50512, 'Kapacitet stroja je popunjen', 1

		END CATCH

	END TRY

	BEGIN CATCH
		
		THROW

	END CATCH
END
GO

SELECT * FROM montaza;
SELECT * FROM alat;
SELECT * FROM stroj;

--test
EXEC dbo.montirajBezTrans @sifAlat = 137, @oznStroj = 'S2'

--a
EXEC dbo.montirajBezTrans @sifAlat = 137, @oznStroj = 'S2'

--b
EXEC dbo.montirajBezTrans @sifAlat = 101, @oznStroj = 'S4'

--c
EXEC dbo.montirajBezTrans @sifAlat = 103, @oznStroj = 'S6'

--d
EXEC dbo.montirajBezTrans @sifAlat = 103, @oznStroj = 'S4'

--e
EXEC dbo.montirajBezTrans @sifAlat = 99, @oznStroj = 'S6'


