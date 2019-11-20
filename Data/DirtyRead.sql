USE HuongVietRestaurant
GO

--============> DIRTY READ <==========

--ChuanVo
IF OBJECT_ID('PROC_DIRTYREAD_T1_CHUANVO', 'p') is not null DROP PROC PROC_DIRTYREAD_T1_CHUANVO
GO

CREATE PROC PROC_DIRTYREAD_T1_CHUANVO @id_dish nchar(10), @price int
AS
BEGIN
	BEGIN TRAN UpdateDishPrice
		UPDATE DISH 
		SET price = @price
		WHERE id_dish = @id_dish 
		WAITFOR DELAY '00:00:15'

		IF @@ERROR != 0
		BEGIN
			PRINT 'Rollback!'
			ROLLBACK TRAN UpdateDishPrice
		END
	COMMIT TRAN UpdateDishPrice
END

--TestCase
IF OBJECT_ID('PROC_DIRTYREAD_T2_F_CHUANVO', 'p') is not null DROP PROC PROC_DIRTYREAD_T2_F_CHUANVO
GO
-- Create
CREATE PROC PROC_DIRTYREAD_T2_F_CHUANVO @id_dish nchar(10)
AS
BEGIN
	BEGIN TRAN
	SET TRAN ISOLATION LEVEL REPEATABLE READ 
		SELECT * 
		FROM DISH 
		WHERE id_dish = @id_dish
	COMMIT TRAN
END

-- Handle: Use insolation level READ COMMITED to handle this error and it is default insolation level of sql server
IF OBJECT_ID('PROC_DIRTYREAD_T2_T_CHUANVO', 'p') is not null DROP PROC PROC_DIRTYREAD_T2_T_CHUANVO
GO

CREATE PROC PROC_DIRTYREAD_T2_T_CHUANVO @id_dish nchar(10)
AS
BEGIN
	BEGIN TRAN
		SELECT * 
		FROM DISH 
		WHERE id_dish = @id_dish
	COMMIT TRAN
END

EXEC PROC_DIRTYREAD_T2_T_CHUANVO 'dish_1'