USE HuongVietRestaurant
GO

--============> DEADLOCK <==========

--ChuanVo

--Lang

--ADMIN A đang xem  thông tin món bún bò tại chi nhánh 1 -> cập nhật số lượng món bún bò tại chi nhánh 1(chưa commit) delay 5s
--ADMIN B cũng xem  thông tin món bún bò tại chi nhánh 1 -> cập nhật số lượng món bún bò tại chi nhánh 1(commit)

--TRANSACTION 1 --
IF OBJECT_ID('PROC_DEADLOCK_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T1_LANG
GO
CREATE PROC PROC_DEADLOCK_T1_LANG
	@id_dish nchar(10),
	@id_agency nchar(10),
	@unit int
AS
BEGIN TRAN
	SELECT * 
	FROM MENU m WITH(HOLDLOCK)
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1
	WAITFOR DELAY '00:00:10'

	UPDATE MENU WITH(XLOCK)
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN

EXEC PROC_DEADLOCK_T1_LANG 'dish_1', 'ag_1', 11


--TRANSACTION 2 --
IF OBJECT_ID('PROC_DEADLOCK_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_LANG
GO
CREATE PROC PROC_DEADLOCK_T2_LANG
	@id_dish nchar(10),
	@id_agency nchar(10),
	@unit int
AS
BEGIN TRAN
	
	SELECT *
	FROM MENU m WITH(HOLDLOCK)
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1 
	WAITFOR DELAY '00:00:10'

	UPDATE MENU WITH (XLOCK)
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN
GO

EXEC PROC_DEADLOCK_T2_LANG 'dish_1', 'ag_1', 232
--TRANSACTION 2 FIX--
IF OBJECT_ID('PROC_DEADLOCK_T2_LANG', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T2_LANG
GO
CREATE PROC PROC_DEADLOCK_T2_LANG
	@id_dish nchar(10),
	@id_agency nchar(10),
	@unit int
AS
BEGIN TRAN
	
	SELECT *
	FROM MENU m WITH(NOLOCK)
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1 
	WAITFOR DELAY '00:00:10'

	UPDATE MENU WITH (XLOCK)
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN

EXEC PROC_DEADLOCK_T2_LANG 'dish_1', 'ag_1', 232

--AnHoa


--TrungDuc

--DangLam

