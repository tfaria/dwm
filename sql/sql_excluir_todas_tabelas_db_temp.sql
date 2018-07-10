USE DB_TEMP

DECLARE @SQL NVARCHAR(500) DECLARE @CURSOR CURSOR

/*EXCLUIR TODAS AS CONSTRAINTS DO BANCO DB_TEMP*/
SET @CURSOR = CURSOR FAST_FORWARD FOR
SELECT DISTINCT SQL = 'ALTER TABLE [' + TC2.TABLE_NAME + '] DROP [' + RC1.CONSTRAINT_NAME + ']'
FROM INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS RC1
LEFT JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS TC2 ON TC2.CONSTRAINT_NAME =RC1.CONSTRAINT_NAME

OPEN @CURSOR FETCH NEXT FROM @CURSOR INTO @SQL

WHILE (@@FETCH_STATUS = 0)
BEGIN
EXEC SP_EXECUTESQL @SQL
FETCH NEXT FROM @CURSOR INTO @SQL
END

CLOSE @CURSOR DEALLOCATE @CURSOR
GO

/*EXCLUIR TODAS AS TABELAS DO BANCO DB_TEMP*/
EXEC SP_MSFOREACHTABLE 'DROP TABLE ?'
GO