USE HuongVietRestaurant
GO
--===============> TEST CASE 21 <==============

/*
- TestCase21: 
- Tình huống:
--ADMIN A đang xem  thông tin món bún bò tại chi nhánh 1 -> cập nhật số lượng món bún bò tại chi nhánh 1(chưa commit) delay 5s
--ADMIN B cũng xem  thông tin món bún bò tại chi nhánh 1 -> cập nhật số lượng món bún bò tại chi nhánh 1(commit)

- Hướng dẫn sử dụng: 
	+ Bước 1: Chạy TRANSACTION T1 
	+ Bước 2: Trong vòng 15 giây kể từ khi chạy TRANSACTION T1 ta chạy TRANSACTION T2
*/
--TRANSACTION 1 --
IF OBJECT_ID('PROC_DEADLOCK_T1_LANG', N'P') IS NOT NULL DROP PROC PROC_DEADLOCK_T1_LANG
GO
CREATE PROC PROC_DEADLOCK_T1_LANG
	@id_dish nchar(10),
	@id_agency nchar(10),
	@unit int
AS
BEGIN TRAN
	set tran isolation level repeatable read
	SELECT * 
	FROM MENU m
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1
	WAITFOR DELAY '00:00:15'

	UPDATE MENU
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN
GO



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
	FROM MENU m
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1 

	UPDATE MENU
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN
GO



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
	FROM MENU m WITH (NOLOCK) 
	WHERE m.id_dish = @id_dish and m.id_agency = @id_agency and m.isActive = 1 

	UPDATE MENU
	SET unit = @unit
	WHERE id_dish = @id_dish and id_agency = @id_agency and isActive = 1
	
COMMIT TRAN
GO



--T1
EXEC PROC_DEADLOCK_T1_LANG N'dish_5', N'ag_1', 50

--T2
EXEC PROC_DEADLOCK_T2_LANG N'dish_5', N'ag_1', 100 

--T2(FIXED)
EXEC PROC_DEADLOCK_T2_LANG N'dish_5', N'ag_1', 100 