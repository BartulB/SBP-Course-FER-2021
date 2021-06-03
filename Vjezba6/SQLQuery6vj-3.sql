
GO
CREATE PROCEDURE montirajUzTrans @sifAlat INT, @oznStroj CHAR(10)
AS
BEGIN TRANSACTION


		BEGIN TRY

			INSERT INTO montaza VALUES (@oznStroj, @sifAlat)

		END TRY

		BEGIN CATCH

			ROLLBACK TRANSACTION
			DECLARE @errorPKMontaza INT = ERROR_NUMBER()

			--error 2627 is violation of unique constraint (including primary key). Cannot insert duplicate key in object
			IF (@errorPKMontaza = 2627)
				THROW 50511, 'Alat je zauzet', 1;

		END CATCH
		
		BEGIN TRY
			UPDATE alat SET montiran = 'D' WHERE sifAlat = @sifAlat
		END TRY

		BEGIN CATCH
		
			ROLLBACK TRANSACTION
			THROW

		END CATCH

		BEGIN TRY 
			UPDATE stroj SET brojMontiranih = brojMontiranih+1 WHERE oznStroj = @oznStroj
		END TRY

		BEGIN CATCH 
		
			ROLLBACK TRANSACTION
			DECLARE @errorKapacitet INT = ERROR_NUMBER()

			--error 547 is used dor any constraint violation
			IF (@errorKapacitet = 547) 
				THROW 50512, 'Kapacitet stroja je popunjen', 1

		END CATCH


COMMIT TRANSACTION
GO

SELECT * FROM montaza;
SELECT * FROM alat;
SELECT * FROM stroj;

--test
EXEC dbo.montirajUzTrans @sifAlat = 130, @oznStroj = 'S2'
SELECT XACT_STATE()

--a
EXEC dbo.montirajUzTrans @sifAlat = 137, @oznStroj = 'S2'

--b
EXEC dbo.montirajUzTrans @sifAlat = 101, @oznStroj = 'S4'

--c
EXEC dbo.montirajUzTrans @sifAlat = 103, @oznStroj = 'S6'
SELECT XACT_STATE()

--d
EXEC dbo.montirajUzTrans @sifAlat = 103, @oznStroj = 'S4'
SELECT XACT_STATE()

--e
EXEC dbo.montirajUzTrans @sifAlat = 99, @oznStroj = 'S6'
SELECT XACT_STATE()


