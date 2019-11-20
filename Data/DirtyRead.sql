USE HuongVietRestaurant
GO

--============> DIRTY READ <==========

--ChuanVo
IF OBJECT_ID('sp_DirtyReadChuanVo', 'p') is not null DROP PROC	sp_DirtyReadChuanVo
GO

CREATE PROC sp_DirtyReadChuanVo @id_dish nchar(10), @price int
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
IF OBJECT_ID('sp_TestCaseDirtyReadChuanVo_F', 'p') is not null DROP PROC sp_TestCaseDirtyReadChuanVo_F
GO
-- Create
CREATE PROC sp_TestCaseDirtyReadChuanVo_F @id_dish nchar(10)
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
IF OBJECT_ID('sp_TestCaseDirtyReadChuanVo_T', 'p') is not null DROP PROC sp_TestCaseDirtyReadChuanVo_T
GO

CREATE PROC sp_TestCaseDirtyReadChuanVo_T @id_dish nchar(10)
AS
BEGIN
	BEGIN TRAN
		SELECT * 
		FROM DISH 
		WHERE id_dish = @id_dish
	COMMIT TRAN
END

--Lang
--Quản lý cập nhật hình ảnh món ăn (DISH) nhưng chưa commit thì khách hàng vào xem thông tin món ăn.
--TRANSACTION 1--
IF OBJECT_ID('PROC_DIRTYREAD_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_DIRTYREAD_T1_LANG
GO
CREATE PROC PROC_DIRTYREAD_T1_LANG
	@id_dish nchar(10),
	@image nchar(50)
AS
BEGIN TRAN
	UPDATE DISH
	SET image = @image
	WHERE id_dish = @id_dish
	WAITFOR DELAY '00:00:10'
	IF @image = ''
		ROLLBACK 
COMMIT TRAN
GO

EXEC PROC_DIRTYREAD_T1_LANG 'dish_5', ''

--TRANSACTION 2 --
IF OBJECT_ID('PROC_DIRTYREAD_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_DIRTYREAD_T2_LANG
GO
CREATE PROC PROC_DIRTYREAD_T2_LANG
	@id_dish nchar(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT *
	FROM DISH 
	WHERE id_dish = @id_dish
COMMIT TRAN
GO

EXEC PROC_DIRTYREAD_T2_LANG 'dish_5'

-- TRANSACTION 2 FIX --
IF OBJECT_ID('PROC_DIRTYREAD_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_DIRTYREAD_T2_LANG
GO
CREATE PROC PROC_DIRTYREAD_T2_LANG
	@id_dish nchar(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SELECT *
	FROM DISH with (RepeatableRead)
	WHERE id_dish = @id_dish
COMMIT TRAN
GO

EXEC PROC_DIRTYREAD_T2_LANG 'dish_5'