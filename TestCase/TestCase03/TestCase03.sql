USE HuongVietRestaurant
GO
--===============> TEST CASE 03 <==============

/*
- TestCase03: 
- Tình huống: Quản lý cập nhật hình ảnh món ăn (DISH) nhưng chưa commit thì khách hàng vào xem thông tin món ăn.
- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
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
	BEGIN
		PRINT 'Rollback!'
		ROLLBACK TRAN
	END
	ELSE
	BEGIN
		COMMIT TRAN
	END
GO

--TRANSACTION 2 --
IF OBJECT_ID('PROC_DIRTYREAD_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_DIRTYREAD_T2_LANG
GO
CREATE PROC PROC_DIRTYREAD_T2_LANG
	@id_agency nchar(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
	FROM MENU M JOIN DISH D 
	ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1
COMMIT TRAN
GO

-- TRANSACTION 2 FIX --
IF OBJECT_ID('PROC_DIRTYREAD_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_DIRTYREAD_T2_LANG
GO
CREATE PROC PROC_DIRTYREAD_T2_LANG
	@id_agency nchar(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
	SELECT M.id_agency, D.id_dish, M.unit, D.dish_name, D.type_dish, D.image, D.price
		FROM MENU M JOIN DISH D with (RepeatableRead)
		ON id_agency = @id_agency AND M.id_dish = D.id_dish AND M.isActive = 1 
	
COMMIT TRAN
GO

--T1
EXEC PROC_DIRTYREAD_T1_LANG 'dish_5', ''

--T2(Error)
EXEC PROC_DIRTYREAD_T2_LANG 'ag_1'

--T2(Fixed)
EXEC PROC_DIRTYREAD_T2_LANG 'ag_1'