USE HuongVietRestaurant
GO

USE HuongVietRestaurant
GO

--============> LOST UPDATE <==========

--ChuanVo

--Lang
--Admin nhà hàng đang cập nhật số lượng món Phở bò tại chi nhánh 1 giảm đi @unit (số lượng) (chưa commit), 
 --trong khi đó Admin A tại chi nhánh 1 bấm  "Thanh toán" 1 hóa đơn có món Phở bò (update số lượng món phở tại chi nhánh 1). 
 --TRANSACTION 1--
IF OBJECT_ID('PROC_LOSTUPDATE_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T1_LANG
GO
CREATE PROC PROC_LOSTUPDATE_T1_LANG
	@id_dish nchar(10),
	@unit int,
	@id_agency nchar(10)
AS
BEGIN TRAN
	DECLARE @unitnew int

	SELECT @unitnew = unit
	FROM MENU
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	WAITFOR DELAY '00:00:10'
	SET @unitnew = @unitnew - @unit
	
	UPDATE MENU 
	SET unit = @unitnew
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
COMMIT TRAN
GO

EXEC PROC_LOSTUPDATE_T1_LANG 'dish_5', 2, 'ag_1'

 --TRANSACTION 2--
IF OBJECT_ID('PROC_LOSTUPDATE_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T2_LANG
GO
CREATE PROC PROC_LOSTUPDATE_T2_LANG
	@id_dish nchar(10),
	@unit int,
	@id_agency nchar(10)
AS
BEGIN TRAN
	DECLARE @unitnew int

	SELECT @unitnew = unit
	FROM MENU
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	SET @unitnew = @unitnew - @unit
	
	UPDATE MENU 
	SET unit = @unitnew
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
COMMIT TRAN
GO

EXEC PROC_LOSTUPDATE_T2_LANG 'dish_5', 10, 'ag_1'

--TRANSACTION 2 FIX --
IF OBJECT_ID('PROC_LOSTUPDATE_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_LOSTUPDATE_T2_LANG
GO
CREATE PROC PROC_LOSTUPDATE_T2_LANG
	@id_dish nchar(10),
	@unit int,
	@id_agency nchar(10)
AS
BEGIN TRAN
	SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
	DECLARE @unitnew int

	SELECT @unitnew = unit
	FROM MENU
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	SET @unitnew = @unitnew - @unit
	
	UPDATE MENU 
	SET unit = @unitnew
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
COMMIT TRAN
GO
EXEC PROC_LOSTUPDATE_T2_LANG 'dish_5', 10, 'ag_1'
--AnHoa


--TrungDuc

--DangLam

